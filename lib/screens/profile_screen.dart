import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import '../screens/theme_provider.dart';
import '../constants/app_colors.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  Future<void> _handleLogout(BuildContext context) async {
    final authService = Provider.of<AuthService>(context, listen: false);
    
    try {
      await authService.signOut();
      
      if (!context.mounted) return;
      Navigator.pushReplacementNamed(context, '/login');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error signing out: ${e.toString()}')),
      );
    }
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Logout'),
          content: const Text('Are you sure you want to logout?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _handleLogout(context);
              },
              child: const Text('Logout'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: isDark ? AppColors.darkGrey : AppColors.primaryRed,
        foregroundColor: AppColors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            CircleAvatar(
              radius: 60,
              backgroundImage: NetworkImage(
                'https://cdn.pixabay.com/photo/2018/11/13/22/01/avatar-3814081_640.png',
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'shiroterry168@gmail.com',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: isDark ? AppColors.white : AppColors.black,
              ),
            ),
            const SizedBox(height: 30),
            
            // Theme Toggle
            Card(
              elevation: 2,
              child: ListTile(
                leading: Icon(
                  themeProvider.getIsdark ? Icons.dark_mode : Icons.light_mode,
                  color: AppColors.primaryRed,
                ),
                title: Text(
                  themeProvider.getIsdark ? 'Dark Mode' : 'Light Mode',
                  style: TextStyle(
                    color: isDark ? AppColors.white : AppColors.black,
                  ),
                ),
                trailing: Switch(
                  value: themeProvider.getIsdark,
                  onChanged: (value) {
                    themeProvider.setDarkTheme(value);
                  },
                  activeColor: AppColors.primaryRed,
                ),
              ),
            ),
            
            const SizedBox(height: 20),
            
            // Account Settings
            Card(
              elevation: 2,
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.person, color: AppColors.primaryRed),
                    title: Text(
                      'Edit Profile',
                      style: TextStyle(
                        color: isDark ? AppColors.white : AppColors.black,
                      ),
                    ),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      // Navigate to edit profile
                    },
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.lock, color: AppColors.primaryRed),
                    title: Text(
                      'Change Password',
                      style: TextStyle(
                        color: isDark ? AppColors.white : AppColors.black,
                      ),
                    ),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      // Navigate to change password
                    },
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.notifications, color: AppColors.primaryRed),
                    title: Text(
                      'Notifications',
                      style: TextStyle(
                        color: isDark ? AppColors.white : AppColors.black,
                      ),
                    ),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      // Navigate to notifications
                    },
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 20),
            
            // Logout Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => _showLogoutDialog(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryRed,
                  foregroundColor: AppColors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.logout),
                    const SizedBox(width: 8),
                    const Text(
                      'Logout',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
