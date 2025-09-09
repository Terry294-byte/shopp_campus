import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:smartshop/firebase_options.dart';
import 'package:smartshop/screens/auth/login_screen.dart';
import 'package:smartshop/providers/cart_provider.dart';
import 'package:smartshop/screens/roots_screen.dart';
import 'screens/theme_provider.dart';
import 'constants/theme_data.dart';
import 'screens/auth/register_screen.dart';
import 'screens/auth/forgot_password_screen.dart';
import 'package:smartshop/screens/products_screen.dart';
import 'package:smartshop/screens/add_product_screen.dart';
import 'package:smartshop/screens/product_list_screen.dart';
import 'package:smartshop/screens/admin_dashboard_screen.dart';
import 'services/auth_service.dart';
import 'services/product_service.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
        Provider(create: (_) => AuthService()),
        Provider(create: (_) => ProductService()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Ecommerce App',
          theme: Styles.themeData(
            isDarkTheme: themeProvider.getIsdark,
            context: context,
          ),
          initialRoute: '/login',
          routes: {
            '/login': (context) => const LoginScreen(),
            '/home': (context) => const RootScreen(),
            '/register': (context) => const RegisterScreen(),
            '/forgot-password': (context) => const ForgotPasswordScreen(),
            '/products': (context) => ProductsScreen(),
            '/add-product': (context) => const AddProductScreen(),
            '/product-list': (context) => const ProductListScreen(),
            '/admin-dashboard': (context) => const AdminDashboardScreen(),
          },
        );
      },
    );
  }
}
