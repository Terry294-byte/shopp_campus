import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../providers/cart_provider.dart';
import '../../providers/notification_provider.dart';
import '../../services/auth_service.dart';
import '../../services/mpesa_service.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();

  bool _isProcessingPayment = false;

  // Sample list of locations for autocomplete
  final List<String> _locations = [
    'Nairobi',
    'Mombasa',
    'Kisumu',
    'Nakuru',
    'Eldoret',
    'Thika',
    'Kitale',
    'Naivasha',
    'Machakos',
    'Malindi',
  ];

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final authService = Provider.of<AuthService>(context, listen: false);
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      final userData = await authService.getCurrentUserData();
      if (userData != null) {
        setState(() {
          _nameController.text = userData.name;
          _emailController.text = userData.email;
        });
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _processPayment() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isProcessingPayment = true;
    });

    try {
      final mpesaService = MpesaService();
      final phoneNumber = _phoneController.text.trim();
      final amount = Provider.of<CartProvider>(context, listen: false).totalAmount;

      print('🚀 Starting payment process...');
      final response = await mpesaService.initiateStkPush(phoneNumber, amount);

      if (mounted) {
        setState(() {
          _isProcessingPayment = false;
        });

        if (response['ResponseCode'] == '0') {
          final checkoutRequestId = response['CheckoutRequestID'];
          print('✅ STK Push initiated successfully. Checkout ID: $checkoutRequestId');

          // Show success dialog with payment instructions
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (ctx) => AlertDialog(
              title: const Text('Payment Prompt Sent'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('A payment prompt has been sent to $phoneNumber.'),
                  const SizedBox(height: 8),
                  const Text('Please complete the payment on your phone.'),
                  const SizedBox(height: 8),
                  Text('Checkout ID: $checkoutRequestId',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => _checkPaymentStatus(ctx, checkoutRequestId),
                  child: const Text('Check Payment Status'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(ctx).pop();
                    Navigator.of(context).pushNamedAndRemoveUntil('/products', (route) => false);
                  },
                  child: const Text('Continue Shopping'),
                ),
              ],
            ),
          );
        } else {
          // Show error message from M-Pesa response
          showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
              title: const Text('Payment Failed'),
              content: Text('Failed to initiate payment: ${response['CustomerMessage'] ?? response['errorMessage'] ?? 'Unknown error'}'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(ctx).pop(),
                  child: const Text('OK'),
                ),
              ],
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isProcessingPayment = false;
        });

        String errorMessage = e.toString();
        if (errorMessage.contains('Connection refused')) {
          errorMessage = 'Cannot connect to payment server. Please ensure the backend is running and try again.';
        }

        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('Payment Error'),
            content: Text('An error occurred during payment: $errorMessage'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    }
  }

  Future<void> _checkPaymentStatus(BuildContext dialogContext, String checkoutRequestId) async {
    try {
      Navigator.of(dialogContext).pop(); // Close the current dialog

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (ctx) => const AlertDialog(
          title: Text('Checking Payment Status'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('Please wait while we check your payment status...'),
            ],
          ),
        ),
      );

      final mpesaService = MpesaService();
      final statusResponse = await mpesaService.checkPaymentStatus(checkoutRequestId);

      if (mounted) {
        Navigator.of(context).pop(); // Close the checking dialog

        if (statusResponse['success'] && statusResponse['payment']) {
          final payment = statusResponse['payment'];

          if (payment['status'] == 'completed') {
            // Payment successful
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (ctx) => AlertDialog(
                title: const Text('Payment Successful!'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Your payment has been completed successfully.'),
                    const SizedBox(height: 8),
                    Text('Receipt Number: ${payment['mpesaReceiptNumber'] ?? 'N/A'}'),
                    if (payment['order'] != null)
                      Text('Order ID: ${payment['order']['id']}'),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      // Create order notification
                      final notificationProvider = Provider.of<NotificationProvider>(context, listen: false);
                      final orderId = payment['order'] != null ? payment['order']['id'] : 'ORD_${DateTime.now().millisecondsSinceEpoch}';
                      final userName = _nameController.text;

                      notificationProvider.createOrderNotification(
                        orderId: orderId,
                        status: 'confirmed',
                        userName: userName,
                      );

                      Provider.of<CartProvider>(context, listen: false).clearCart();
                      Navigator.of(ctx).pop();
                      Navigator.of(context).pushNamedAndRemoveUntil('/products', (route) => false);
                    },
                    child: const Text('Continue Shopping'),
                  ),
                ],
              ),
            );
          } else {
            // Payment still pending or failed
            showDialog(
              context: context,
              builder: (ctx) => AlertDialog(
                title: const Text('Payment Status'),
                content: Text(payment['status'] == 'pending'
                  ? 'Your payment is still being processed. Please check again in a few minutes.'
                  : 'Your payment could not be completed. Please try again.'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(ctx).pop(),
                    child: const Text('OK'),
                  ),
                ],
              ),
            );
          }
        } else {
          showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
              title: const Text('Status Check Failed'),
              content: const Text('Could not check payment status. Please try again later.'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(ctx).pop(),
                  child: const Text('OK'),
                ),
              ],
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        Navigator.of(context).pop(); // Close the checking dialog
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('Error'),
            content: Text('Error checking payment status: $e'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final cartItems = cartProvider.items;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
      ),
      body: Column(
        children: [
          // Order Summary
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.grey[50],
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Order Summary',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                ...cartItems.map((item) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          '${item.title} (x${item.quantity})',
                          style: const TextStyle(fontSize: 14),
                        ),
                      ),
                      Text(
                        'KSH ${(item.price * item.quantity).toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                )),
                const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Total Amount:',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'KSH ${cartProvider.totalAmount.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Delivery Information Form
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Delivery Information',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Name
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        labelText: 'Full Name',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.person),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Email
                    TextFormField(
                      controller: _emailController,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.email),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        if (!value.contains('@')) {
                          return 'Please enter a valid email';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Phone
                    TextFormField(
                      controller: _phoneController,
                      decoration: const InputDecoration(
                        labelText: 'M-Pesa Phone Number',
                        hintText: 'e.g., 254712345678',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.phone),
                      ),
                      keyboardType: TextInputType.phone,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your M-Pesa phone number';
                        }
                        if (!RegExp(r'^254\d{9}$').hasMatch(value)) {
                          return 'Please enter a valid M-Pesa phone number (254XXXXXXXXX)';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Address with Autocomplete
                    Autocomplete<String>(
                      optionsBuilder: (TextEditingValue textEditingValue) {
                        if (textEditingValue.text == '') {
                          return const Iterable<String>.empty();
                        }
                        return _locations.where((String option) {
                          return option.toLowerCase().contains(textEditingValue.text.toLowerCase());
                        });
                      },
                      onSelected: (String selection) {
                        _addressController.text = selection;
                      },
                      fieldViewBuilder: (BuildContext context, TextEditingController fieldTextEditingController, FocusNode fieldFocusNode, VoidCallback onFieldSubmitted) {
                        fieldTextEditingController.text = _addressController.text;
                        return TextFormField(
                          controller: fieldTextEditingController,
                          focusNode: fieldFocusNode,
                          decoration: const InputDecoration(
                            labelText: 'Delivery Address',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.location_on),
                          ),
                          maxLines: 1,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your delivery address';
                            }
                            return null;
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Payment Button
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: const Offset(0, -3),
                ),
              ],
            ),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isProcessingPayment ? null : _processPayment,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: _isProcessingPayment
                    ? const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          ),
                          SizedBox(width: 12),
                          Text('Processing Payment...'),
                        ],
                      )
                    : Text(
                        'Pay KSH ${cartProvider.totalAmount.toStringAsFixed(2)}',
                        style: const TextStyle(fontSize: 16),
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
