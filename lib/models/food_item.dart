class FoodItem {
  final String name;
  final String imagePath;
  final int price;
  final List<String> ingredients;

  FoodItem({
    required this.name,
    required this.imagePath,
    required this.price,
    required this.ingredients,
  });

  factory FoodItem.fromMap(Map<String, dynamic> data) {
    return FoodItem(
      name: data['name'] ?? 'No Name',
      imagePath: data['imagePath'] ?? '',
      price: data['price'] ?? 0,
      ingredients: List<String>.from(data['ingredients'] ?? []),
    );
  }
}
