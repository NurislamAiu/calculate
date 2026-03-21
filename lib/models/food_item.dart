import 'review.dart';

/// [FoodItem] - это класс-модель, который представляет собой один элемент еды в приложении.
/// Он содержит всю необходимую информацию о продукте, такую как название,
/// цена, изображение, ингредиенты и отзывы.
/// Использование такой модели позволяет отделить данные от их визуального представления.
class FoodItem {
  final String name;
  final String imagePath;
  final int price;
  final List<String> ingredients;
  final List<Review> reviews;

  FoodItem({
    required this.name,
    required this.imagePath,
    required this.price,
    required this.ingredients,
    required this.reviews,
  });

  // ЗАГОТОВКА ДЛЯ FIREBASE: Шаг 3
  // Этот factory-конструктор позволяет создать экземпляр [FoodItem]
  // из данных (Map), полученных от Firestore.
  /*
  factory FoodItem.fromFirestore(Map<String, dynamic> firestoreData) {
    // Безопасно извлекаем список отзывов.
    // Если поле 'reviews' существует и является списком, преобразуем каждый элемент.
    final reviewsList = firestoreData['reviews'] as List<dynamic>?;
    final reviews = reviewsList != null
        ? reviewsList.map((reviewData) => Review.fromMap(reviewData)).toList()
        : <Review>[]; // Если отзывов нет, создаем пустой список.

    return FoodItem(
      // Используем оператор `??` для установки значений по умолчанию,
      // если какое-то поле в Firestore отсутствует.
      name: firestoreData['name'] ?? 'No Name',
      // ВАЖНО: Предполагается, что в Firestore вы храните только имя файла (например, "pizza.png"),
      // а путь "assets/" добавляется уже в коде.
      imagePath: 'assets/${firestoreData['imagePath'] ?? ''}',
      price: firestoreData['price'] ?? 0,
      // Преобразуем список ингредиентов из List<dynamic> в List<String>.
      ingredients: List<String>.from(firestoreData['ingredients'] ?? []),
      reviews: reviews,
    );
  }
  */
}
