// ЗАГОТОВКА ДЛЯ FIREBASE: Шаг 1
// 1. Добавьте зависимость `cloud_firestore` в ваш `pubspec.yaml`
// 2. Раскомментируйте эту строку:
// import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/food_item.dart';
import '../models/review.dart';

/// [FoodService] - это класс, который имитирует получение данных из внешнего источника,
/// например, из Firebase. В будущем вы сможете заменить логику в его методах
/// на реальные запросы к вашей базе данных.
class FoodService {
  /// Универсальный метод для получения данных о еде.
  /// Когда вы будете готовы использовать Firebase, закомментируйте текущую реализацию
  /// и раскомментируйте реализацию для Firebase ниже.
  Future<FoodItem> getFoodItem(String foodId) async {
    // ТЕКУЩАЯ РЕАЛИЗАЦИЯ (ИМИТАЦИЯ)
    switch (foodId.toLowerCase()) {
      case 'pizza':
        return _getPizza();
      case 'burger':
        return _getBurger();
      case 'sushi':
        return _getSushi();
      default:
        throw Exception("Unknown foodId: $foodId");
    }

    // ЗАГОТОВКА ДЛЯ FIREBASE: Шаг 4
    // Раскомментируйте этот код, когда настроите Firebase и модели.
    /*
    try {
      final docSnapshot = await FirebaseFirestore.instance
          .collection('products') // Ваша коллекция в Firestore
          .doc(foodId) // Документ, который нужно получить
          .get();

      if (docSnapshot.exists && docSnapshot.data() != null) {
        // Используем factory-конструктор из модели для преобразования данных
        return FoodItem.fromFirestore(docSnapshot.data()!);
      } else {
        throw Exception("Food item not found in Firebase");
      }
    } catch (e) {
      // Здесь можно обработать ошибки, например, если нет интернет-соединения
      print("Error fetching food item: $e");
      rethrow; // Передаем ошибку дальше, чтобы UI мог ее обработать
    }
    */
  }

  // --- Приватные методы для имитации ---
  // Этот код можно будет удалить после перехода на Firebase

  Future<FoodItem> _getPizza() async {
    await Future.delayed(const Duration(seconds: 1));
    return FoodItem(
      name: "Pizza",
      imagePath: "assets/pizza.png",
      price: 5000,
      ingredients: [
        "Fresh Tomato Sauce",
        "Mozzarella Cheese",
        "Spicy Pepperoni",
        "Sliced Mushrooms",
        "Green Bell Peppers",
        "Black Olives",
        "Italian Oregano",
      ],
      reviews: [
        Review(author: "Squidward Tentacles", text: "I LOVE THIS PIZZA", rating: 5),
      ],
    );
  }

  Future<FoodItem> _getBurger() async {
    await Future.delayed(const Duration(seconds: 1));
    return FoodItem(
      name: "Burger",
      imagePath: "assets/burger.png",
      price: 3000,
      ingredients: [
        "Brioche Bun",
        "Beef Patty (150g)",
        "Cheddar Cheese",
        "Crispy Lettuce",
        "Fresh Tomato Slices",
        "Pickles",
        "Special Sauce",
      ],
      reviews: [
        Review(author: "Squidward Tentacles", text: "I HATE THIS BURGER", rating: 1),
      ],
    );
  }

  Future<FoodItem> _getSushi() async {
    await Future.delayed(const Duration(seconds: 1));
    return FoodItem(
      name: "Sushi",
      imagePath: "assets/sushi.png",
      price: 10000,
      ingredients: [
        "Fresh Salmon",
        "Sushi Rice",
        "Nori Seaweed",
        "Avocado",
        "Cucumber",
        "Soy Sauce",
        "Wasabi & Ginger",
      ],
      reviews: [
        Review(author: "Squidward Tentacles", text: "I GOT FOOD POISONING FROM THIS", rating: 1),
      ],
    );
  }
}
