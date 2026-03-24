import 'package:example/services/auth_service.dart';
import 'package:example/screens/edit_profile_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../models/user_profile.dart';
import '../services/user_service.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final UserProfileService _userService = UserProfileService();
  final AuthService _authService = AuthService();
  final User? currentUser = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    if (currentUser == null) {
      return const Scaffold(
        body: Center(
          child: Text("Not logged in."),
        ),
      );
    }
    return StreamBuilder<UserProfile>(
      stream: _userService.getUserProfileStream(currentUser!.uid),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }
        if (snapshot.hasError) {
          return Scaffold(
            appBar: AppBar(title: const Text("Profile")),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  Text("Profile Error: ${snapshot.error}"),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () => _authService.signOut().then((_) => Navigator.pop(context)),
                    child: const Text("Sign Out"),
                  )
                ],
              ),
            ),
          );
        }
        if (snapshot.hasData) {
          if (currentUser?.email == 'parisbrestulydala@food.com') {
            return _buildAdminDashboard(context, snapshot.data!);
          }
          return _buildProfileScaffold(context, snapshot.data!);
        }
        return const Scaffold(body: Center(child: Text("No user data available.")));
      },
    );
  }

  Widget _buildAdminDashboard(BuildContext context, UserProfile user) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          "Admin Dashboard",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            onPressed: () => _authService.signOut().then((_) => Navigator.pop(context)),
            icon: const Icon(Icons.logout, color: Colors.black),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Welcome back, ${user.name}",
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              "Here is what's happening today",
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(child: _buildAdminStatCard("Revenue", "₸1.2M", Icons.payments, Colors.green)),
                const SizedBox(width: 16),
                Expanded(child: _buildAdminStatCard("Orders", "1,240", Icons.shopping_bag, Colors.blue)),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(child: _buildAdminStatCard("Users", "45.2K", Icons.people, Colors.orange)),
                const SizedBox(width: 16),
                Expanded(child: _buildAdminStatCard("Growth", "+12%", Icons.trending_up, Colors.purple)),
              ],
            ),
            const SizedBox(height: 32),
            const Text(
              "Management Tools",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildAdminMenuTile("Inventory Management", Icons.inventory_2, "Track and update stocks"),
            _buildAdminMenuTile("Order Processing", Icons.local_shipping, "Review and fulfill orders"),
            _buildAdminMenuTile("Customer Support", Icons.support_agent, "Handle user inquiries"),
            _buildAdminMenuTile("Analytics Reports", Icons.bar_chart, "Detailed business insights"),
            const SizedBox(height: 20),
            Center(
              child: OutlinedButton(
                onPressed: () {
                   Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditProfilePage(userProfile: user),
                    ),
                  );
                },
                child: const Text("Edit Admin Profile"),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildAdminStatCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 30),
          const SizedBox(height: 12),
          Text(title, style: const TextStyle(color: Colors.grey, fontSize: 14)),
          const SizedBox(height: 4),
          Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildAdminMenuTile(String title, IconData icon, String subtitle) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 0,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: const Color(0xFF79573C).withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(Icons.settings, color: Color(0xFF79573C)),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle, style: const TextStyle(fontSize: 12)),
        trailing: const Icon(Icons.chevron_right),
        onTap: () {},
      ),
    );
  }

  Widget _buildProfileScaffold(BuildContext context, UserProfile user) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
        ),
        title: const Text(
          'Profile',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditProfilePage(userProfile: user),
                ),
              );
            },
            icon: Container(
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                color: Colors.white.withOpacity(0.2),
              ),
              child: const Icon(Icons.edit, color: Colors.white, size: 20),
            ),
          ),
          IconButton(
            onPressed: () {
              _authService.signOut();
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
            icon: Container(
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                color: Colors.white.withOpacity(0.2),
              ),
              child: const Icon(Icons.logout, color: Colors.white, size: 20),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.topCenter,
              children: [
                _buildHeader(height: 380),
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 0.0),
                    child: _buildProfileInfo(user),
                  ),
                ),
                Positioned(
                  bottom: -80,
                  left: 20,
                  right: 20,
                  child: _buildStatsCard(user),
                ),
              ],
            ),
            const SizedBox(height: 100),
            _buildRecentActivitySection(user.recentActivity),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader({required double height}) {
    return Container(
      height: height,
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF79573C), Color(0xFFA1887F)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(40),
          bottomRight: Radius.circular(40),
        ),
      ),
    );
  }

  Widget _buildProfileInfo(UserProfile user) {
    ImageProvider avatarImage;
    if (user.avatarUrl.startsWith('http')) {
      avatarImage = NetworkImage(user.avatarUrl);
    } else {
      avatarImage = AssetImage(user.avatarUrl.isNotEmpty ? user.avatarUrl : 'assets/profile.png');
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
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
            child: CircleAvatar(
              radius: 50,
              backgroundImage: avatarImage,
              backgroundColor: Colors.grey[200],
            ),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          user.name,
          style: const TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            user.phone.isEmpty ? "No phone" : user.phone,
            style: const TextStyle(
              fontSize: 15,
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatsCard(UserProfile user) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24),
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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildStatColumn("Purchases", "${(user.purchases / 1000).toStringAsFixed(0)}K", "₸"),
          Container(height: 40, width: 1, color: Colors.grey[200]),
          _buildStatColumn("Loyalty", user.loyaltyPoints.toString(), "Pts"),
          Container(height: 40, width: 1, color: Colors.grey[200]),
          _buildStatColumn("Rank", user.rank, ""),
        ],
      ),
    );
  }

  Widget _buildRecentActivitySection(List<ActivityItem> activities) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Recent Activity",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF1F2937)),
              ),
              TextButton(
                onPressed: () {},
                child: const Text("See All", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (activities.isEmpty)
            const Center(child: Text("No recent activity", style: TextStyle(color: Colors.grey))),
          ...activities.map((item) => _buildModernActivityItem(item)).toList(),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildStatColumn(String label, String value, String unit) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(label, style: const TextStyle(color: Color(0xFF6B7280), fontSize: 13, fontWeight: FontWeight.w500)),
        const SizedBox(height: 8),
        Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 22, color: Color(0xFF111827))),
            if (unit.isNotEmpty) const SizedBox(width: 4),
            if (unit.isNotEmpty) Text(unit, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: Color(0xFF6B7280))),
          ],
        ),
      ],
    );
  }

  final Map<String, IconData> _iconMap = {
    'coffee': Icons.coffee_rounded,
    'local_pizza': Icons.local_pizza_rounded,
    'set_meal': Icons.set_meal_rounded,
    'fastfood': Icons.fastfood_rounded,
  };

  final Map<String, Color> _colorMap = {
    'coffee': const Color(0xFF79573C), 
    'local_pizza': const Color(0xFF10B981),
    'set_meal': const Color(0xFF3B82F6),
    'fastfood': const Color(0xFFEF4444),
  };

  Widget _buildModernActivityItem(ActivityItem item) {
    const Color mainBrown = Color(0xFF79573C);
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: (_colorMap[item.icon] ?? mainBrown).withOpacity(0.12),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(_iconMap[item.icon] ?? Icons.fastfood, color: _colorMap[item.icon] ?? mainBrown, size: 28),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF1F2937))),
                const SizedBox(height: 6),
                Text(item.time, style: const TextStyle(color: Color(0xFF9CA3AF), fontSize: 13, fontWeight: FontWeight.w500)),
              ],
            ),
          ),
          Text(item.subtitle, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF111827))),
        ],
      ),
    );
  }
}
