import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:example/cart_manager.dart';
import 'package:example/profile_page.dart';
import 'package:example/screens/item_detail_page.dart';
import 'package:flutter/material.dart';

import 'cart_page.dart';
import 'models/food_item.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          "Menu",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
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
                  icon: const Icon(Icons.shopping_cart_outlined),
                ),
              );
            },
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfilePage()),
              );
            },
            icon: ClipOval(child: Image.asset("assets/profile.png")),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          children: [
            const SizedBox(height: 10),
            const Text(
              "Choose your favorite meal",
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 30),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection('foods').snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return const Center(child: Text('Something went wrong'));
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(child: Text('No food items found.'));
                  }

                  final foodDocs = snapshot.data!.docs;

                  return ListView.separated(
                    physics: const BouncingScrollPhysics(),
                    itemCount: foodDocs.length,
                    separatorBuilder: (context, index) => const SizedBox(height: 20),
                    itemBuilder: (context, index) {
                      final doc = foodDocs[index];
                      final item = FoodItem.fromMap(doc.data() as Map<String, dynamic>);
                      final color = _getColorForIndex(index);
                      return FoodMenuCard(item: item, color: color);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getColorForIndex(int index) {
    const colors = [
      Color(0xFFFFF3E0), // orange[50]
      Color(0xFFFFEBEE), // red[50]
      Color(0xFFE3F2FD), // blue[50]
    ];
    return colors[index % colors.length];
  }
}

class FoodMenuCard extends StatelessWidget {
  final FoodItem item;
  final Color color;

  const FoodMenuCard({
    super.key,
    required this.item,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ItemDetailPage(item: item),
          ),
        );
      },
      child: Container(
        height: 160,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: Stack(
            children: [
              Positioned(
                right: -20,
                bottom: -20,
                child: Container(
                  height: 120,
                  width: 120,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            item.name,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Text(
                                "View Details",
                                style: TextStyle(
                                  color: Colors.orange[800],
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const Icon(
                                Icons.chevron_right,
                                color: Colors.orange,
                                size: 20,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Hero(
                      tag: item.imagePath,
                      child: Image.asset(
                        item.imagePath,
                        height: 100,
                        width: 100,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
