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
      // Здесь можно обработать ошибки, например, если нет интернет-соединения
      print("Error fetching food item: $e");
      rethrow; // Передаем ошибку дальше, чтобы UI мог ее обработать
    }
  }
}
