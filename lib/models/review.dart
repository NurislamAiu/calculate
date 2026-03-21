class Review {
  final String author;
  final String text;
  final int rating;

  Review({required this.author, required this.text, required this.rating});

  // Factory constructor to create a Review from a map (e.g., from Firestore)
  factory Review.fromMap(Map<String, dynamic> map) {
    return Review(
      author: map['author'] ?? 'Unknown Author',
      text: map['text'] ?? '',
      rating: map['rating'] ?? 0,
    );
  }
}
