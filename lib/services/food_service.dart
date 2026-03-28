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
      // FOOD
      {
        'name': 'Baguette with salmon',
        'imagePath': 'assets/coming.jpg', // Temporary placeholder image
        'price': 3700,
        'category': 'Food',
        'ingredients': ['Baguette', 'Salmon', 'Cream Cheese']
      },
      {
        'name': 'Baguette with mozzarella',
        'imagePath': 'assets/coming.jpg',
        'price': 3700,
        'category': 'Food',
        'ingredients': ['Baguette', 'Mozzarella', 'Tomatoes', 'Pesto']
      },
      {
        'name': 'Baguette with chicken',
        'imagePath': 'assets/coming.jpg',
        'price': 3200,
        'category': 'Food',
        'ingredients': ['Baguette', 'Chicken', 'Lettuce', 'Sauce']
      },
      {
        'name': 'Croissant with salmon',
        'imagePath': 'assets/coming.jpg',
        'price': 3700,
        'category': 'Food',
        'ingredients': ['Croissant', 'Salmon', 'Cream Cheese']
      },
      {
        'name': 'Croissant with mozzarella',
        'imagePath': 'assets/coming.jpg',
        'price': 3700,
        'category': 'Food',
        'ingredients': ['Croissant', 'Mozzarella', 'Tomatoes', 'Pesto']
      },
      {
        'name': 'Croissant with chicken',
        'imagePath': 'assets/coming.jpg',
        'price': 3200,
        'category': 'Food',
        'ingredients': ['Croissant', 'Chicken', 'Lettuce', 'Sauce']
      },
      {
        'name': 'Syrniki (cottage cheese pancakes)',
        'imagePath': 'assets/coming.jpg',
        'price': 3500,
        'category': 'Food',
        'ingredients': ['Cottage Cheese', 'Flour', 'Eggs', 'Sugar']
      },
      // PASTRIES
      {
        'name': 'Classic croissant',
        'imagePath': 'assets/coming.jpg',
        'price': 1300,
        'category': 'Pastries',
        'ingredients': ['Flour', 'Butter', 'Yeast']
      },
      {
        'name': 'Strawberry croissant',
        'imagePath': 'assets/coming.jpg',
        'price': 1700,
        'category': 'Pastries',
        'ingredients': ['Croissant', 'Strawberry Jam']
      },
      {
        'name': 'Almond croissant',
        'imagePath': 'assets/coming.jpg',
        'price': 1800,
        'category': 'Pastries',
        'ingredients': ['Croissant', 'Almond Cream', 'Almond Flakes']
      },
      {
        'name': 'Snail with raisins and candied fruit',
        'imagePath': 'assets/coming.jpg',
        'price': 1400,
        'category': 'Pastries',
        'ingredients': ['Puff Pastry', 'Raisins', 'Candied Fruit']
      },
      {
        'name': 'Apple chausson',
        'imagePath': 'assets/coming.jpg',
        'price': 1700,
        'category': 'Pastries',
        'ingredients': ['Puff Pastry', 'Apple Filling']
      },
      {
        'name': 'Swiss puff pastry',
        'imagePath': 'assets/coming.jpg',
        'price': 1500,
        'category': 'Pastries',
        'ingredients': ['Puff Pastry', 'Custard', 'Chocolate Chips']
      },
      {
        'name': 'Swedish bun',
        'imagePath': 'assets/coming.jpg',
        'price': 1300,
        'category': 'Pastries',
        'ingredients': ['Dough', 'Cardamom', 'Sugar']
      },
      {
        'name': 'Poppy seed bun',
        'imagePath': 'assets/coming.jpg',
        'price': 1300,
        'category': 'Pastries',
        'ingredients': ['Dough', 'Poppy Seeds', 'Sugar']
      },
      // COFFEE
      {
        'name': 'Espresso',
        'imagePath': 'assets/coming.jpg',
        'price': 900,
        'category': 'Coffee',
        'ingredients': ['Coffee Beans', 'Water']
      },
      {
        'name': 'Americano 0.35',
        'imagePath': 'assets/coming.jpg',
        'price': 1200,
        'category': 'Coffee',
        'ingredients': ['Espresso', 'Hot Water']
      },
      {
        'name': 'Cappuccino large 0.35',
        'imagePath': 'assets/coming.jpg',
        'price': 1400,
        'category': 'Coffee',
        'ingredients': ['Espresso', 'Steamed Milk', 'Milk Foam']
      },
      {
        'name': 'Cappuccino small 0.2',
        'imagePath': 'assets/coming.jpg',
        'price': 1200,
        'category': 'Coffee',
        'ingredients': ['Espresso', 'Steamed Milk', 'Milk Foam']
      },
      {
        'name': 'Latte 0.35',
        'imagePath': 'assets/coming.jpg',
        'price': 1400,
        'category': 'Coffee',
        'ingredients': ['Espresso', 'Lots of Steamed Milk', 'Light Foam']
      },
      {
        'name': 'Flat white 0.2',
        'imagePath': 'assets/coming.jpg',
        'price': 1300,
        'category': 'Coffee',
        'ingredients': ['Double Espresso', 'Micro-foamed Milk']
      },
      {
        'name': 'Plant-based milk (add-on)',
        'imagePath': 'assets/coming.jpg',
        'price': 400,
        'category': 'Coffee',
        'ingredients': ['Plant-based Milk']
      },
      // SIGNATURE TEAS
      {
        'name': 'Cranberry - Orange 0.35',
        'imagePath': 'assets/coming.jpg',
        'price': 2200,
        'category': 'Signature Tea',
        'ingredients': ['Cranberry', 'Orange', 'Tea', 'Honey']
      },
      {
        'name': 'Sea buckthorn - Raspberry - Lime 0.35',
        'imagePath': 'assets/coming.jpg',
        'price': 2200,
        'category': 'Signature Tea',
        'ingredients': ['Sea buckthorn', 'Raspberry', 'Lime', 'Tea']
      },
      {
        'name': 'Currant - Thyme 0.35',
        'imagePath': 'assets/coming.jpg',
        'price': 2200,
        'category': 'Signature Tea',
        'ingredients': ['Currant', 'Thyme', 'Tea']
      },
      {
        'name': 'Raspberry - Mango 0.35',
        'imagePath': 'assets/coming.jpg',
        'price': 2200,
        'category': 'Signature Tea',
        'ingredients': ['Raspberry', 'Mango', 'Tea']
      },
      {
        'name': 'Cherry - Eucalyptus 0.35',
        'imagePath': 'assets/coming.jpg',
        'price': 2200,
        'category': 'Signature Tea',
        'ingredients': ['Cherry', 'Eucalyptus', 'Tea']
      },
      // HOT DRINKS
      {
        'name': 'Non-alcoholic mulled wine 0.35',
        'imagePath': 'assets/coming.jpg',
        'price': 2200,
        'category': 'Hot Drinks',
        'ingredients': ['Grape Juice', 'Spices', 'Fruits']
      },
      {
        'name': 'Matcha latte 0.35',
        'imagePath': 'assets/coming.jpg',
        'price': 2000,
        'category': 'Hot Drinks',
        'ingredients': ['Matcha Powder', 'Steamed Milk']
      },
      {
        'name': 'Matcha latte with plant milk 0.35',
        'imagePath': 'assets/coming.jpg',
        'price': 2400,
        'category': 'Hot Drinks',
        'ingredients': ['Matcha Powder', 'Plant-based Milk']
      },
      {
        'name': 'Hot chocolate 0.35',
        'imagePath': 'assets/coming.jpg',
        'price': 1500,
        'category': 'Hot Drinks',
        'ingredients': ['Chocolate', 'Milk']
      },
      {
        'name': 'Black tea (teapot) 0.8',
        'imagePath': 'assets/coming.jpg',
        'price': 1500,
        'category': 'Hot Drinks',
        'ingredients': ['Black Tea Leaves', 'Hot Water']
      },
      {
        'name': 'Green tea (teapot) 0.8',
        'imagePath': 'assets/coming.jpg',
        'price': 1500,
        'category': 'Hot Drinks',
        'ingredients': ['Green Tea Leaves', 'Hot Water']
      },
      {
        'name': 'Herbal tea (teapot) 0.8',
        'imagePath': 'assets/coming.jpg',
        'price': 1500,
        'category': 'Hot Drinks',
        'ingredients': ['Herbal Blend', 'Hot Water']
      },
      {
        'name': 'Fruit hibiscus (teapot) 0.8',
        'imagePath': 'assets/coming.jpg',
        'price': 1500,
        'category': 'Hot Drinks',
        'ingredients': ['Hibiscus Flowers', 'Dried Fruits', 'Hot Water']
      },
    ];

    try {
      // First, delete existing menu items
      final existingFoods = await _firestore.collection('foods').get();
      WriteBatch deleteBatch = _firestore.batch();
      for (var doc in existingFoods.docs) {
        deleteBatch.delete(doc.reference);
      }
      await deleteBatch.commit();

      // Second, upload new items
      WriteBatch createBatch = _firestore.batch();
      for (var food in foods) {
        DocumentReference docRef = _firestore.collection('foods').doc(food['name']);
        createBatch.set(docRef, food);
      }
      await createBatch.commit();

    } catch (e) {
      print("Error uploading foods: $e");
      rethrow;
    }
  }
}
