import 'package:example/burger_page.dart';
import 'package:example/pizza_page.dart';
import 'package:example/profile_page.dart';
import 'package:example/sushi_page.dart';
import 'package:flutter/material.dart';

class RowAndColumn extends StatelessWidget {
  const RowAndColumn({super.key});

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
          ///  TODO: PROFILE PAGE FOR USER
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfilePage()),
              );
            },
            icon: Container(
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                color: Colors.grey,
              ),
              child: Icon(Icons.person, size: 26, color: Colors.white),
            ),
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
              child: ListView(
                physics: const BouncingScrollPhysics(),
                children: [
                  _buildMenuCard(
                    context,
                    title: "Pizza",
                    imagePath: "assets/pizza.png",
                    destination: const PizzaPage(),
                    color: Colors.orange[50]!,
                  ),
                  const SizedBox(height: 20),
                  _buildMenuCard(
                    context,
                    title: "Burger",
                    imagePath: "assets/burger.png",
                    destination: const BurgerPage(),
                    color: Colors.red[50]!,
                  ),
                  const SizedBox(height: 20),
                  _buildMenuCard(
                    context,
                    title: "Sushi",
                    imagePath: "assets/sushi.png",
                    destination: const SushiPage(),
                    color: Colors.blue[50]!,
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuCard(
    BuildContext context, {
    required String title,
    required String imagePath,
    required Widget destination,
    required Color color,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => destination),
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
              // Background accent
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
                            title,
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
                      tag: imagePath,
                      child: Image.asset(
                        imagePath,
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
