import 'package:flutter/material.dart';

class SidebarHeader extends StatelessWidget {
  final bool isDark;
  final String email;
  final String avatarImagePath;
  final String profileSettingsText;

  const SidebarHeader({
    Key? key,
    required this.isDark,
    required this.email,
    this.avatarImagePath = 'assets/images/profile/login.png',
    this.profileSettingsText = 'Profile settings',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: isDark ? Colors.grey[800] : Colors.red,
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 30,
            backgroundImage: AssetImage(avatarImagePath),
          ),
          const SizedBox(height: 10),
          Text(
            email,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            profileSettingsText,
            style: TextStyle(
              color: Colors.white70,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
