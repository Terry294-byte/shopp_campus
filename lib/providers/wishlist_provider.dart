import 'package:flutter/foundation.dart';
import '../models/product_model.dart';

class WishlistProvider with ChangeNotifier {
  final List<Product> _wishlistItems = [];

  List<Product> get wishlistItems => [..._wishlistItems];

  int get itemCount => _wishlistItems.length;

  bool isInWishlist(String productId) {
    return _wishlistItems.any((item) => item.id == productId);
  }

  void addItem(Product product) {
    if (!isInWishlist(product.id)) {
      _wishlistItems.add(product);
      notifyListeners();
    }
  }

  void removeItem(String productId) {
    _wishlistItems.removeWhere((item) => item.id == productId);
    notifyListeners();
  }

  void toggleItem(Product product) {
    if (isInWishlist(product.id)) {
      removeItem(product.id);
    } else {
      addItem(product);
    }
  }

  void clearWishlist() {
    _wishlistItems.clear();
    notifyListeners();
  }
}
