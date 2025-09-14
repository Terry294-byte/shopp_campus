import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../services/auth_service.dart';
import '../constants/app_colors.dart';
import '../models/user_model.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  XFile? _selectedImage;
  bool _isLoading = false;
  UserModel? _currentUser;
  bool _isRemovingImage = false;

  @override
  void initState() {
    super.initState();
    _loadCurrentUser();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _loadCurrentUser() async {
    final authService = Provider.of<AuthService>(context, listen: false);
    final user = await authService.getCurrentUserData();
    if (user != null) {
      setState(() {
        _currentUser = user;
        _nameController.text = user.name;
        _emailController.text = user.email;
      });
    }
  }

  Future<void> _pickImage() async {
    final authService = Provider.of<AuthService>(context, listen: false);
    try {
      final imageFile = await authService.pickImage(ImageSource.gallery);
      if (imageFile != null) {
        setState(() {
          _selectedImage = imageFile;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error picking image: ${e.toString()}')),
      );
    }
  }

  Future<void> _removeProfileImage() async {
    if (_currentUser == null) return;

    setState(() {
      _isRemovingImage = true;
    });

    final authService = Provider.of<AuthService>(context, listen: false);
    try {
      // Delete profile image from Cloudinary
      final success = await authService.deleteProfileImage(_currentUser!.uid);
      if (success) {
        // Remove profileImageUrl from Firestore
        await authService.updateProfileImageUrl(_currentUser!.uid, '');
        await _loadCurrentUser();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile image removed successfully!')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to remove profile image')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error removing image: ${e.toString()}')),
      );
    } finally {
      setState(() {
        _isRemovingImage = false;
      });
    }
  }

  Future<void> _updateProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    final authService = Provider.of<AuthService>(context, listen: false);

    try {
      // Upload new profile image if selected
      String? imageUrl;
      if (_selectedImage != null) {
        imageUrl = await authService.uploadProfileImage(_currentUser!.uid, _selectedImage!);
        if (imageUrl == null) {
          throw Exception('Failed to upload profile image. Please try again.');
        }
      }

      // Update user data in Firestore
      await authService.updateUserProfile(
        _currentUser!.uid,
        _nameController.text.trim(),
        _emailController.text.trim(),
      );

      // Update profile image URL if new image uploaded
      if (imageUrl != null) {
        await authService.updateProfileImageUrl(_currentUser!.uid, imageUrl);
      }

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated successfully!')),
      );

      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating profile: ${e.toString()}')),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _selectedImage = null;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        backgroundColor: isDark ? AppColors.darkGrey : AppColors.primaryRed,
        foregroundColor: AppColors.white,
      ),
      body: _currentUser == null
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        CircleAvatar(
                          radius: 60,
                        backgroundImage: _selectedImage != null
                            ? (kIsWeb
                                ? NetworkImage(_selectedImage!.path)
                                : Image.file(
                                    File(_selectedImage!.path),
                                    fit: BoxFit.cover,
                                  ).image)
                            : (_currentUser?.profileImageUrl != null && _currentUser!.profileImageUrl!.isNotEmpty)
                                ? NetworkImage(_currentUser!.profileImageUrl!)
                                : const NetworkImage(
                                    'https://cdn.pixabay.com/photo/2018/11/13/22/01/avatar-3814081_640.png',
                                  ),
                        ),
                        if (_isRemovingImage)
                          const CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 18,
                                backgroundColor: AppColors.primaryRed,
                                child: IconButton(
                                  icon: const Icon(Icons.camera_alt, size: 18, color: Colors.white),
                                  onPressed: _isLoading || _isRemovingImage ? null : _pickImage,
                                ),
                              ),
                              const SizedBox(width: 8),
                              if ((_currentUser?.profileImageUrl != null && _currentUser!.profileImageUrl!.isNotEmpty) || _selectedImage != null)
                                CircleAvatar(
                                  radius: 18,
                                  backgroundColor: Colors.grey[700],
                                  child: IconButton(
                                    icon: const Icon(Icons.delete, size: 18, color: Colors.white),
                                    onPressed: _isLoading || _isRemovingImage ? null : _removeProfileImage,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        labelText: 'Full Name',
                        prefixIcon: const Icon(Icons.person),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter your name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        prefixIcon: const Icon(Icons.email),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter your email';
                        }
                        if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                          return 'Please enter a valid email';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 40),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _updateProfile,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryRed,
                          foregroundColor: AppColors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: _isLoading
                            ? const CircularProgressIndicator(color: Colors.white)
                            : const Text(
                                'Update Profile',
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
