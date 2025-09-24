import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/app_colors.dart';
import '../models/notification_model.dart';
import '../providers/notification_provider.dart';
import '../widgets/empty_bag.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late NotificationProvider _notificationProvider;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _notificationProvider = Provider.of<NotificationProvider>(context, listen: false);

    // Initialize notifications data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _notificationProvider.initialize();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: const Text('Notifications'),
        backgroundColor: isDark ? AppColors.darkGrey : AppColors.primaryRed,
        foregroundColor: AppColors.white,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppColors.white,
          labelColor: AppColors.white,
          unselectedLabelColor: AppColors.white.withOpacity(0.7),
          tabs: const [
            Tab(
              icon: Icon(Icons.notifications),
              text: 'Notifications',
            ),
            Tab(
              icon: Icon(Icons.settings),
              text: 'Settings',
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: TabBarView(
              controller: _tabController,
              physics: const BouncingScrollPhysics(),
              children: [
                // Notifications Tab
                Consumer<NotificationProvider>(
                  builder: (context, provider, child) {
                    if (provider.isLoading) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    if (provider.notifications.isEmpty) {
                      return _buildEmptyNotifications();
                    }

                    return _buildNotificationsList(provider);
                  },
                ),

                // Settings Tab
                Consumer<NotificationProvider>(
                  builder: (context, provider, child) {
                    return SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const SizedBox(height: 10),
                          Text(
                            'Notification Settings',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: isDark ? AppColors.white : AppColors.black,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Choose what notifications you want to receive',
                            style: TextStyle(
                              fontSize: 14,
                              color: isDark ? AppColors.white.withOpacity(0.7) : AppColors.black.withOpacity(0.7),
                            ),
                          ),
                          const SizedBox(height: 20),

                          // Push Notifications
                          Card(
                            elevation: 2,
                            margin: const EdgeInsets.only(bottom: 8),
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
                              value: provider.settings['push_notifications'] ?? true,
                              onChanged: (value) {
                                provider.updateSetting('push_notifications', value);
                              },
                              activeColor: AppColors.primaryRed,
                            ),
                          ),

                          // Email Notifications
                          Card(
                            elevation: 2,
                            margin: const EdgeInsets.only(bottom: 16),
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
                              value: provider.settings['email_notifications'] ?? true,
                              onChanged: (value) {
                                provider.updateSetting('email_notifications', value);
                              },
                              activeColor: AppColors.primaryRed,
                            ),
                          ),

                          Text(
                            'Specific Notifications',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: isDark ? AppColors.white : AppColors.black,
                            ),
                          ),
                          const SizedBox(height: 12),

                          // Order Updates
                          Card(
                            elevation: 2,
                            margin: const EdgeInsets.only(bottom: 8),
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
                              value: provider.settings['order_updates'] ?? true,
                              onChanged: (value) {
                                provider.updateSetting('order_updates', value);
                              },
                              activeColor: AppColors.primaryRed,
                            ),
                          ),

                          // Promotional Offers
                          Card(
                            elevation: 2,
                            margin: const EdgeInsets.only(bottom: 8),
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
                              value: provider.settings['promotional_offers'] ?? false,
                              onChanged: (value) {
                                provider.updateSetting('promotional_offers', value);
                              },
                              activeColor: AppColors.primaryRed,
                            ),
                          ),

                          // New Products
                          Card(
                            elevation: 2,
                            margin: const EdgeInsets.only(bottom: 20),
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
                              value: provider.settings['new_products'] ?? true,
                              onChanged: (value) {
                                provider.updateSetting('new_products', value);
                              },
                              activeColor: AppColors.primaryRed,
                            ),
                          ),

                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () async {
                                // Get current settings from provider
                                final currentSettings = provider.settings;

                                // Save settings using provider method
                                await provider.updateSettings(currentSettings);

                                // Show success message
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Notification settings saved successfully!'),
                                    backgroundColor: Colors.green,
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primaryRed,
                                foregroundColor: AppColors.white,
                                padding: const EdgeInsets.symmetric(vertical: 14),
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
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyNotifications() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const EmptyBagWidget(
            imagePath: 'assets/images/empty_search.png',
            title: 'No Notifications',
            subtitle: 'You\'re all caught up! No new notifications.',
            buttonText: 'Generate Sample',
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: _generateSampleNotifications,
            icon: const Icon(Icons.add),
            label: const Text('Generate Sample Notifications'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryRed,
              foregroundColor: AppColors.white,
            ),
          ),
        ],
      ),
    );
  }

  void _generateSampleNotifications() {
    // Use a post-frame callback to avoid calling setState during build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _notificationProvider.generateSampleNotifications();
    });
  }

  Widget _buildNotificationsList(NotificationProvider provider) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: provider.notifications.length,
      itemBuilder: (context, index) {
        final notification = provider.notifications[index];
        return _buildNotificationCard(notification, provider);
      },
    );
  }

  Widget _buildNotificationCard(NotificationModel notification, NotificationProvider provider) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Dismissible(
        key: Key(notification.id),
        direction: DismissDirection.endToStart,
        background: Container(
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.only(right: 20),
          decoration: BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(
            Icons.delete,
            color: Colors.white,
          ),
        ),
        onDismissed: (direction) {
          provider.deleteNotification(notification.id);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('${notification.title} dismissed'),
              action: SnackBarAction(
                label: 'Undo',
                onPressed: () {
                  provider.addNotification(notification);
                },
              ),
            ),
          );
        },
        child: ListTile(
          leading: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: notification.color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(25),
            ),
            child: Icon(
              notification.icon,
              color: notification.color,
              size: 24,
            ),
          ),
          title: Text(
            notification.title,
            style: TextStyle(
              fontWeight: notification.isRead ? FontWeight.normal : FontWeight.bold,
              color: isDark ? AppColors.white : AppColors.black,
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                notification.message,
                style: TextStyle(
                  color: isDark ? AppColors.white.withOpacity(0.7) : AppColors.black.withOpacity(0.7),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                _formatDateTime(notification.timestamp),
                style: TextStyle(
                  fontSize: 12,
                  color: isDark ? AppColors.white.withOpacity(0.5) : AppColors.black.withOpacity(0.5),
                ),
              ),
            ],
          ),
          trailing: PopupMenuButton<String>(
            onSelected: (value) {
              switch (value) {
                case 'mark_read':
                  if (!notification.isRead) {
                    provider.markAsRead(notification.id);
                  }
                  break;
                case 'mark_unread':
                  // For now, we'll just refresh to mark as unread
                  break;
                case 'delete':
                  provider.deleteNotification(notification.id);
                  break;
              }
            },
            itemBuilder: (context) => [
              if (!notification.isRead)
                const PopupMenuItem(
                  value: 'mark_read',
                  child: Text('Mark as read'),
                ),
              const PopupMenuItem(
                value: 'delete',
                child: Text('Delete'),
              ),
            ],
          ),
          onTap: () {
            if (!notification.isRead) {
              provider.markAsRead(notification.id);
            }
            // Handle notification tap - could navigate to related screen
            if (notification.actionUrl != null) {
              // Navigate to the action URL
              print('Navigate to: ${notification.actionUrl}');
            }
          },
        ),
      ),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays == 0) {
      // Today - show time only
      return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
    } else if (difference.inDays == 1) {
      // Yesterday
      return 'Yesterday ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
    } else if (difference.inDays < 7) {
      // This week - show day name
      const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
      return '${days[dateTime.weekday - 1]} ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
    } else {
      // Older - show date
      return '${dateTime.month}/${dateTime.day} ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
    }
  }
}
