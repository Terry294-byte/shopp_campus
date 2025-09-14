import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/app_colors.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  bool _pushNotifications = true;
  bool _emailNotifications = true;
  bool _orderUpdates = true;
  bool _promotionalOffers = false;
  bool _newProducts = true;

  @override
  void initState() {
    super.initState();
    _loadNotificationSettings();
  }

  Future<void> _loadNotificationSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _pushNotifications = prefs.getBool('push_notifications') ?? true;
      _emailNotifications = prefs.getBool('email_notifications') ?? true;
      _orderUpdates = prefs.getBool('order_updates') ?? true;
      _promotionalOffers = prefs.getBool('promotional_offers') ?? false;
      _newProducts = prefs.getBool('new_products') ?? true;
    });
  }

  Future<void> _saveNotificationSetting(String key, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, value);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        backgroundColor: isDark ? AppColors.darkGrey : AppColors.primaryRed,
        foregroundColor: AppColors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Text(
              'Notification Settings',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: isDark ? AppColors.white : AppColors.black,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Choose what notifications you want to receive',
              style: TextStyle(
                fontSize: 16,
                color: isDark ? AppColors.white.withOpacity(0.7) : AppColors.black.withOpacity(0.7),
              ),
            ),
            const SizedBox(height: 30),

            // Push Notifications
            Card(
              elevation: 2,
              child: SwitchListTile(
                title: Text(
                  'Push Notifications',
                  style: TextStyle(
                    color: isDark ? AppColors.white : AppColors.black,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                subtitle: Text(
                  'Receive push notifications on your device',
                  style: TextStyle(
                    color: isDark ? AppColors.white.withOpacity(0.7) : AppColors.black.withOpacity(0.7),
                  ),
                ),
                value: _pushNotifications,
                onChanged: (value) {
                  setState(() {
                    _pushNotifications = value;
                  });
                  _saveNotificationSetting('push_notifications', value);
                },
                activeColor: AppColors.primaryRed,
              ),
            ),

            const SizedBox(height: 10),

            // Email Notifications
            Card(
              elevation: 2,
              child: SwitchListTile(
                title: Text(
                  'Email Notifications',
                  style: TextStyle(
                    color: isDark ? AppColors.white : AppColors.black,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                subtitle: Text(
                  'Receive notifications via email',
                  style: TextStyle(
                    color: isDark ? AppColors.white.withOpacity(0.7) : AppColors.black.withOpacity(0.7),
                  ),
                ),
                value: _emailNotifications,
                onChanged: (value) {
                  setState(() {
                    _emailNotifications = value;
                  });
                  _saveNotificationSetting('email_notifications', value);
                },
                activeColor: AppColors.primaryRed,
              ),
            ),

            const SizedBox(height: 20),
            Text(
              'Specific Notifications',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isDark ? AppColors.white : AppColors.black,
              ),
            ),
            const SizedBox(height: 10),

            // Order Updates
            Card(
              elevation: 2,
              child: SwitchListTile(
                title: Text(
                  'Order Updates',
                  style: TextStyle(
                    color: isDark ? AppColors.white : AppColors.black,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                subtitle: Text(
                  'Get notified about your order status',
                  style: TextStyle(
                    color: isDark ? AppColors.white.withOpacity(0.7) : AppColors.black.withOpacity(0.7),
                  ),
                ),
                value: _orderUpdates,
                onChanged: (value) {
                  setState(() {
                    _orderUpdates = value;
                  });
                  _saveNotificationSetting('order_updates', value);
                },
                activeColor: AppColors.primaryRed,
              ),
            ),

            const SizedBox(height: 10),

            // Promotional Offers
            Card(
              elevation: 2,
              child: SwitchListTile(
                title: Text(
                  'Promotional Offers',
                  style: TextStyle(
                    color: isDark ? AppColors.white : AppColors.black,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                subtitle: Text(
                  'Receive offers and discounts',
                  style: TextStyle(
                    color: isDark ? AppColors.white.withOpacity(0.7) : AppColors.black.withOpacity(0.7),
                  ),
                ),
                value: _promotionalOffers,
                onChanged: (value) {
                  setState(() {
                    _promotionalOffers = value;
                  });
                  _saveNotificationSetting('promotional_offers', value);
                },
                activeColor: AppColors.primaryRed,
              ),
            ),

            const SizedBox(height: 10),

            // New Products
            Card(
              elevation: 2,
              child: SwitchListTile(
                title: Text(
                  'New Products',
                  style: TextStyle(
                    color: isDark ? AppColors.white : AppColors.black,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                subtitle: Text(
                  'Get notified when new products are added',
                  style: TextStyle(
                    color: isDark ? AppColors.white.withOpacity(0.7) : AppColors.black.withOpacity(0.7),
                  ),
                ),
                value: _newProducts,
                onChanged: (value) {
                  setState(() {
                    _newProducts = value;
                  });
                  _saveNotificationSetting('new_products', value);
                },
                activeColor: AppColors.primaryRed,
              ),
            ),

            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Notification settings saved!')),
                  );
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryRed,
                  foregroundColor: AppColors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Save Settings',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
