import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import '../services/product_service.dart';
import '../models/user_model.dart';
import '../models/product_model.dart';
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Add Product', icon: Icon(Icons.add)),
            Tab(text: 'Users', icon: Icon(Icons.people)),
            Tab(text: 'Products Sold', icon: Icon(Icons.sell)),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await Provider.of<AuthService>(context, listen: false).signOut();
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildAddProductTab(),
          _buildUsersTab(),
          _buildProductsSoldTab(),
        ],
      ),
    );
  }

  Widget _buildAddProductTab() {
    return Center(
      child: ElevatedButton.icon(
        icon: const Icon(Icons.add),
        label: const Text('Add New Product'),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddProductScreen()),
          );
        },
      ),
    );
  }

  Widget _buildUsersTab() {
    return StreamBuilder<List<UserModel>>(
      stream: Provider.of<AuthService>(context).getAllUsers(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        final users = snapshot.data ?? [];

        return ListView.builder(
          itemCount: users.length,
          itemBuilder: (context, index) {
            final user = users[index];
            return ListTile(
              leading: CircleAvatar(
                child: Text(user.name[0].toUpperCase()),
              ),
              title: Text(user.name),
              subtitle: Text('${user.email} - Role: ${user.role}'),
              trailing: user.role != 'admin'
                  ? PopupMenuButton<String>(
                      onSelected: (value) async {
                        if (value == 'make_admin') {
                          await Provider.of<AuthService>(context, listen: false)
                              .updateUserRole(user.uid, 'admin');
                        }
                      },
                      itemBuilder: (context) => [
                        const PopupMenuItem(
                          value: 'make_admin',
                          child: Text('Make Admin'),
                        ),
                      ],
                    )
                  : null,
            );
          },
        );
      },
    );
  }

  Widget _buildProductsSoldTab() {
    return StreamBuilder<List<Product>>(
      stream: Provider.of<ProductService>(context).getAllProducts(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        final products = snapshot.data ?? [];

        return ListView.builder(
          itemCount: products.length,
          itemBuilder: (context, index) {
            final product = products[index];
            return ListTile(
              leading: Image.network(
                product.imageUrl,
                width: 50,
                height: 50,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.image_not_supported),
              ),
              title: Text(product.title),
              subtitle: Text('Stock: ${product.stock} | Price: \$${product.price}'),
              trailing: IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddProductScreen(product: product),
                    ),
                  );
                },
              ),
            );
          },
        );
      },
    );
  }
}
