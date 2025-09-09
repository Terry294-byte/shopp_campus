
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:provider/provider.dart';
// Ensure you have flutter_iconly version ^2.0.0 or above in your pubspec.yaml
import 'package:smartshop/screens/cart/cart_screen.dart';
import 'package:smartshop/screens/home_screen.dart';
import 'package:smartshop/screens/profile_screen.dart';
import 'package:smartshop/screens/search_screen.dart';
import '../screens/theme_provider.dart';

//parent class
class RootScreen extends StatefulWidget {
  const RootScreen({super.key});

  @override
  State<RootScreen> createState() => _RootScreenState();
}

//Sub class inheriting properties from the parent class
class _RootScreenState extends State<RootScreen> {
  late List<Widget> screens;
  int currentScreen = 0;
  late PageController controller;

  @override
  void initState() {
    screens = [HomeScreen(), SearchScreen(), CartScreen(), ProfileScreen()];

    controller = PageController(initialPage: currentScreen);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.getIsdark;
    return Scaffold(
      body: PageView(
        physics: NeverScrollableScrollPhysics(),
        controller: controller,

        children: screens,
      ),

      bottomNavigationBar: !isDark ? NavigationBar(
        selectedIndex: currentScreen,
          onDestinationSelected: (index) {
          print('Navigation selected index: $index');
          setState(() {
            currentScreen = index;
          });

          controller.jumpToPage(currentScreen);
          print('Jumping to page: $currentScreen');
        },
        destinations: [
          NavigationDestination(
            selectedIcon: Icon(IconlyBold.activity) ,
            
            
            icon: Icon(IconlyLight.home), label: "Home"),
          NavigationDestination(
             selectedIcon: Icon(IconlyBold.search) ,
            icon: Icon(IconlyLight.search),
            label: "Search",
          ),
          NavigationDestination(
             selectedIcon: Icon(IconlyBold.bag2) ,
            
            icon: Icon(IconlyLight.bag), label: "Cart"),

          NavigationDestination(
             selectedIcon: Icon(IconlyBold.profile) ,
            icon: Icon(IconlyLight.profile),
            label: "Profile",
          ),
        ],
      ) : null,
    );
  }
}