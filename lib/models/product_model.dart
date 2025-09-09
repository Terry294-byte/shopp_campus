class Product {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  final String category;
  final int stock;
  final double rating;
  final int reviewCount;
  final bool isFeatured;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.category,
    this.stock = 100,
    this.rating = 4.5,
    this.reviewCount = 0,
    this.isFeatured = false,
  });

  // Helper method to create sample products
  static List<Product> getSampleProducts() {
    return [
      Product(
        id: '1',
        title: 'Smartphone Pro',
        description: 'Latest smartphone with advanced features',
        price: 699.99,
        imageUrl: 'https://images.unsplash.com/photo-1511707171634-5f897ff02aa9?w=400&h=300&fit=crop',
        category: 'Electronics',
        rating: 4.8,
        reviewCount: 125,
        isFeatured: true,
      ),
      Product(
        id: '2',
        title: 'Laptop Elite',
        description: 'High-performance laptop for professionals',
        price: 1299.99,
        imageUrl: 'https://images.unsplash.com/photo-1496181133206-80ce9b88a853?w=400&h=300&fit=crop',
        category: 'Electronics',
        rating: 4.6,
        reviewCount: 89,
        isFeatured: true,
      ),
      Product(
        id: '3',
        title: 'Running Shoes',
        description: 'Comfortable running shoes for athletes',
        price: 89.99,
        imageUrl: 'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=400&h=300&fit=crop',
        category: 'Fashion',
        rating: 4.4,
        reviewCount: 67,
      ),
      Product(
        id: '4',
        title: 'Smart Watch',
        description: 'Feature-rich smartwatch with health tracking',
        price: 249.99,
        imageUrl: 'https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=400&h=300&fit=crop',
        category: 'Electronics',
        rating: 4.7,
        reviewCount: 203,
        isFeatured: true,
      ),
      Product(
        id: '5',
        title: 'Fashion Jacket',
        description: 'Stylish jacket for all seasons',
        price: 79.99,
        imageUrl: 'https://images.unsplash.com/photo-1551028719-00167b16eac5?w=400&h=300&fit=crop',
        category: 'Fashion',
        rating: 4.3,
        reviewCount: 45,
      ),
      Product(
        id: '6',
        title: 'Beauty Kit',
        description: 'Complete beauty and cosmetics set',
        price: 49.99,
        imageUrl: 'https://images.unsplash.com/photo-1596462502278-27bfdc403348?w=400&h=300&fit=crop',
        category: 'Cosmetics',
        rating: 4.5,
        reviewCount: 78,
      ),
      Product(
        id: '7',
        title: 'Headphones Pro',
        description: 'Wireless headphones with noise cancellation',
        price: 199.99,
        imageUrl: 'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=400&h=300&fit=crop',
        category: 'Electronics',
        rating: 4.6,
        reviewCount: 156,
      ),
      Product(
        id: '8',
        title: 'Best Seller Book',
        description: 'Popular fiction novel',
        price: 24.99,
        imageUrl: 'https://images.unsplash.com/photo-1544947950-fa07a98d237f?w=400&h=300&fit=crop',
        category: 'Books',
        rating: 4.2,
        reviewCount: 34,
      ),
    ];
  }

  // Convert to Map for Firestore or other storage
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'price': price,
      'imageUrl': imageUrl,
      'category': category,
      'stock': stock,
      'rating': rating,
      'reviewCount': reviewCount,
      'isFeatured': isFeatured,
    };
  }

  // Create from Map
  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      price: (map['price'] ?? 0.0).toDouble(),
      imageUrl: map['imageUrl'] ?? '',
      category: map['category'] ?? '',
      stock: map['stock'] ?? 0,
      rating: (map['rating'] ?? 0.0).toDouble(),
      reviewCount: map['reviewCount'] ?? 0,
      isFeatured: map['isFeatured'] ?? false,
    );
  }

  @override
  String toString() {
    return 'Product{id: $id, title: $title, price: $price, category: $category}';
  }
}
