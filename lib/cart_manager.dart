import 'package:flutter/material.dart';

class CartItem {
  final String name;
  final String imagePath;
  final int price;
  int quantity;

  CartItem({
    required this.name,
    required this.imagePath,
    required this.price,
    this.quantity = 1,
  });
}

class CartManager extends ChangeNotifier {
  final List<CartItem> _items = [];

  List<CartItem> get items => _items;

  int get totalQuantity => _items.fold(0, (sum, item) => sum + item.quantity);

  int get totalPrice =>
      _items.fold(0, (sum, item) => sum + (item.price * item.quantity));

  int getQuantity(String name) {
    final index = _items.indexWhere((item) => item.name == name);
    if (index >= 0) return _items[index].quantity;
    return 0;
  }

  void addItem(String name, String imagePath, int price) {
    final index = _items.indexWhere((item) => item.name == name);
    if (index >= 0) {
      _items[index].quantity++;
    } else {
      _items.add(CartItem(name: name, imagePath: imagePath, price: price));
    }
    notifyListeners();
  }

  void removeItem(String name) {
    final index = _items.indexWhere((item) => item.name == name);
    if (index >= 0) {
      if (_items[index].quantity > 1) {
        _items[index].quantity--;
      } else {
        _items.removeAt(index);
      }
      notifyListeners();
    }
  }
}

// Global instance for simple state management
final cartManager = CartManager();
