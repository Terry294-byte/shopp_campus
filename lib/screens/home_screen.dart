import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../screens/theme_provider.dart';

import '../widgets/title_text.dart';
import '../widgets/sidebar_header.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Widget _getHomeContent(bool isDark) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Home Tab',
            style: TextStyle(color: isDark ? Colors.white : Colors.black),
          ),
          const SizedBox(height: 20),
          Image.asset(
            'assets/images/bag/bag_wish.png',
            height: 100,
            width: 100,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.getIsdark;
    final screenWidth = MediaQuery.of(context).size.width;
    final isPhone = screenWidth < 600; // Define phone device by screen width threshold

    return Scaffold(
      backgroundColor: isDark ? Colors.black : Colors.white,
      appBar: AppBar(
        elevation: 4,
        titleSpacing: 0,
        title: Row(
          children: [
            if (isDark) Builder(
              builder: (context) => IconButton(
                icon: Icon(Icons.menu, color: Colors.white),
                onPressed: () => Scaffold.of(context).openDrawer(),
              ),
            ),
            TitleTextWidget(
              label: "SmartShop",
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black,
            ),
          ],
        ),
        backgroundColor: isDark ? Colors.grey[900] : Colors.red,
        actions: [
          Switch(
            value: isDark,
            onChanged: (value) {
              themeProvider.setDarkTheme(value);
            },
            activeColor: Colors.white,
          ),
        ],
      ),
      drawer: Drawer(
        child: Container(
          color: isDark ? Colors.grey[900] : Colors.white,
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                padding: EdgeInsets.zero,
                child: SidebarHeader(
                  isDark: isDark,
                  email: 'shiroterry168@gmail.com',
                  avatarImagePath: 'assets/images/profile/login.png',
                  profileSettingsText: 'Profile settings',
                ),
              ),
              ListTile(
                leading: Icon(Icons.shopping_bag, color: isDark ? Colors.white : Colors.black),
                title: Text('Products', style: TextStyle(color: isDark ? Colors.white : Colors.black)),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/products');
                },
              ),
              ListTile(
                leading: Icon(Icons.list_alt, color: isDark ? Colors.white : Colors.black),
                title: Text('All Order', style: TextStyle(color: isDark ? Colors.white : Colors.black)),
                onTap: () {
                  Navigator.pop(context);
                  // TODO: Navigate to All Order screen
                },
              ),
              ListTile(
                leading: Icon(Icons.favorite_border, color: isDark ? Colors.white : Colors.black),
                title: Text('Wishlist', style: TextStyle(color: isDark ? Colors.white : Colors.black)),
                onTap: () {
                  Navigator.pop(context);
                  // TODO: Navigate to Wishlist screen
                },
              ),
              ListTile(
                leading: Icon(Icons.history_toggle_off, color: isDark ? Colors.white : Colors.black),
                title: Text('Viewed recently', style: TextStyle(color: isDark ? Colors.white : Colors.black)),
                onTap: () {
                  Navigator.pop(context);
                  // TODO: Navigate to Viewed recently screen
                },
              ),
              ListTile(
                leading: Icon(Icons.location_on_outlined, color: isDark ? Colors.white : Colors.black),
                title: Text('Address', style: TextStyle(color: isDark ? Colors.white : Colors.black)),
                onTap: () {
                  Navigator.pop(context);
                  // TODO: Navigate to Address screen
                },
              ),
              ListTile(
                leading: Icon(Icons.settings_outlined, color: isDark ? Colors.white : Colors.black),
                title: Text('Settings', style: TextStyle(color: isDark ? Colors.white : Colors.black)),
                onTap: () {
                  Navigator.pop(context);
                  // TODO: Navigate to Settings screen
                },
              ),
              const Divider(),
              ListTile(
                leading: Icon(Icons.logout_outlined, color: isDark ? Colors.white : Colors.black),
                title: Text('Logout', style: TextStyle(color: isDark ? Colors.white : Colors.black)),
                onTap: () {
                  Navigator.pop(context);
                  // TODO: Handle logout
                },
              ),
            ],
          ),
        ),
      ),
      body: _getHomeContent(isDark),
    );
  }
}
