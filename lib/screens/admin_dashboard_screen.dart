import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import '../services/product_service.dart';
import '../models/user_model.dart';
import '../models/product_model.dart';
import '../constants/app_colors.dart';
import '../widgets/title_text.dart';
import '../screens/theme_provider.dart';
import 'add_product_screen.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const TitleTextWidget(
            label: 'Admin Dashboard',
            fontSize: 24,
            color: AppColors.white,
          ),
          backgroundColor: AppColors.primaryRed,
          elevation: 0,
          actions: [
            // Theme toggle
            Container(
              margin: const EdgeInsets.only(right: 8),
              decoration: BoxDecoration(
                color: AppColors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Consumer<ThemeProvider>(
                builder: (context, themeProvider, child) {
                  return IconButton(
                    icon: Icon(
                      themeProvider.getIsdark
                          ? Icons.light_mode
                          : Icons.dark_mode,
                      color: AppColors.white,
                    ),
                    onPressed: () {
                      themeProvider.setDarkTheme(!themeProvider.getIsdark);
                    },
                  );
                },
              ),
            ),
            // Logout
            Container(
              margin: const EdgeInsets.only(right: 8),
              decoration: BoxDecoration(
                color: AppColors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: IconButton(
                icon: const Icon(Icons.logout, color: AppColors.white),
                onPressed: () async {
                  await Provider.of<AuthService>(context, listen: false)
                      .signOut();
                  if (!mounted) return;
                  Navigator.pushReplacementNamed(context, '/login');
                },
              ),
            ),
          ],
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(240),
            child: Container(
              color: AppColors.primaryRed,
              child: Column(
                children: [
                  _buildDashboardHeader(),
                  _buildStatisticsCards(),
                  TabBar(
                    controller: _tabController,
                    indicatorColor: AppColors.white,
                    labelColor: AppColors.white,
                    unselectedLabelColor: AppColors.white.withOpacity(0.7),
                    indicatorWeight: 3,
                    tabs: const [
                      Tab(
                        text: 'Overview',
                        icon: Icon(Icons.dashboard_rounded, size: 24),
                      ),
                      Tab(
                        text: 'Users',
                        icon: Icon(Icons.people_rounded, size: 24),
                      ),
                      Tab(
                        text: 'Products',
                        icon: Icon(Icons.inventory_rounded, size: 24),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        body: Consumer<ThemeProvider>(
          builder: (context, themeProvider, child) {
            return Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: themeProvider.getIsdark
                      ? [
                          AppColors.darkBackgroundColor,
                          AppColors.darkCardColor,
                        ]
                      : [
                          AppColors.backgroundColor,
                          AppColors.white,
                        ],
                ),
              ),
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildOverviewTab(),
                  _buildUsersTab(),
                  _buildProductsTab(),
                ],
              ),
            );
          },
        ),
        floatingActionButton: _buildFloatingActionButton(),
      ),
    );
  }

  // ✅ Dashboard Header
  Widget _buildDashboardHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.dashboard_rounded,
              color: AppColors.white,
              size: 32,
            ),
          ),
          const SizedBox(width: 16),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TitleTextWidget(
                  label: 'Welcome back, Admin!',
                  fontSize: 20,
                  color: AppColors.white,
                  fontWeight: FontWeight.w600,
                ),
                SizedBox(height: 4),
                Text(
                  'Manage your store efficiently',
                  style: TextStyle(
                    color: AppColors.white70,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ✅ Statistics Cards
  Widget _buildStatisticsCards() {
    return Container(
      height: 80,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: StreamBuilder<List<UserModel>>(
        stream: Provider.of<AuthService>(context).getAllUsers(),
        builder: (context, userSnapshot) {
          return StreamBuilder<List<Product>>(
            stream: Provider.of<ProductService>(context).getAllProducts(),
            builder: (context, productSnapshot) {
              final userCount = userSnapshot.data?.length ?? 0;
              final productCount = productSnapshot.data?.length ?? 0;
              final lowStockCount =
                  productSnapshot.data?.where((p) => p.stock < 10).length ?? 0;

              return ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  _buildStatCard(
                    'Total Users',
                    userCount.toString(),
                    Icons.people_rounded,
                    AppColors.lightRed,
                  ),
                  const SizedBox(width: 12),
                  _buildStatCard(
                    'Products',
                    productCount.toString(),
                    Icons.inventory_rounded,
                    AppColors.darkRed,
                  ),
                  const SizedBox(width: 12),
                  _buildStatCard(
                    'Low Stock',
                    lowStockCount.toString(),
                    Icons.warning_rounded,
                    AppColors.warningColor,
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildStatCard(
      String title, String value, IconData icon, Color color) {
    return Container(
      width: 100,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            title,
            style: const TextStyle(
              fontSize: 10,
              color: AppColors.darkGrey,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  // ✅ Overview Tab (scrollable to prevent overflow)
  Widget _buildOverviewTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Add Product Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.primaryRed, AppColors.darkRed],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primaryRed.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.add_box_rounded,
                        color: AppColors.white,
                        size: 32,
                      ),
                    ),
                    const SizedBox(width: 16),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TitleTextWidget(
                            label: 'Add New Product',
                            fontSize: 24,
                            color: AppColors.white,
                            fontWeight: FontWeight.bold,
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Create and manage your product inventory',
                            style: TextStyle(
                              color: AppColors.white70,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AddProductScreen(),
                        ),
                      );
                    },
                    icon: const Icon(Icons.add_rounded, size: 24),
                    label: const Text(
                      'CREATE NEW PRODUCT',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.white,
                      foregroundColor: AppColors.primaryRed,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const TitleTextWidget(
            label: 'Quick Actions',
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildQuickActionCard(
                  'View Products',
                  'Manage existing inventory',
                  Icons.inventory_rounded,
                  AppColors.darkRed,
                  () => _tabController.animateTo(2),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildQuickActionCard(
                  'Manage Users',
                  'User administration',
                  Icons.people_rounded,
                  AppColors.lightRed,
                  () => _tabController.animateTo(1),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionCard(
    String title,
    String subtitle,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.lightGrey.withOpacity(0.3)),
          boxShadow: [
            BoxShadow(
              color: AppColors.black.withOpacity(0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 12),
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: color,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.darkGrey,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  // ✅ Users Tab
  Widget _buildUsersTab() {
    return StreamBuilder<List<UserModel>>(
      stream: Provider.of<AuthService>(context).getAllUsers(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(
              valueColor:
                  AlwaysStoppedAnimation<Color>(AppColors.primaryRed),
            ),
          );
        }
        if (snapshot.hasError) {
          return Center(
            child: Text('Error loading users: ${snapshot.error}'),
          );
        }
        final users = snapshot.data ?? [];
        if (users.isEmpty) {
          return const Center(child: Text('No users found'));
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: users.length,
          itemBuilder: (context, index) {
            final user = users[index];
            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: ListTile(
                title: Text(user.name),
                subtitle: Text(user.email),
              ),
            );
          },
        );
      },
    );
  }

  // ✅ Products Tab
  Widget _buildProductsTab() {
    return StreamBuilder<List<Product>>(
      stream: Provider.of<ProductService>(context).getAllProducts(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(
              valueColor:
                  AlwaysStoppedAnimation<Color>(AppColors.primaryRed),
            ),
          );
        }
        if (snapshot.hasError) {
          return Center(
            child: Text('Error loading products: ${snapshot.error}'),
          );
        }
        final products = snapshot.data ?? [];
        if (products.isEmpty) {
          return const Center(child: Text('No products found'));
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: products.length,
          itemBuilder: (context, index) {
            final product = products[index];
            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: ListTile(
                title: Text(product.title),
                subtitle: Text('Stock: ${product.stock}'),
              ),
            );
          },
        );
      },
    );
  }

  // ✅ Floating Action Button
  Widget _buildFloatingActionButton() {
    return FloatingActionButton.extended(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const AddProductScreen()),
        );
      },
      backgroundColor: AppColors.primaryRed,
      foregroundColor: AppColors.white,
      icon: const Icon(Icons.add_rounded),
      label: const Text('Add Product'),
      elevation: 4,
    );
  }
}
