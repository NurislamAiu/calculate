import 'package:flutter/material.dart';

class BurgerPage extends StatefulWidget {
  const BurgerPage({super.key});

  @override
  State<BurgerPage> createState() => _BurgerPageState();
}

class _BurgerPageState extends State<BurgerPage>
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
          "Burger Details",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
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
                  child: Image.asset("assets/burger.png", fit: BoxFit.contain),
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
                              subtitle: const Text("I HATE THIS BURGER",
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,),
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
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ],
        ),
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
