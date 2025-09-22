import 'package:flutter/foundation.dart';
import '../models/notification_model.dart';
import '../services/notification_service.dart';

class NotificationProvider with ChangeNotifier {
  final NotificationService _notificationService = NotificationService();

  List<NotificationModel> _notifications = [];
  Map<String, bool> _settings = {};
  bool _isLoading = false;
  int _unreadCount = 0;

  // Getters
  List<NotificationModel> get notifications => _notifications;
  List<NotificationModel> get unreadNotifications =>
      _notifications.where((n) => !n.isRead).toList();

  Map<String, bool> get settings => _settings;
  bool get isLoading => _isLoading;
  int get unreadCount => _unreadCount;

  // Get notifications by type
  List<NotificationModel> getNotificationsByType(NotificationType type) {
    return _notifications.where((n) => n.type == type).toList();
  }

  // Get recent notifications (last 7 days)
  List<NotificationModel> get recentNotifications {
    final weekAgo = DateTime.now().subtract(const Duration(days: 7));
    return _notifications
        .where((n) => n.timestamp.isAfter(weekAgo))
        .toList();
  }

  // Initialize provider
  Future<void> initialize() async {
    _isLoading = true;
    notifyListeners();

    try {
      // Load notifications and settings in parallel
      final results = await Future.wait([
        _notificationService.getNotifications(),
        _notificationService.getNotificationSettings(),
        _notificationService.getUnreadCount(),
      ]);

      _notifications = results[0] as List<NotificationModel>;
      _settings = results[1] as Map<String, bool>;
      _unreadCount = results[2] as int;
    } catch (e) {
      print('Error initializing notification provider: $e');
      // Set default values on error
      _notifications = [];
      _settings = {
        'push_notifications': true,
        'email_notifications': true,
        'order_updates': true,
        'promotional_offers': false,
        'new_products': true,
        'cart_reminders': true,
        'wishlist_updates': true,
        'security_alerts': true,
      };
      _unreadCount = 0;
    }

    _isLoading = false;
    notifyListeners();
  }

  // Refresh notifications
  Future<void> refreshNotifications() async {
    try {
      final notifications = await _notificationService.getNotifications();
      _notifications = notifications;
      _unreadCount = await _notificationService.getUnreadCount();
      notifyListeners();
    } catch (e) {
      print('Error refreshing notifications: $e');
    }
  }

  // Add new notification
  Future<void> addNotification(NotificationModel notification) async {
    await _notificationService.addNotification(notification);
    await refreshNotifications();
  }

  // Mark notification as read
  Future<void> markAsRead(String notificationId) async {
    await _notificationService.markAsRead(notificationId);
    await refreshNotifications();
  }

  // Mark all notifications as read
  Future<void> markAllAsRead() async {
    await _notificationService.markAllAsRead();
    await refreshNotifications();
  }

  // Delete notification
  Future<void> deleteNotification(String notificationId) async {
    await _notificationService.deleteNotification(notificationId);
    await refreshNotifications();
  }

  // Clear all notifications
  Future<void> clearAllNotifications() async {
    await _notificationService.clearAllNotifications();
    await refreshNotifications();
  }

  // Update notification settings
  Future<void> updateSettings(Map<String, bool> newSettings) async {
    await _notificationService.saveNotificationSettings(newSettings);
    _settings = newSettings;
    notifyListeners();
  }

  // Update single setting
  Future<void> updateSetting(String key, bool value) async {
    final newSettings = Map<String, bool>.from(_settings);
    newSettings[key] = value;
    await updateSettings(newSettings);
  }

  // Generate sample notifications for testing
  Future<void> generateSampleNotifications() async {
    await _notificationService.generateSampleNotifications();
    await refreshNotifications();
  }

  // Create order notification
  Future<void> createOrderNotification({
    required String orderId,
    required String status,
    required String userName,
  }) async {
    await _notificationService.createOrderNotification(
      orderId: orderId,
      status: status,
      userName: userName,
    );
    await refreshNotifications();
  }

  // Create promotional notification
  Future<void> createPromotionalNotification({
    required String title,
    required String message,
    String? actionUrl,
    NotificationPriority priority = NotificationPriority.normal,
  }) async {
    await _notificationService.createPromotionalNotification(
      title: title,
      message: message,
      actionUrl: actionUrl,
      priority: priority,
    );
    await refreshNotifications();
  }

  // Create new product notification
  Future<void> createNewProductNotification({
    required String productName,
    required String category,
  }) async {
    await _notificationService.createNewProductNotification(
      productName: productName,
      category: category,
    );
    await refreshNotifications();
  }

  // Create cart reminder notification
  Future<void> createCartReminderNotification({
    required int itemCount,
    required double totalAmount,
  }) async {
    await _notificationService.createCartReminderNotification(
      itemCount: itemCount,
      totalAmount: totalAmount,
    );
    await refreshNotifications();
  }

  // Create wishlist notification
  Future<void> createWishlistNotification({
    required String productName,
    required String reason,
  }) async {
    await _notificationService.createWishlistNotification(
      productName: productName,
      reason: reason,
    );
    await refreshNotifications();
  }

  // Filter notifications
  List<NotificationModel> filterNotifications({
    NotificationType? type,
    bool? isRead,
    NotificationPriority? priority,
    DateTime? fromDate,
    DateTime? toDate,
  }) {
    return _notifications.where((notification) {
      if (type != null && notification.type != type) return false;
      if (isRead != null && notification.isRead != isRead) return false;
      if (priority != null && notification.priority != priority) return false;
      if (fromDate != null && notification.timestamp.isBefore(fromDate)) return false;
      if (toDate != null && notification.timestamp.isAfter(toDate)) return false;
      return true;
    }).toList();
  }

  // Search notifications
  List<NotificationModel> searchNotifications(String query) {
    final lowercaseQuery = query.toLowerCase();
    return _notifications.where((notification) {
      return notification.title.toLowerCase().contains(lowercaseQuery) ||
             notification.message.toLowerCase().contains(lowercaseQuery);
    }).toList();
  }

  // Get notification statistics
  Map<String, int> getNotificationStats() {
    final stats = <String, int>{};

    for (final type in NotificationType.values) {
      stats[type.toString()] = getNotificationsByType(type).length;
    }

    stats['total'] = _notifications.length;
    stats['unread'] = _unreadCount;
    stats['read'] = _notifications.length - _unreadCount;

    return stats;
  }

  // Get notifications for today
  List<NotificationModel> getTodaysNotifications() {
    final today = DateTime.now();
    final startOfDay = DateTime(today.year, today.month, today.day);
    final endOfDay = DateTime(today.year, today.month, today.day, 23, 59, 59);

    return _notifications.where((notification) {
      return notification.timestamp.isAfter(startOfDay) &&
             notification.timestamp.isBefore(endOfDay);
    }).toList();
  }

  // Get notifications for this week
  List<NotificationModel> getThisWeeksNotifications() {
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    final startOfWeekDay = DateTime(startOfWeek.year, startOfWeek.month, startOfWeek.day);

    return _notifications.where((notification) {
      return notification.timestamp.isAfter(startOfWeekDay);
    }).toList();
  }
}
