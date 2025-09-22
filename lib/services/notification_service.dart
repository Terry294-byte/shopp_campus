import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/notification_model.dart';

class NotificationService {
  static const String _notificationsKey = 'user_notifications';
  static const String _settingsKey = 'notification_settings';

  // Default notification settings
  static const Map<String, bool> _defaultSettings = {
    'push_notifications': true,
    'email_notifications': true,
    'order_updates': true,
    'promotional_offers': false,
    'new_products': true,
    'cart_reminders': true,
    'wishlist_updates': true,
    'security_alerts': true,
  };

  // Get all notifications
  Future<List<NotificationModel>> getNotifications() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final notificationsJson = prefs.getStringList(_notificationsKey) ?? [];

      return notificationsJson
          .map((json) => NotificationModel.fromJson(jsonDecode(json)))
          .toList()
          .cast<NotificationModel>();
    } catch (e) {
      print('Error loading notifications: $e');
      return [];
    }
  }

  // Get unread notifications count
  Future<int> getUnreadCount() async {
    final notifications = await getNotifications();
    return notifications.where((notification) => !notification.isRead).length;
  }

  // Add a new notification
  Future<void> addNotification(NotificationModel notification) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final notifications = await getNotifications();

      // Add new notification at the beginning
      notifications.insert(0, notification);

      // Keep only the latest 100 notifications to prevent storage bloat
      if (notifications.length > 100) {
        notifications.removeRange(100, notifications.length);
      }

      // Save to storage
      final notificationsJson = notifications
          .map((n) => jsonEncode(n.toJson()))
          .toList();

      await prefs.setStringList(_notificationsKey, notificationsJson);
    } catch (e) {
      print('Error adding notification: $e');
    }
  }

  // Mark notification as read
  Future<void> markAsRead(String notificationId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final notifications = await getNotifications();

      final index = notifications.indexWhere((n) => n.id == notificationId);
      if (index != -1) {
        notifications[index] = notifications[index].copyWith(isRead: true);
        await _saveNotifications(notifications);
      }
    } catch (e) {
      print('Error marking notification as read: $e');
    }
  }

  // Mark all notifications as read
  Future<void> markAllAsRead() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final notifications = await getNotifications();

      final updatedNotifications = notifications
          .map((n) => n.copyWith(isRead: true))
          .toList();

      await _saveNotifications(updatedNotifications);
    } catch (e) {
      print('Error marking all notifications as read: $e');
    }
  }

  // Delete a notification
  Future<void> deleteNotification(String notificationId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final notifications = await getNotifications();

      notifications.removeWhere((n) => n.id == notificationId);
      await _saveNotifications(notifications);
    } catch (e) {
      print('Error deleting notification: $e');
    }
  }

  // Clear all notifications
  Future<void> clearAllNotifications() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList(_notificationsKey, []);
    } catch (e) {
      print('Error clearing notifications: $e');
    }
  }

  // Get notifications by type
  Future<List<NotificationModel>> getNotificationsByType(NotificationType type) async {
    final notifications = await getNotifications();
    return notifications.where((n) => n.type == type).toList();
  }

  // Get notification settings
  Future<Map<String, bool>> getNotificationSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final settingsJson = prefs.getString(_settingsKey);

      if (settingsJson != null) {
        final Map<String, dynamic> decoded = jsonDecode(settingsJson);
        return decoded.map((key, value) => MapEntry(key, value as bool));
      }
    } catch (e) {
      print('Error loading notification settings: $e');
    }

    return Map.from(_defaultSettings);
  }

  // Save notification settings
  Future<void> saveNotificationSettings(Map<String, bool> settings) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final settingsJson = jsonEncode(settings);
      await prefs.setString(_settingsKey, settingsJson);
    } catch (e) {
      print('Error saving notification settings: $e');
    }
  }

  // Helper method to save notifications
  Future<void> _saveNotifications(List<NotificationModel> notifications) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final notificationsJson = notifications
          .map((n) => jsonEncode(n.toJson()))
          .toList();

      await prefs.setStringList(_notificationsKey, notificationsJson);
    } catch (e) {
      print('Error saving notifications: $e');
    }
  }

  // Generate sample notifications for testing
  Future<void> generateSampleNotifications() async {
    final sampleNotifications = NotificationModel.getSampleNotifications();

    for (final notification in sampleNotifications) {
      await addNotification(notification);
    }
  }

  // Create notification from order update
  Future<void> createOrderNotification({
    required String orderId,
    required String status,
    required String userName,
  }) async {
    final settings = await getNotificationSettings();
    if (!settings['order_updates']!) return;

    String title;
    String message;
    NotificationPriority priority = NotificationPriority.normal;

    switch (status.toLowerCase()) {
      case 'confirmed':
        title = 'Order Confirmed';
        message = 'Your order #$orderId has been confirmed and is being processed.';
        break;
      case 'processing':
        title = 'Order Processing';
        message = 'Your order #$orderId is now being prepared for shipment.';
        break;
      case 'shipped':
        title = 'Order Shipped';
        message = 'Your order #$orderId has been shipped and is on its way!';
        priority = NotificationPriority.high;
        break;
      case 'delivered':
        title = 'Order Delivered';
        message = 'Your order #$orderId has been delivered successfully!';
        priority = NotificationPriority.high;
        break;
      case 'cancelled':
        title = 'Order Cancelled';
        message = 'Your order #$orderId has been cancelled.';
        priority = NotificationPriority.urgent;
        break;
      default:
        title = 'Order Update';
        message = 'Your order #$orderId status has been updated to: $status';
    }

    final notification = NotificationModel(
      id: 'order_${DateTime.now().millisecondsSinceEpoch}',
      title: title,
      message: message,
      type: NotificationType.orderUpdate,
      priority: priority,
      timestamp: DateTime.now(),
      metadata: {
        'orderId': orderId,
        'status': status,
        'userName': userName,
      },
      actionUrl: '/orders/$orderId',
    );

    await addNotification(notification);
  }

  // Create promotional notification
  Future<void> createPromotionalNotification({
    required String title,
    required String message,
    String? actionUrl,
    NotificationPriority priority = NotificationPriority.normal,
  }) async {
    final settings = await getNotificationSettings();
    if (!settings['promotional_offers']!) return;

    final notification = NotificationModel(
      id: 'promo_${DateTime.now().millisecondsSinceEpoch}',
      title: title,
      message: message,
      type: NotificationType.promotion,
      priority: priority,
      timestamp: DateTime.now(),
      actionUrl: actionUrl,
    );

    await addNotification(notification);
  }

  // Create new product notification
  Future<void> createNewProductNotification({
    required String productName,
    required String category,
  }) async {
    final settings = await getNotificationSettings();
    if (!settings['new_products']!) return;

    final notification = NotificationModel(
      id: 'product_${DateTime.now().millisecondsSinceEpoch}',
      title: 'New Arrival',
      message: '$productName is now available in $category!',
      type: NotificationType.newProduct,
      priority: NotificationPriority.normal,
      timestamp: DateTime.now(),
      actionUrl: '/products?category=$category',
    );

    await addNotification(notification);
  }

  // Create cart reminder notification
  Future<void> createCartReminderNotification({
    required int itemCount,
    required double totalAmount,
  }) async {
    final settings = await getNotificationSettings();
    if (!settings['cart_reminders']!) return;

    final notification = NotificationModel(
      id: 'cart_${DateTime.now().millisecondsSinceEpoch}',
      title: 'Cart Reminder',
      message: 'You have $itemCount items in your cart worth KES ${totalAmount.toStringAsFixed(2)}. Complete your purchase!',
      type: NotificationType.cartReminder,
      priority: NotificationPriority.low,
      timestamp: DateTime.now(),
      actionUrl: '/cart',
    );

    await addNotification(notification);
  }

  // Create wishlist notification
  Future<void> createWishlistNotification({
    required String productName,
    required String reason, // 'back_in_stock', 'price_drop', 'similar_available'
  }) async {
    final settings = await getNotificationSettings();
    if (!settings['wishlist_updates']!) return;

    String title;
    String message;

    switch (reason) {
      case 'back_in_stock':
        title = 'Back in Stock!';
        message = '$productName is back in stock and available for purchase.';
        break;
      case 'price_drop':
        title = 'Price Drop Alert!';
        message = '$productName price has been reduced. Check it out now!';
        break;
      case 'similar_available':
        title = 'Similar Product Available';
        message = 'A similar product to your wishlist item $productName is now available.';
        break;
      default:
        title = 'Wishlist Update';
        message = 'Update regarding $productName in your wishlist.';
    }

    final notification = NotificationModel(
      id: 'wishlist_${DateTime.now().millisecondsSinceEpoch}',
      title: title,
      message: message,
      type: NotificationType.wishlistUpdate,
      priority: NotificationPriority.normal,
      timestamp: DateTime.now(),
      actionUrl: '/wishlist',
    );

    await addNotification(notification);
  }
}
