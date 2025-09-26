import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/product_model.dart' as product_model;
import '../providers/group_buy_provider.dart';
import '../constants/app_colors.dart';
import '../widgets/title_text.dart';

class CreateGroupBuyScreen extends StatefulWidget {
  final product_model.Product product;

  const CreateGroupBuyScreen({super.key, required this.product});

  @override
  State<CreateGroupBuyScreen> createState() => _CreateGroupBuyScreenState();
}

class _CreateGroupBuyScreenState extends State<CreateGroupBuyScreen> {
  int _targetParticipants = 3;
  double _discountPercentage = 10.0;

  @override
  Widget build(BuildContext context) {
    final groupBuyProvider = Provider.of<GroupBuyProvider>(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const TitleTextWidget(label: 'Create Group Buy', fontSize: 20),
        backgroundColor: isDark ? Colors.grey[900] : AppColors.primaryRed,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              color: isDark ? AppColors.darkGrey.withOpacity(0.8) : AppColors.white,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        widget.product.imageUrl,
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TitleTextWidget(
                            label: widget.product.title,
                            fontSize: 18,
                            color: isDark ? Colors.white : AppColors.black,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '\$${widget.product.price.toStringAsFixed(2)}',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primaryRed,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            TitleTextWidget(
              label: 'Group Buy Settings',
              fontSize: 18,
              color: isDark ? Colors.white : AppColors.black,
            ),
            const SizedBox(height: 16),
            Card(
              color: isDark ? AppColors.darkGrey.withOpacity(0.8) : AppColors.white,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Target Participants: $_targetParticipants',
                          style: TextStyle(
                            fontSize: 16,
                            color: isDark ? Colors.white : AppColors.black,
                          ),
                        ),
                        Row(
                          children: [
                            IconButton(
                              onPressed: _targetParticipants > 2
                                  ? () => setState(() => _targetParticipants--)
                                  : null,
                              icon: Icon(
                                Icons.remove,
                                color: isDark ? Colors.white : AppColors.black,
                              ),
                            ),
                            IconButton(
                              onPressed: _targetParticipants < 10
                                  ? () => setState(() => _targetParticipants++)
                                  : null,
                              icon: Icon(
                                Icons.add,
                                color: isDark ? Colors.white : AppColors.black,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Discount: ${_discountPercentage.toStringAsFixed(1)}%',
                          style: TextStyle(
                            fontSize: 16,
                            color: isDark ? Colors.white : AppColors.black,
                          ),
                        ),
                        SizedBox(
                          width: 120,
                          child: Slider(
                            value: _discountPercentage,
                            min: 5,
                            max: 30,
                            divisions: 5,
                            onChanged: (value) => setState(() => _discountPercentage = value),
                            activeColor: AppColors.primaryRed,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Discounted Price: \$${(widget.product.price * (1 - _discountPercentage / 100)).toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryRed,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Invite $_targetParticipants friends to buy together and get ${_discountPercentage.toStringAsFixed(1)}% off!',
              style: TextStyle(
                fontSize: 14,
                color: isDark ? Colors.white70 : AppColors.lightGrey,
              ),
              textAlign: TextAlign.center,
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: groupBuyProvider.isLoading
                    ? null
                    : () async {
                        await groupBuyProvider.createGroupBuy(
                          widget.product.id,
                          widget.product.title,
                          widget.product.imageUrl,
                          widget.product.price,
                          _targetParticipants,
                          _discountPercentage,
                        );
                        if (mounted) Navigator.pop(context);
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryRed,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: groupBuyProvider.isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        'Create Group Buy',
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
