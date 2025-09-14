import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../screens/theme_provider.dart';
import '../screens/search_screen.dart';
import '../screens/profile_screen.dart';
import '../widgets/title_text.dart';
import '../widgets/sidebar_header.dart';
import '../constants/app_colors.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Widget _getHomeContent(bool isDark) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome Section
            Card(
              color: isDark ? AppColors.darkGrey.withOpacity(0.8) : AppColors.white,
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TitleTextWidget(
                      label: "Welcome to SmartShop!",
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : AppColors.black,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Discover amazing products and shop with ease.",
                      style: TextStyle(
                        fontSize: 16,
                        color: isDark ? Colors.white70 : AppColors.lightGrey,
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/products');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryRed,
                        foregroundColor: AppColors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        "Start Shopping",
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Banner Section
            Container(
              height: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                image: const DecorationImage(
                  image: AssetImage('assets/images/banners/banner1.png'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                      Colors.black.withOpacity(0.6),
                      Colors.transparent,
                    ],
                  ),
                ),
                child: const Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Special Offers",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        "Up to 50% off on selected items",
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Quick Actions Section
            TitleTextWidget(
              label: "Quick Actions",
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : AppColors.black,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildQuickActionCard(
                    isDark: isDark,
                    icon: Icons.shopping_bag,
                    title: "Products",
                    onTap: () => Navigator.pushNamed(context, '/products'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildQuickActionCard(
                    isDark: isDark,
                    icon: Icons.favorite_border,
                    title: "Wishlist",
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Wishlist feature coming soon!'),
                          backgroundColor: AppColors.primaryRed,
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildQuickActionCard(
                    isDark: isDark,
                    icon: Icons.history,
                    title: "Recent",
                    onTap: () {
                      // Navigate to Search screen (placeholder for recent searches/viewed items)
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => SearchScreen()),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildQuickActionCard(
                    isDark: isDark,
                    icon: Icons.settings,
                    title: "Settings",
                    onTap: () {
                      // Navigate to Profile screen (contains settings)
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => ProfileScreen()),
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActionCard({
    required bool isDark,
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Card(
      color: isDark ? AppColors.darkGrey.withOpacity(0.8) : AppColors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Icon(
                icon,
                size: 32,
                color: AppColors.primaryRed,
              ),
              const SizedBox(height: 8),
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: isDark ? Colors.white : AppColors.black,
                ),
              ),
            ],
          ),
        ),
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
