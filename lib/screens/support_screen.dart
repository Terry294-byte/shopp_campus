import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../constants/app_colors.dart';
import '../screens/theme_provider.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import '../models/user_model.dart';

class SupportScreen extends StatefulWidget {
  const SupportScreen({super.key});

  @override
  State<SupportScreen> createState() => _SupportScreenState();
}

class _SupportScreenState extends State<SupportScreen> {
  final TextEditingController _feedbackController = TextEditingController();
  UserModel? _currentUser;

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

  Future<void> _launchEmail() async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: 'shiroterry4@gmail.com',
      queryParameters: {
        'subject': 'App Support Request',
        if (_currentUser != null) 'body': 'User: ${_currentUser!.name} <${_currentUser!.email}>',
      },
    );
    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not launch email app.')),
      );
    }
  }

  Future<void> _submitFeedback() async {
    if (_feedbackController.text.isNotEmpty) {
      if (_currentUser == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('User not logged in. Cannot submit feedback.')),
        );
        return;
      }
      final authService = Provider.of<AuthService>(context, listen: false);
      try {
        await authService.submitFeedback(
          _currentUser!.uid,
          _currentUser!.name,
          _currentUser!.email,
          _feedbackController.text,
        );
        _feedbackController.clear();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Feedback submitted successfully. Thank you!')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error submitting feedback: ${e.toString()}')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter your feedback.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Support'),
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
              'How can we help you?',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: isDark ? AppColors.white : AppColors.black,
              ),
            ),
            const SizedBox(height: 30),

            // FAQ Section
            Card(
              elevation: 2,
              child: ExpansionTile(
                leading: Icon(Icons.help, color: AppColors.primaryRed),
                title: Text(
                  'Frequently Asked Questions',
                  style: TextStyle(
                    color: isDark ? AppColors.white : AppColors.black,
                  ),
                ),
                children: [
                  ListTile(
                    title: Text('How do I reset my password?'),
                    subtitle: Text('Go to Profile > Change Password.'),
                  ),
                  ListTile(
                    title: Text('How do I update my profile?'),
                    subtitle: Text('Go to Profile > Edit Profile.'),
                  ),
                  ListTile(
                    title: Text('How do I contact support?'),
                    subtitle: Text('Use the Contact Us button below.'),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Contact Us
            Card(
              elevation: 2,
              child: ListTile(
                leading: Icon(Icons.email, color: AppColors.primaryRed),
                title: Text(
                  'Contact Us',
                  style: TextStyle(
                    color: isDark ? AppColors.white : AppColors.black,
                  ),
                ),
                subtitle: Text('Send us an email for support.'),
                trailing: Icon(Icons.chevron_right),
                onTap: _launchEmail,
              ),
            ),

            const SizedBox(height: 20),

            // Feedback Form
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Send Feedback',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: isDark ? AppColors.white : AppColors.black,
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _feedbackController,
                      maxLines: 4,
                      decoration: InputDecoration(
                        hintText: 'Describe your issue or suggestion...',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: _submitFeedback,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryRed,
                        foregroundColor: AppColors.white,
                      ),
                      child: const Text('Submit Feedback'),
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
