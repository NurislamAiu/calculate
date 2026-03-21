// ЗАГОТОВКА ДЛЯ FIREBASE: Раскомментируйте
// import 'package:cloud_firestore/cloud_firestore.dart';
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

  // ЗАГОТОВКА ДЛЯ FIREBASE: Конструктор для преобразования данных из Firestore
  /*
  factory CartItem.fromMap(Map<String, dynamic> map) {
    return CartItem(
      name: map['name'] ?? 'No Name',
      imagePath: map['imagePath'] ?? '',
      price: map['price'] ?? 0,
      quantity: map['quantity'] ?? 0,
    );
  }

  // Метод для преобразования объекта в Map для записи в Firestore
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'imagePath': imagePath,
      'price': price,
      'quantity': quantity,
    };
  }
  */
}

class CartManager extends ChangeNotifier {
  List<CartItem> _items = [];
  // ЗАГОТОВКА ДЛЯ FIREBASE: Хранение ID пользователя для запросов
  // String? _userId;

  List<CartItem> get items => _items;

  int get totalQuantity => _items.fold(0, (sum, item) => sum + item.quantity);

  int get totalPrice =>
      _items.fold(0, (sum, item) => sum + (item.price * item.quantity));

  // ЗАГОТОВКА ДЛЯ FIREBASE: Метод для инициализации корзины из Firestore
  /*
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
      // Обработайте ошибку по своему усмотрению
    }
  }
  */

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
    // ЗАГОТОВКА ДЛЯ FIREBASE: Синхронизация после изменения
    // _syncItemToFirebase(name);
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
      // ЗАГОТОВКА ДЛЯ FIREBASE: Синхронизация после изменения
      // _syncItemToFirebase(name);
      notifyListeners();
    }
  }

  // ЗАГОТОВКА ДЛЯ FIREBASE: Приватный метод для записи одного элемента в Firestore
  /*
  Future<void> _syncItemToFirebase(String name) async {
    if (_userId == null) return; // Не синхронизируем, если пользователь не вошел

    final index = _items.indexWhere((item) => item.name == name);
    final itemDoc = FirebaseFirestore.instance
        .collection('users')
        .doc(_userId)
        .collection('cart')
        .doc(name); // Используем имя как ID документа

    if (index >= 0) {
      // Если элемент еще есть в корзине (добавление или уменьшение кол-ва)
      await itemDoc.set(_items[index].toMap());
    } else {
      // Если элемент был полностью удален
      await itemDoc.delete();
    }
  }
  */
}

// Global instance for simple state management
final cartManager = CartManager();
