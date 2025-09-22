import 'package:flutter/material.dart';

enum NotificationType {
  orderUpdate,
  promotion,
  newProduct,
  cartReminder,
  wishlistUpdate,
  security,
  general
}

enum NotificationPriority {
  low,
  normal,
  high,
  urgent
}

class NotificationModel {
  final String id;
  final String title;
  final String message;
  final NotificationType type;
  final NotificationPriority priority;
  final DateTime timestamp;
  final bool isRead;
  final String? actionUrl;
  final Map<String, dynamic>? metadata;
  final String? imageUrl;

  NotificationModel({
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    this.priority = NotificationPriority.normal,
    required this.timestamp,
    this.isRead = false,
    this.actionUrl,
    this.metadata,
    this.imageUrl,
  });

  // Get icon based on notification type
  IconData get icon {
    switch (type) {
      case NotificationType.orderUpdate:
        return Icons.local_shipping;
      case NotificationType.promotion:
        return Icons.local_offer;
      case NotificationType.newProduct:
        return Icons.new_releases;
      case NotificationType.cartReminder:
        return Icons.shopping_cart;
      case NotificationType.wishlistUpdate:
        return Icons.favorite;
      case NotificationType.security:
        return Icons.security;
      case NotificationType.general:
      default:
        return Icons.notifications;
    }
  }

  // Get color based on notification type
  Color get color {
    switch (type) {
      case NotificationType.orderUpdate:
        return Colors.blue;
      case NotificationType.promotion:
        return Colors.orange;
      case NotificationType.newProduct:
        return Colors.green;
      case NotificationType.cartReminder:
        return Colors.purple;
      case NotificationType.wishlistUpdate:
        return Colors.red;
      case NotificationType.security:
        return Colors.red.shade700;
      case NotificationType.general:
      default:
        return Colors.grey;
    }
  }

  // Get priority color
  Color get priorityColor {
    switch (priority) {
      case NotificationPriority.low:
        return Colors.grey;
      case NotificationPriority.normal:
        return Colors.blue;
      case NotificationPriority.high:
        return Colors.orange;
      case NotificationPriority.urgent:
        return Colors.red;
    }
  }

  // Convert to JSON for storage
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'message': message,
      'type': type.toString(),
      'priority': priority.toString(),
      'timestamp': timestamp.toIso8601String(),
      'isRead': isRead,
      'actionUrl': actionUrl,
      'metadata': metadata,
      'imageUrl': imageUrl,
    };
  }

  // Create from JSON
  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'],
      title: json['title'],
      message: json['message'],
      type: NotificationType.values.firstWhere(
        (e) => e.toString() == json['type'],
      ),
      priority: NotificationPriority.values.firstWhere(
        (e) => e.toString() == json['priority'],
      ),
      timestamp: DateTime.parse(json['timestamp']),
      isRead: json['isRead'] ?? false,
      actionUrl: json['actionUrl'],
      metadata: json['metadata'],
      imageUrl: json['imageUrl'],
    );
  }

  // Create a copy with modified fields
  NotificationModel copyWith({
    String? id,
    String? title,
    String? message,
    NotificationType? type,
    NotificationPriority? priority,
    DateTime? timestamp,
    bool? isRead,
    String? actionUrl,
    Map<String, dynamic>? metadata,
    String? imageUrl,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      title: title ?? this.title,
      message: message ?? this.message,
      type: type ?? this.type,
      priority: priority ?? this.priority,
      timestamp: timestamp ?? this.timestamp,
      isRead: isRead ?? this.isRead,
      actionUrl: actionUrl ?? this.actionUrl,
      metadata: metadata ?? this.metadata,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }

  // Static method to create sample notifications for testing
  static List<NotificationModel> getSampleNotifications() {
    final now = DateTime.now();

    return [
      NotificationModel(
        id: '1',
        title: 'Order Confirmed',
        message: 'Your order #1234 has been confirmed and is being processed.',
        type: NotificationType.orderUpdate,
        priority: NotificationPriority.normal,
        timestamp: now.subtract(const Duration(hours: 2)),
        isRead: false,
      ),
      NotificationModel(
        id: '2',
        title: 'Flash Sale Alert! 🎉',
        message: '50% off on all Electronics! Limited time offer.',
        type: NotificationType.promotion,
        priority: NotificationPriority.high,
        timestamp: now.subtract(const Duration(hours: 5)),
        isRead: false,
        actionUrl: '/products?category=Electronics',
      ),
      NotificationModel(
        id: '3',
        title: 'New Arrivals',
        message: 'Check out the latest fashion collection now available!',
        type: NotificationType.newProduct,
        priority: NotificationPriority.normal,
        timestamp: now.subtract(const Duration(days: 1)),
        isRead: true,
      ),
      NotificationModel(
        id: '4',
        title: 'Cart Reminder',
        message: 'You have items waiting in your cart. Complete your purchase!',
        type: NotificationType.cartReminder,
        priority: NotificationPriority.low,
        timestamp: now.subtract(const Duration(days: 2)),
        isRead: true,
        actionUrl: '/cart',
      ),
      NotificationModel(
        id: '5',
        title: 'Wishlist Update',
        message: 'An item in your wishlist is back in stock!',
        type: NotificationType.wishlistUpdate,
        priority: NotificationPriority.normal,
        timestamp: now.subtract(const Duration(days: 3)),
        isRead: false,
        actionUrl: '/wishlist',
      ),
    ];
  }

  @override
  String toString() {
    return 'NotificationModel{id: $id, title: $title, type: $type, isRead: $isRead}';
  }
}
