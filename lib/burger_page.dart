import 'package:flutter/material.dart';
import 'cart_manager.dart';

class Review {
  final String author;
  final String text;
  final int rating;

  Review({required this.author, required this.text, required this.rating});
}

class BurgerPage extends StatefulWidget {
  const BurgerPage({super.key});

  @override
  State<BurgerPage> createState() => _BurgerPageState();
}

class _BurgerPageState extends State<BurgerPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _reviewController = TextEditingController();
  final List<Review> _reviews = [
    Review(author: "Squidward Tentacles", text: "I HATE THIS BURGER", rating: 1),
  ];
  int _currentRating = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _reviewController.dispose();
    super.dispose();
  }

  void _submitReview() {
    if (_reviewController.text.isNotEmpty && _currentRating > 0) {
      setState(() {
        _reviews.add(
          Review(
            author: "New User", // In a real app, you'd get the current user's name
            text: _reviewController.text,
            rating: _currentRating,
          ),
        );
        _reviewController.clear();
        _currentRating = 0;
      });
      // Hide the keyboard
      FocusScope.of(context).unfocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          "Burger Details",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        actions: [
          ListenableBuilder(
            listenable: cartManager,
            builder: (context, _) {
              final quantity = cartManager.getQuantity("Burger");
              return Row(
                children: [
                  IconButton(
                    onPressed: () {
                      cartManager.removeItem("Burger");
                    },
                    icon: const Icon(Icons.remove, color: Colors.black),
                  ),
                  Text(
                    '$quantity',
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      cartManager.addItem("Burger", "assets/burger.png", 3000);
                    },
                    icon: const Icon(Icons.add, color: Colors.black),
                  ),
                ],
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Section
            Container(
              height: 250,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: ClipRRect(
                child: Hero(
                  tag: "assets/burger.png",
                  child: Image.asset(
                    "assets/burger.png",
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Info Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Burger",
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.green[50],
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          "3000 KZT",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Divider(),
                  const SizedBox(height: 16),

                  TabBar(
                    controller: _tabController,
                    labelColor: Colors.black,
                    unselectedLabelColor: Colors.grey,
                    indicatorColor: Colors.orange,
                    tabs: const [
                      Tab(text: "Ingredients"),
                      Tab(text: "Ratings"),
                    ],
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 300, // Adjust height as needed
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        // Ingredients Tab Content
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildIngredientItem("Brioche Bun"),
                            _buildIngredientItem("Beef Patty (150g)"),
                            _buildIngredientItem("Cheddar Cheese"),
                            _buildIngredientItem("Crispy Lettuce"),
                            _buildIngredientItem("Fresh Tomato Slices"),
                            _buildIngredientItem("Pickles"),
                            _buildIngredientItem("Special Sauce"),
                          ],
                        ),
                        // Description Tab Content
                        Column(
                          children: [
                            Expanded(
                              child: ListView.builder(
                                itemCount: _reviews.length,
                                itemBuilder: (context, index) {
                                  final review = _reviews[index];
                                  return ListTile(
                                    leading: ClipOval(
                                      child: Image.asset(
                                        "assets/profile.png",
                                        width: 50,
                                        height: 50,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    title: Text(review.author),
                                    subtitle: Text(
                                      review.text,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    trailing: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: List.generate(5, (starIndex) {
                                        return Icon(
                                          starIndex < review.rating
                                              ? Icons.star
                                              : Icons.star_border_outlined,
                                          color: Colors.amber,
                                          size: 16,
                                        );
                                      }),
                                    ),
                                  );
                                },
                              ),
                            ),
                            _buildReviewInputField(),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReviewInputField() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(5, (index) {
            return IconButton(
              icon: Icon(
                index < _currentRating ? Icons.star : Icons.star_border,
                color: Colors.amber,
              ),
              onPressed: () {
                setState(() {
                  _currentRating = index + 1;
                });
              },
            );
          }),
        ),
        TextFormField(
          controller: _reviewController,
          decoration: InputDecoration(
            hintText: 'Write a review...',
            fillColor: Colors.grey[200],
            filled: true,
            contentPadding: const EdgeInsets.symmetric(
              vertical: 15.0,
              horizontal: 20.0,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30.0),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30.0),
              borderSide: BorderSide(
                color: Colors.grey[300]!,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30.0),
              borderSide: const BorderSide(
                color: Colors.orange,
              ),
            ),
            suffixIcon: IconButton(
              icon: const Icon(Icons.send),
              onPressed: _submitReview,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildIngredientItem(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Icon(Icons.check_circle_outline, color: Colors.orange[400], size: 20),
          const SizedBox(width: 12),
          Text(text, style: TextStyle(fontSize: 16, color: Colors.grey[800])),
        ],
      ),
    );
  }
}
