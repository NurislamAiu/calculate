import 'package:cloud_firestore/cloud_firestore.dart';
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

  factory CartItem.fromMap(Map<String, dynamic> map) {
    return CartItem(
      name: map['name'] ?? 'No Name',
      imagePath: map['imagePath'] ?? '',
      price: map['price'] ?? 0,
      quantity: map['quantity'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'imagePath': imagePath,
      'price': price,
      'quantity': quantity,
    };
  }
}

class CartManager extends ChangeNotifier {
  List<CartItem> _items = [];
  String? _userId;

  List<CartItem> get items => _items;

  int get totalQuantity => _items.fold(0, (sum, item) => sum + item.quantity);

  int get totalPrice => _items.fold(0, (sum, item) => sum + (item.price * item.quantity));

  Future<void> loadCart(String userId) async {
    _userId = userId;
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(_userId)
          .collection('cart')
          .get();

      _items = snapshot.docs.map((doc) => CartItem.fromMap(doc.data())).toList();
      notifyListeners();
    } catch (e) {
      print("Error loading cart: $e");
    }
  }

  int getQuantity(String name) {
    try {
      return _items.firstWhere((item) => item.name == name).quantity;
    } catch (e) {
      return 0;
    }
  }

  void addItem(String name, String imagePath, int price) {
    final index = _items.indexWhere((item) => item.name == name);
    if (index >= 0) {
      _items[index].quantity++;
    } else {
      _items.add(CartItem(name: name, imagePath: imagePath, price: price));
    }
    _syncItemToFirebase(_items.firstWhere((item) => item.name == name));
    notifyListeners();
  }

  void removeItem(String name) {
    final index = _items.indexWhere((item) => item.name == name);
    if (index >= 0) {
      if (_items[index].quantity > 1) {
        _items[index].quantity--;
        _syncItemToFirebase(_items[index]);
      } else {
        _deleteItemFromFirebase(_items[index]);
        _items.removeAt(index);
      }
      notifyListeners();
    }
  }
  
  Future<void> clearCart() async {
    if (_userId == null) return;

    // Create a batch to delete all documents
    final batch = FirebaseFirestore.instance.batch();
    final cartCollection = FirebaseFirestore.instance
        .collection('users')
        .doc(_userId)
        .collection('cart');
    
    final snapshot = await cartCollection.get();
    for (final doc in snapshot.docs) {
      batch.delete(doc.reference);
    }
    await batch.commit();

    _items.clear();
    notifyListeners();
  }


  Future<void> _syncItemToFirebase(CartItem item) async {
    if (_userId == null) return;

    final itemDoc = FirebaseFirestore.instance
        .collection('users')
        .doc(_userId)
        .collection('cart')
        .doc(item.name);

    await itemDoc.set(item.toMap());
  }

  Future<void> _deleteItemFromFirebase(CartItem item) async {
    if (_userId == null) return;
    
    await FirebaseFirestore.instance
        .collection('users')
        .doc(_userId)
        .collection('cart')
        .doc(item.name)
        .delete();
  }
}

final cartManager = CartManager();
