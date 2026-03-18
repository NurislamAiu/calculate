import 'package:flutter/material.dart';
import 'cart_manager.dart';

class SushiPage extends StatefulWidget {
  const SushiPage({super.key});

  @override
  State<SushiPage> createState() => _SushiPageState();
}

class _SushiPageState extends State<SushiPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          "Sushi Details",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
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
                      tag: "assets/sushi.png",
                      child: Image.asset("assets/sushi.png", fit: BoxFit.contain),
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
                            "Sushi",
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
                              "10 000 KZT",
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
                                _buildIngredientItem("Fresh Salmon"),
                                _buildIngredientItem("Sushi Rice"),
                                _buildIngredientItem("Nori Seaweed"),
                                _buildIngredientItem("Avocado"),
                                _buildIngredientItem("Cucumber"),
                                _buildIngredientItem("Soy Sauce"),
                                _buildIngredientItem("Wasabi & Ginger"),
                              ],
                            ),
                            // Description Tab Content
                            ListView(
                              children: [
                                ListTile(
                                  leading: ClipOval(
                                    child: Image.asset(
                                      "assets/profile.png",
                                      width: 50,
                                      height: 50,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  title: const Text("Squidward Tentacles"),
                                  subtitle: const Text(
                                    "I GOT FOOD POISONING FROM THIS",
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  trailing: const Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.star,
                                        color: Colors.amber,
                                        size: 16,
                                      ),
                                      Icon(
                                        Icons.star_border_outlined,
                                        color: Colors.amber,
                                        size: 16,
                                      ),
                                      Icon(
                                        Icons.star_border_outlined,
                                        color: Colors.amber,
                                        size: 16,
                                      ),
                                      Icon(
                                        Icons.star_border_outlined,
                                        color: Colors.amber,
                                        size: 16,
                                      ),
                                      Icon(
                                        Icons.star_border_outlined,
                                        color: Colors.amber,
                                        size: 16,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 80), // padding for floating cart
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 20,
            right: 20,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(20),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  )
                ],
              ),
              child: ListenableBuilder(
                listenable: cartManager,
                builder: (context, _) {
                  final quantity = cartManager.getQuantity("Sushi");
                  return Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          cartManager.removeItem("Sushi");
                        },
                        icon: const Icon(Icons.remove, color: Colors.white),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        '$quantity',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 12),
                      IconButton(
                        onPressed: () {
                          cartManager.addItem("Sushi", "assets/sushi.png", 10000);
                        },
                        icon: const Icon(Icons.add, color: Colors.white),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
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
