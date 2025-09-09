import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/product_model.dart';
import 'package:flutter/foundation.dart';

class ProductService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Add a new product to Firestore
  Future<void> addProduct(Product product) async {
    try {
      debugPrint('Adding product: ${product.title} with ID: ${product.id}');
      
      await _firestore.collection('products').doc(product.id).set(product.toMap());
      
      debugPrint('Product added successfully: ${product.title}');
      debugPrint('Product data: ${product.toMap()}');
    } catch (e) {
      debugPrint('Error adding product: $e');
      debugPrint('Error type: ${e.runtimeType}');
      
      // Provide more specific error messages
      if (e is FirebaseException) {
        debugPrint('Firebase error code: ${e.code}');
        debugPrint('Firebase error message: ${e.message}');
        
        if (e.code == 'permission-denied') {
          throw Exception('Permission denied. Please check your Firebase Firestore rules.');
        } else if (e.code == 'not-found') {
          throw Exception('Firestore collection not found.');
        }
      }
      
      throw Exception('Failed to add product: ${e.toString()}');
    }
  }

  // Get all products from Firestore
  Stream<List<Product>> getAllProducts() {
    return _firestore.collection('products').snapshots().map(
      (snapshot) {
        debugPrint('Received ${snapshot.docs.length} products from Firestore');
        return snapshot.docs.map(
          (doc) => Product.fromMap(doc.data())
        ).toList();
      }
    );
  }

  // Get a single product by ID
  Future<Product?> getProductById(String id) async {
    try {
      debugPrint('Getting product with ID: $id');
      DocumentSnapshot doc = await _firestore.collection('products').doc(id).get();
      
      if (doc.exists) {
        debugPrint('Product found: ${doc.id}');
        return Product.fromMap(doc.data() as Map<String, dynamic>);
      }
      
      debugPrint('Product not found with ID: $id');
      return null;
    } catch (e) {
      debugPrint('Error getting product: $e');
      debugPrint('Error type: ${e.runtimeType}');
      throw Exception('Failed to get product: ${e.toString()}');
    }
  }

  // Update a product
  Future<void> updateProduct(Product product) async {
    try {
      debugPrint('Updating product: ${product.title} with ID: ${product.id}');
      
      await _firestore.collection('products').doc(product.id).update(product.toMap());
      
      debugPrint('Product updated successfully: ${product.title}');
    } catch (e) {
      debugPrint('Error updating product: $e');
      debugPrint('Error type: ${e.runtimeType}');
      throw Exception('Failed to update product: ${e.toString()}');
    }
  }

  // Delete a product
  Future<void> deleteProduct(String id) async {
    try {
      debugPrint('Deleting product with ID: $id');
      
      await _firestore.collection('products').doc(id).delete();
      
      debugPrint('Product deleted successfully: $id');
    } catch (e) {
      debugPrint('Error deleting product: $e');
      debugPrint('Error type: ${e.runtimeType}');
      throw Exception('Failed to delete product: ${e.toString()}');
    }
  }
}
