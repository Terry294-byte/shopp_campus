import 'package:flutter/foundation.dart';

class CartItem {
  final String id;
  final String title;
  final double price;
  final String imageUrl;
  int quantity;
  bool isLiked;
  bool isInWishlist;
  bool isSelected;

  CartItem({
    required this.id,
    required this.title,
    required this.price,
    required this.imageUrl,
    this.quantity = 1,
    this.isLiked = false,
    this.isInWishlist = false,
    this.isSelected = false,
  });

  double get totalPrice => price * quantity;
}

class CartProvider with ChangeNotifier {
  final List<CartItem> _items = [];

  List<CartItem> get items => [..._items];

  int get itemCount => _items.length;

  double get totalAmount {
    return _items.fold(0.0, (sum, item) => sum + item.totalPrice);
  }

  void addItem(CartItem item) {
    final existingIndex = _items.indexWhere((cartItem) => cartItem.id == item.id);
    if (existingIndex >= 0) {
      _items[existingIndex].quantity += item.quantity;
    } else {
      _items.add(item);
    }
    notifyListeners();
  }

  void removeItem(String id) {
    _items.removeWhere((item) => item.id == id);
    notifyListeners();
  }

  void updateQuantity(String id, int newQuantity) {
    final index = _items.indexWhere((item) => item.id == id);
    if (index >= 0) {
      _items[index].quantity = newQuantity;
      if (newQuantity <= 0) {
        removeItem(id);
      }
      notifyListeners();
    }
  }

  void toggleLike(String id) {
    final index = _items.indexWhere((item) => item.id == id);
    if (index >= 0) {
      _items[index].isLiked = !_items[index].isLiked;
      notifyListeners();
    }
  }

  void toggleWishlist(String id) {
    final index = _items.indexWhere((item) => item.id == id);
    if (index >= 0) {
      _items[index].isInWishlist = !_items[index].isInWishlist;
      notifyListeners();
    }
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }

  void toggleItemSelection(String id) {
    final index = _items.indexWhere((item) => item.id == id);
    if (index >= 0) {
      _items[index].isSelected = !_items[index].isSelected;
      notifyListeners();
    }
  }

  void selectAllItems(bool select) {
    for (var item in _items) {
      item.isSelected = select;
    }
    notifyListeners();
  }

  List<CartItem> get selectedItems => _items.where((item) => item.isSelected).toList();

  int get selectedItemCount => _items.where((item) => item.isSelected).length;

  double get selectedTotalAmount {
    return selectedItems.fold(0.0, (sum, item) => sum + item.totalPrice);
  }

  void clearSelection() {
    for (var item in _items) {
      item.isSelected = false;
    }
    notifyListeners();
  }
}
