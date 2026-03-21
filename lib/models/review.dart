/// [Review] - это класс-модель для одного отзыва.
/// Он содержит информацию об авторе, тексте отзыва и поставленной оценке.
class Review {
  final String author;
  final String text;
  final int rating;

  Review({required this.author, required this.text, required this.rating});

  // ЗАГОТОВКА ДЛЯ FIREBASE: Шаг 2 (часть 1)
  // Этот factory-конструктор позволяет создать экземпляр [Review]
  // из данных (Map), полученных от Firestore.
  // Firestore хранит данные в формате ключ-значение, который легко представить как Map.
  /*
  factory Review.fromMap(Map<String, dynamic> map) {
    return Review(
      author: map['author'] ?? 'Unknown Author',
      text: map['text'] ?? '',
      rating: map['rating'] ?? 0,
    );
  }
  */
}
