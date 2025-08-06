import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'screens/splash_screen.dart'; // you'll create this
import 'config/theme.dart';          // you'll create this

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();  // ← initializes Firebase
  runApp(const ShoppyCampusApp());
}

class ShoppyCampusApp extends StatelessWidget {
  const ShoppyCampusApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ShoppyCampus',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      home: const SplashScreen(), // this will be your landing page
    );
  }
}
