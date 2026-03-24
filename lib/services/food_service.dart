import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/food_item.dart';

class FoodService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<FoodItem> getFoodItem(String foodName) async {
    try {
      final docSnapshot = await _firestore.collection('foods').doc(foodName).get();

      if (docSnapshot.exists && docSnapshot.data() != null) {
        return FoodItem.fromMap(docSnapshot.data()!);
      } else {
        throw Exception("Food item not found in Firebase");
      }
    } catch (e) {
      print("Error fetching food item: $e");
      rethrow;
    }
  }

  // Метод для массовой загрузки данных в Firestore
  Future<void> uploadInitialFoods() async {
    final List<Map<String, dynamic>> foods = [
      // PIZZAS
      {
        'name': 'Margherita Pizza',
        'imagePath': 'assets/pizza.png',
        'price': 3500,
        'category': 'Pizza',
        'ingredients': ['Tomato Sauce', 'Mozzarella', 'Fresh Basil', 'Olive Oil']
      },
      {
        'name': 'Pepperoni Pizza',
        'imagePath': 'assets/pizza.png',
        'price': 4200,
        'category': 'Pizza',
        'ingredients': ['Tomato Sauce', 'Mozzarella', 'Pepperoni', 'Oregano']
      },
      {
        'name': 'Hawaiian Pizza',
        'imagePath': 'assets/pizza.png',
        'price': 4000,
        'category': 'Pizza',
        'ingredients': ['Tomato Sauce', 'Mozzarella', 'Ham', 'Pineapple']
      },
      {
        'name': 'BBQ Chicken Pizza',
        'imagePath': 'assets/pizza.png',
        'price': 4500,
        'category': 'Pizza',
        'ingredients': ['BBQ Sauce', 'Mozzarella', 'Grilled Chicken', 'Red Onions']
      },
      {
        'name': 'Four Cheese Pizza',
        'imagePath': 'assets/pizza.png',
        'price': 4800,
        'category': 'Pizza',
        'ingredients': ['Mozzarella', 'Parmesan', 'Gorgonzola', 'Emmental']
      },
      // BURGERS
      {
        'name': 'Classic Burger',
        'imagePath': 'assets/burger.png',
        'price': 2500,
        'category': 'Burger',
        'ingredients': ['Beef Patty', 'Lettuce', 'Tomato', 'Onion', 'Special Sauce']
      },
      {
        'name': 'Cheeseburger',
        'imagePath': 'assets/burger.png',
        'price': 2800,
        'category': 'Burger',
        'ingredients': ['Beef Patty', 'Cheddar Cheese', 'Pickles', 'Ketchup', 'Mustard']
      },
      {
        'name': 'Double Bacon Burger',
        'imagePath': 'assets/burger.png',
        'price': 3800,
        'category': 'Burger',
        'ingredients': ['Double Beef Patty', 'Crispy Bacon', 'Cheddar', 'BBQ Sauce']
      },
      {
        'name': 'Chicken Zinger',
        'imagePath': 'assets/burger.png',
        'price': 3000,
        'category': 'Burger',
        'ingredients': ['Crispy Chicken', 'Mayo', 'Lettuce', 'Sesame Bun']
      },
      {
        'name': 'Mushroom Swiss Burger',
        'imagePath': 'assets/burger.png',
        'price': 3200,
        'category': 'Burger',
        'ingredients': ['Beef Patty', 'Sautéed Mushrooms', 'Swiss Cheese', 'Garlic Aioli']
      },
      // SUSHI
      {
        'name': 'Salmon Nigiri',
        'imagePath': 'assets/sushi.png',
        'price': 1200,
        'category': 'Sushi',
        'ingredients': ['Fresh Salmon', 'Vinegared Rice', 'Wasabi']
      },
      {
        'name': 'California Roll',
        'imagePath': 'assets/sushi.png',
        'price': 2200,
        'category': 'Sushi',
        'ingredients': ['Crab Stick', 'Avocado', 'Cucumber', 'Tobiko']
      },
      {
        'name': 'Philadelphia Roll',
        'imagePath': 'assets/sushi.png',
        'price': 2800,
        'category': 'Sushi',
        'ingredients': ['Cream Cheese', 'Salmon', 'Cucumber', 'Rice']
      },
      {
        'name': 'Dragon Roll',
        'imagePath': 'assets/sushi.png',
        'price': 3500,
        'category': 'Sushi',
        'ingredients': ['Shrimp Tempura', 'Unagi', 'Avocado', 'Eel Sauce']
      },
      {
        'name': 'Spicy Tuna Roll',
        'imagePath': 'assets/sushi.png',
        'price': 2500,
        'category': 'Sushi',
        'ingredients': ['Tuna', 'Spicy Mayo', 'Spring Onion']
      },
      {
        'name': 'Tempura Set',
        'imagePath': 'assets/sushi.png',
        'price': 4000,
        'category': 'Sushi',
        'ingredients': ['Shrimp Tempura', 'Veggie Tempura', 'Tentsuyu Sauce']
      },
      // EXTRA ITEMS
      {
        'name': 'Greek Salad',
        'imagePath': 'assets/pizza.png',
        'price': 1800,
        'category': 'Other',
        'ingredients': ['Cucumber', 'Tomato', 'Feta Cheese', 'Olives', 'Red Onion']
      },
      {
        'name': 'French Fries',
        'imagePath': 'assets/burger.png',
        'price': 1000,
        'category': 'Other',
        'ingredients': ['Potato', 'Salt', 'Vegetable Oil']
      },
    ];

    WriteBatch batch = _firestore.batch();

    for (var food in foods) {
      DocumentReference docRef = _firestore.collection('foods').doc(food['name']);
      batch.set(docRef, food);
    }

    try {
      await batch.commit();
    } catch (e) {
      print("Error uploading foods: $e");
      rethrow;
    }
  }
}
