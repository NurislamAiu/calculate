import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:example/cart_manager.dart';
import 'package:example/profile_page.dart';
import 'package:example/screens/item_detail_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'cart_page.dart';
import 'models/food_item.dart';
import 'models/user_profile.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _selectedCategory = 'All';
  String? _avatarUrl; // <-- State variable to hold the avatar URL

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  // --- New method to fetch all user data ---
  Future<void> _loadUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      // Load cart and user profile concurrently
      await Future.wait([
        cartManager.loadCart(user.uid),
        _loadUserProfile(user.uid),
      ]);
    }
  }

  // --- New method to specifically fetch the profile ---
  Future<void> _loadUserProfile(String uid) async {
    try {
      final doc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
      if (doc.exists && doc.data() != null) {
        final userProfile = UserProfile.fromMap(doc.data()!);
        if (mounted) {
          setState(() {
            _avatarUrl = userProfile.avatarUrl;
          });
        }
      }
    } catch (e) {
      print("Error loading user profile on home page: $e");
      // Handle error, maybe set a default avatar
      if (mounted) {
        setState(() {
          _avatarUrl = 'assets/profile.jpg';
        });
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    const Color mainBrown = Color(0xFF79573C);

    // --- Dynamically build the avatar image ---
    ImageProvider avatarImage;
    if (_avatarUrl != null && _avatarUrl!.startsWith('http')) {
      avatarImage = NetworkImage(_avatarUrl!);
    } else {
      avatarImage = const AssetImage('assets/profile.png'); // Default
    }

    return Scaffold(
      appBar: AppBar(
        leadingWidth: 0,
        title: const Text("Menu"),
        actions: [
          ListenableBuilder(
            listenable: cartManager,
            builder: (context, _) {
              return Badge(
                label: Text('${cartManager.totalQuantity}'),
                isLabelVisible: cartManager.totalQuantity > 0,
                child: IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const CartPage()),
                    );
                  },
                  icon: const Icon(Icons.shopping_cart_outlined, size: 28),
                ),
              );
            },
          ),
          Padding(
            padding: const EdgeInsets.only(right: 16.0, left: 8.0),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ProfilePage()),
                );
              },
              // --- Use the dynamic avatarImage here ---
              child: CircleAvatar(
                radius: 20,
                backgroundImage: avatarImage,
                backgroundColor: Colors.grey[200],
              ),
            ),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                const Text(
                  "Find your favorite food",
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 24),
                const TextField(
                  decoration: InputDecoration(
                    hintText: 'Search for food...',
                    prefixIcon: Icon(Icons.search),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
          _buildCategoryChips(),
          const SizedBox(height: 16),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _getFoodStream(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator(color: mainBrown));
                }
                if (snapshot.hasError) {
                  return const Center(child: Text('Something went wrong'));
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text('No food items found for this category.'));
                }

                final foodDocs = snapshot.data!.docs;

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  physics: const BouncingScrollPhysics(),
                  itemCount: foodDocs.length,
                  itemBuilder: (context, index) {
                    final doc = foodDocs[index];
                    final item = FoodItem.fromMap(doc.data() as Map<String, dynamic>);
                    return FoodListCard(item: item);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Stream<QuerySnapshot> _getFoodStream() {
    if (_selectedCategory == 'All') {
      return FirebaseFirestore.instance.collection('foods').snapshots();
    } else {
      return FirebaseFirestore.instance
          .collection('foods')
          .where('category', isEqualTo: _selectedCategory)
          .snapshots();
    }
  }

  Widget _buildCategoryChips() {
    const categories = ['All', 'Pizza', 'Burger', 'Sushi'];
    
    return SizedBox(
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          final bool isSelected = _selectedCategory == category;
          return Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _selectedCategory = category;
                });
              },
              child: Chip(
                label: Text(category),
                labelStyle: TextStyle(
                  color: isSelected ? Colors.white : const Color(0xFF79573C),
                  fontWeight: FontWeight.bold,
                ),
                backgroundColor: isSelected ? const Color(0xFF79573C) : Colors.white,
                side: isSelected ? BorderSide.none : const BorderSide(color: Color(0xFFE0E0E0)),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
            ),
          );
        },
      ),
    );
  }
}

class FoodListCard extends StatelessWidget {
  final FoodItem item;

  const FoodListCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    const Color mainBrown = Color(0xFF79573C);

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ItemDetailPage(item: item)),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Row(
          children: [
            Hero(
              tag: item.imagePath,
              child: Container(
                height: 90,
                width: 90,
                decoration: BoxDecoration(
                  color: mainBrown.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.asset(item.imagePath, fit: BoxFit.contain),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${item.price} KZT',
                    style: const TextStyle(color: mainBrown, fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: () {
                cartManager.addItem(item.name, item.imagePath, item.price);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('${item.name} added to cart!'),
                    duration: const Duration(seconds: 1),
                    backgroundColor: mainBrown,
                  ),
                );
              },
              icon: const Icon(Icons.add_circle, color: mainBrown, size: 32),
            ),
          ],
        ),
      ),
    );
  }
}
