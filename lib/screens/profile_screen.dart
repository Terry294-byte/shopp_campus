import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import '../services/auth_service.dart';
import '../screens/theme_provider.dart';
import '../constants/app_colors.dart';
import '../models/user_model.dart';
import 'edit_profile_screen.dart';
import 'change_password_screen.dart';
import 'notifications_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  UserModel? _currentUser;
  XFile? _selectedImage;
  bool _isUploading = false;

  @override
  void initState() {
    super.initState();
    _loadCurrentUser();
  }

  Future<void> _loadCurrentUser() async {
    final authService = Provider.of<AuthService>(context, listen: false);
    final user = await authService.getCurrentUserData();
    setState(() {
      _currentUser = user;
    });
  }

  Future<void> _pickImage(ImageSource source) async {
    final authService = Provider.of<AuthService>(context, listen: false);
    try {
      final imageFile = await authService.pickImage(source);
      if (imageFile != null) {
        setState(() {
          _selectedImage = imageFile;
        });
        await _uploadProfileImage();
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error picking image: ${e.toString()}')),
      );
    }
  }

  Future<void> _uploadProfileImage() async {
    if (_selectedImage == null || _currentUser == null) return;

    setState(() {
      _isUploading = true;
    });

    final authService = Provider.of<AuthService>(context, listen: false);
    try {
      final imageUrl = await authService.uploadProfileImage(_currentUser!.uid, _selectedImage!);
      if (imageUrl != null) {
        await authService.updateProfileImageUrl(_currentUser!.uid, imageUrl);
        await _loadCurrentUser(); // Refresh user data
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile picture updated successfully!')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error uploading image: ${e.toString()}')),
      );
    } finally {
      setState(() {
        _isUploading = false;
        _selectedImage = null;
      });
    }
  }

  void _showImageSourceDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Choose Image Source'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Gallery'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.gallery);
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Camera'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.camera);
                },
              ),
            ],
          ),
        );
      },
    );
  }

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
            Stack(
              alignment: Alignment.center,
              children: [
                CircleAvatar(
                  radius: 60,
                  backgroundImage: _currentUser?.profileImageUrl != null
                      ? NetworkImage(_currentUser!.profileImageUrl!)
                      : const NetworkImage(
                          'https://cdn.pixabay.com/photo/2018/11/13/22/01/avatar-3814081_640.png',
                        ),
                ),
                if (_isUploading)
                  const CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: CircleAvatar(
                    radius: 18,
                    backgroundColor: AppColors.primaryRed,
                    child: IconButton(
                      icon: const Icon(Icons.camera_alt, size: 18, color: Colors.white),
                      onPressed: _isUploading ? null : _showImageSourceDialog,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              _currentUser?.email ?? 'Loading...',
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
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const EditProfileScreen()),
                      );
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
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const ChangePasswordScreen()),
                      );
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
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const NotificationsScreen()),
                      );
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
