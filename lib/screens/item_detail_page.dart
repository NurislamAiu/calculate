import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:example/services/auth_service.dart';
import 'package:flutter/material.dart';
import '../cart_manager.dart';
import '../models/food_item.dart';
import '../models/review.dart';

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
  final _replyController = TextEditingController();
  int _currentRating = 0;
  String? _userName;
  String? _userEmail;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final user = AuthService().currentUser;
    if (user != null) {
      _userEmail = user.email;
      final doc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      if (doc.exists && doc.data() != null) {
        final data = doc.data()!;
        if (mounted) {
          setState(() {
            _userName = data['name'];
          });
        }
      }
    }
  }

  bool get _isAdmin => _userEmail == 'parisbrestulydala@food.com';

  @override
  void dispose() {
    _tabController.dispose();
    _reviewController.dispose();
    _replyController.dispose();
    super.dispose();
  }

  void _submitReview() {
    if (_reviewController.text.isNotEmpty && _currentRating > 0 && _userName != null) {
      FirebaseFirestore.instance
          .collection('reviews')
          .doc(widget.item.name)
          .collection('item_reviews')
          .add({
        'author': _userName,
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

  void _submitReply(String reviewId) {
    if (_replyController.text.isNotEmpty) {
      FirebaseFirestore.instance
          .collection('reviews')
          .doc(widget.item.name)
          .collection('item_reviews')
          .doc(reviewId)
          .update({
        'reply': _replyController.text,
      });
      _replyController.clear();
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    const Color mainBrown = Color(0xFF79573C);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 280,
            pinned: true,
            backgroundColor: const Color(0xFFF8F9FA),
            elevation: 0,
            leading: Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircleAvatar(
                backgroundColor: Colors.white,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, color: mainBrown),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Hero(
                tag: widget.item.name,
                child: Container(
                  padding: const EdgeInsets.fromLTRB(40, 80, 40, 40),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(24),
                      child: Image.asset(
                        widget.item.imagePath,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              decoration: const BoxDecoration(color: Colors.white),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            widget.item.name,
                            style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Text(
                          "${widget.item.price} KZT",
                          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: mainBrown),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    const Divider(),
                    const SizedBox(height: 16),
                    TabBar(
                      controller: _tabController,
                      labelColor: mainBrown,
                      unselectedLabelColor: Colors.grey,
                      indicatorColor: mainBrown,
                      tabs: const [
                        Tab(child: Text("Ingredients", style: TextStyle(fontWeight: FontWeight.bold))),
                        Tab(child: Text("Ratings", style: TextStyle(fontWeight: FontWeight.bold))),
                      ],
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      height: 400, // Increased height for replies
                      child: TabBarView(
                        controller: _tabController,
                        children: [
                          _buildIngredientsList(),
                          _buildReviewsSection(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: _isAdmin ? null : _buildAddToCartBar(context, mainBrown),
    );
  }

  Widget _buildIngredientsList() {
    return ListView.builder(
      padding: EdgeInsets.zero,
      itemCount: widget.item.ingredients.length,
      itemBuilder: (context, index) {
        return _buildIngredientItem(widget.item.ingredients[index]);
      },
    );
  }

  Widget _buildReviewsSection() {
    return Column(
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
              if (snapshot.hasError) return const Text('Something went wrong');
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              
              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return const Center(child: Text("No reviews yet. Be the first!", style: TextStyle(color: Colors.grey)));
              }

              return ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  final doc = snapshot.data!.docs[index];
                  final reviewData = doc.data() as Map<String, dynamic>;
                  final review = Review.fromMap(reviewData);
                  
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: const CircleAvatar(
                          backgroundImage: AssetImage("assets/profile.jpg"),
                        ),
                        title: Text(review.author, style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text(review.text),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: List.generate(5, (starIndex) => Icon(
                            starIndex < review.rating ? Icons.star : Icons.star_border,
                            color: Colors.amber,
                            size: 16,
                          )),
                        ),
                      ),
                      if (review.reply != null)
                        Padding(
                          padding: const EdgeInsets.only(left: 48, bottom: 8),
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Icon(Icons.reply, size: 16, color: Colors.grey),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text("Admin Reply", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                                      const SizedBox(height: 4),
                                      Text(review.reply!, style: const TextStyle(fontSize: 14)),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      if (_isAdmin && review.reply == null)
                        Padding(
                          padding: const EdgeInsets.only(left: 48),
                          child: TextButton(
                            onPressed: () => _showReplyDialog(doc.id),
                            child: const Text("Reply"),
                          ),
                        ),
                      const Divider(),
                    ],
                  );
                },
              );
            },
          ),
        ),
        if (!_isAdmin) _buildReviewInputField(),
      ],
    );
  }

  void _showReplyDialog(String reviewId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Reply to Review"),
        content: TextField(
          controller: _replyController,
          decoration: const InputDecoration(hintText: "Enter your reply..."),
          maxLines: 3,
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          ElevatedButton(
            onPressed: () => _submitReply(reviewId),
            child: const Text("Submit"),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewInputField() {
    return Column(
      children: [
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(5, (index) => IconButton(
            icon: Icon(index < _currentRating ? Icons.star : Icons.star_border, color: Colors.amber),
            onPressed: () => setState(() => _currentRating = index + 1),
          )),
        ),
        TextFormField(
          controller: _reviewController,
          decoration: InputDecoration(
            hintText: 'Write a review...',
            suffixIcon: IconButton(
              icon: const Icon(Icons.send, color: Color(0xFF79573C)),
              onPressed: _submitReview,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildIngredientItem(String text) {
    const Color mainBrown = Color(0xFF79573C);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(Icons.check_circle_outline, color: mainBrown.withOpacity(0.7), size: 20),
          const SizedBox(width: 12),
          Expanded(child: Text(text, style: TextStyle(fontSize: 16, color: Colors.grey[800]))),
        ],
      ),
    );
  }

  Widget _buildAddToCartBar(BuildContext context, Color mainBrown) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 20, offset: const Offset(0, -5))],
      ),
      child: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ListenableBuilder(
              listenable: cartManager,
              builder: (context, _) {
                final quantity = cartManager.getQuantity(widget.item.name);
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove, color: Colors.black87),
                        onPressed: () => cartManager.removeItem(widget.item.name),
                      ),
                      Text(
                        '$quantity',
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      IconButton(
                        icon: Icon(Icons.add, color: mainBrown),
                        onPressed: () => cartManager.addItem(widget.item.name, widget.item.imagePath, widget.item.price),
                      ),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () {
                  cartManager.addItem(widget.item.name, widget.item.imagePath, widget.item.price);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('${widget.item.name} added to cart!'),
                      backgroundColor: mainBrown,
                      duration: const Duration(seconds: 1),
                    ),
                  );
                },
                icon: const Icon(Icons.shopping_bag_outlined),
                label: const Text("Add to Cart"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
