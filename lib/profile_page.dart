import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA), // Very light grey background
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios, color: Colors.white),
        ),
        title: const Text(
          'Profile',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {},
            icon: Container(
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                color: Colors.grey,
              ),
              child: Icon(Icons.settings_outlined, color: Colors.white),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.topCenter,
              children: [
                // Top Gradient Background
                Container(
                  height: 320,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF473230), Color(0xAE473230)],
                      // Indigo to Purple
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(40),
                      bottomRight: Radius.circular(40),
                    ),
                  ),
                ),
                // Profile Info
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Double-ringed Avatar
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            shape: BoxShape.circle,
                          ),
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            child: const CircleAvatar(
                              radius: 50,
                              backgroundImage: AssetImage('assets/profile.png'),
                              backgroundColor: Colors.grey,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          "Squidward Tentacles",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(height: 8),
                        // Phone number pill
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Text(
                            "+7 702 594 66 51",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Floating Stats Card
                Positioned(
                  bottom: -40,
                  left: 20,
                  right: 20,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildStatColumn("Purchases", "10K", "₸"),
                        Container(
                          height: 40,
                          width: 1,
                          color: Colors.grey[200],
                        ),
                        _buildStatColumn("Loyalty", "750", "Pts"),
                        Container(
                          height: 40,
                          width: 1,
                          color: Colors.grey[200],
                        ),
                        _buildStatColumn("Rank", "Gold", ""),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 70), // Spacing for floating card
            // Recent Activity Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Recent Activity",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1F2937),
                        ),
                      ),
                      TextButton(
                        onPressed: () {},
                        style: TextButton.styleFrom(
                          foregroundColor: const Color(0xFF4F46E5),
                          padding: EdgeInsets.zero,
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: const Text(
                          "See All",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildModernActivityItem(
                    icon: Icons.coffee_rounded,
                    color: const Color(0xFFF59E0B),
                    // Amber
                    title: 'Americano',
                    subtitle: '-1,200 ₸',
                    time: 'Today, 09:41 AM',
                  ),
                  _buildModernActivityItem(
                    icon: Icons.local_pizza_rounded,
                    color: const Color(0xFF10B981),
                    // Emerald
                    title: 'Pepperoni Pizza',
                    subtitle: '-3,500 ₸',
                    time: 'Yesterday, 19:20 PM',
                  ),
                  _buildModernActivityItem(
                    icon: Icons.set_meal_rounded,
                    color: const Color(0xFF3B82F6),
                    // Blue
                    title: 'Sushi Set',
                    subtitle: '-8,000 ₸',
                    time: 'Oct 12, 14:00 PM',
                  ),
                  _buildModernActivityItem(
                    icon: Icons.fastfood_rounded,
                    color: const Color(0xFFEF4444),
                    // Red
                    title: 'Burger Combo',
                    subtitle: '-2,500 ₸',
                    time: 'Oct 10, 13:15 PM',
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatColumn(String label, String value, String unit) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFF6B7280),
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 22,
                color: Color(0xFF111827),
              ),
            ),
            if (unit.isNotEmpty) const SizedBox(width: 4),
            if (unit.isNotEmpty)
              Text(
                unit,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  color: Color(0xFF6B7280),
                ),
              ),
          ],
        ),
      ],
    );
  }

  Widget _buildModernActivityItem({
    required IconData icon,
    required Color color,
    required String title,
    required String subtitle,
    required String time,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Color(0xFF1F2937),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  time,
                  style: const TextStyle(
                    color: Color(0xFF9CA3AF),
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          Text(
            subtitle,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Color(0xFF111827),
            ),
          ),
        ],
      ),
    );
  }
}
