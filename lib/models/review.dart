class Review {
  final String author;
  final String text;
  final int rating;
  final String? reply; // New field for admin replies

  Review({
    required this.author,
    required this.text,
    required this.rating,
    this.reply,
  });

  factory Review.fromMap(Map<String, dynamic> map) {
    return Review(
      author: map['author'] ?? 'Unknown Author',
      text: map['text'] ?? '',
      rating: map['rating'] ?? 0,
      reply: map['reply'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'author': author,
      'text': text,
      'rating': rating,
      'reply': reply,
    };
  }
}
