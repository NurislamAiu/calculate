import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:example/services/auth_service.dart';
import 'package:example/services/user_service.dart';
import 'package:flutter/material.dart';
import '../cart_manager.dart';
import '../models/food_item.dart';
import '../models/review.dart';
import '../models/user_profile.dart';

class ItemDetailPage extends StatefulWidget {
  final FoodItem item;

  const ItemDetailPage({super.key, required this.item});

  @override
  State<ItemDetailPage> createState() => _ItemDetailPageState();
}

class _ItemDetailPageState extends State<ItemDetailPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _reviewController = TextEditingController();
  int _currentRating = 0;
  String? _userName;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final user = AuthService().currentUser;
    if (user != null) {
      // We can use a one-time fetch here instead of a stream
      final doc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
       if (doc.exists && doc.data() != null) {
        final userProfile = UserProfile.fromMap(doc.data()!);
        if (mounted) {
          setState(() {
            _userName = userProfile.name;
          });
        }
       }
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    _reviewController.dispose();
    super.dispose();
  }

  void _submitReview() {
    if (_reviewController.text.isNotEmpty &&
        _currentRating > 0 &&
        _userName != null) {
      FirebaseFirestore.instance
          .collection('reviews')
          .doc(widget.item.name)
          .collection('item_reviews')
          .add({
        'author': _userName, // Use the fetched user name
        'text': _reviewController.text,
        'rating': _currentRating,
        'timestamp': FieldValue.serverTimestamp(),
      });
      _reviewController.clear();
      setState(() {
        _currentRating = 0;
      });
      FocusScope.of(context).unfocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          "${widget.item.name} Details",
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        actions: [
          ListenableBuilder(
            listenable: cartManager,
            builder: (context, _) {
              final quantity = cartManager.getQuantity(widget.item.name);
              return Row(
                children: [
                  IconButton(
                    onPressed: () {
                      cartManager.removeItem(widget.item.name);
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
                      cartManager.addItem(
                          widget.item.name, widget.item.imagePath, widget.item.price);
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
                  tag: widget.item.imagePath,
                  child: Image.asset(widget.item.imagePath, fit: BoxFit.contain),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.item.name,
                        style: const TextStyle(
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
                        child: Text(
                          "${widget.item.price} KZT",
                          style: const TextStyle(
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
                    height: 300,
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        ListView.builder(
                          itemCount: widget.item.ingredients.length,
                          itemBuilder: (context, index) {
                            return _buildIngredientItem(widget.item.ingredients[index]);
                          },
                        ),
                        Column(
                          children: [
                            Expanded(
                              child: StreamBuilder<QuerySnapshot>(
                                stream: FirebaseFirestore.instance
                                    .collection('reviews')
                                    .doc(widget.item.name)
                                    .collection('item_reviews')
                                    .orderBy('timestamp', descending: true)
                                    .snapshots(),
                                builder: (context, snapshot) {
                                  if (snapshot.hasError) {
                                    return const Text('Something went wrong');
                                  }
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return const Center(
                                        child: CircularProgressIndicator());
                                  }

                                  final reviews = snapshot.data!.docs.map((doc) {
                                    final data =
                                        doc.data() as Map<String, dynamic>;
                                    return Review(
                                      author: data['author'],
                                      text: data['text'],
                                      rating: data['rating'],
                                    );
                                  }).toList();

                                  return ListView.builder(
                                    itemCount: reviews.length,
                                    itemBuilder: (context, index) {
                                      final review = reviews[index];
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
                                          children:
                                              List.generate(5, (starIndex) {
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
