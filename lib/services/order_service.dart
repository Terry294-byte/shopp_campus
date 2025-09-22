import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/order_model.dart';
import '../providers/cart_provider.dart';

class OrderService {
  final String baseUrl = "http://localhost:5000"; // Update this to match your backend URL

  Future<OrderModel> createOrder({
    required String userId,
    required String userEmail,
    required String userName,
    required String userPhone,
    required String deliveryAddress,
    required List<CartItem> cartItems,
    required double totalAmount,
    String? checkoutRequestId,
  }) async {
    try {
      // Convert cart items to order items
      final orderItems = cartItems.map((item) => OrderItem(
        productId: item.id,
        title: item.title,
        price: item.price,
        quantity: item.quantity,
        imageUrl: item.imageUrl,
      )).toList();

      final order = OrderModel(
        id: 'temp_${DateTime.now().millisecondsSinceEpoch}', // Temporary ID until backend assigns one
        userId: userId,
        userEmail: userEmail,
        userName: userName,
        userPhone: userPhone,
        deliveryAddress: deliveryAddress,
        items: orderItems,
        totalAmount: totalAmount,
        status: 'pending',
        checkoutRequestId: checkoutRequestId,
        createdAt: DateTime.now(),
      );

      // TODO: Send order to backend when backend order creation endpoint is ready
      // For now, return the local order object
      return order;

    } catch (e) {
      throw Exception("Error creating order: $e");
    }
  }

  Future<OrderModel?> getOrderById(String orderId) async {
    try {
      final response = await http.get(
        Uri.parse("$baseUrl/api/order/$orderId"),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        if (responseData['success'] && responseData['order'] != null) {
          return OrderModel.fromJson(responseData['order']);
        }
      }
      return null;
    } catch (e) {
      print('Error fetching order: $e');
      return null;
    }
  }

  Future<List<OrderModel>> getUserOrders(String userId) async {
    try {
      // TODO: Implement backend endpoint for fetching user orders
      // For now, return empty list
      return [];
    } catch (e) {
      print('Error fetching user orders: $e');
      return [];
    }
  }

  Future<bool> updateOrderStatus(String orderId, String status) async {
    try {
      // TODO: Implement backend endpoint for updating order status
      // For now, return false
      return false;
    } catch (e) {
      print('Error updating order status: $e');
      return false;
    }
  }

  Future<bool> cancelOrder(String orderId) async {
    try {
      // TODO: Implement backend endpoint for canceling orders
      // For now, return false
      return false;
    } catch (e) {
      print('Error canceling order: $e');
      return false;
    }
  }
}
