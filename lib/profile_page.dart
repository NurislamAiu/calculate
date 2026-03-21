import 'package:example/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'models/user_profile.dart';
import 'services/user_service.dart';

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
          return Scaffold(body: Center(child: Text("Error: ${snapshot.error}")));
        }
        if (snapshot.hasData) {
          return _buildProfileScaffold(context, snapshot.data!);
        }
        return const Scaffold(body: Center(child: Text("No user data.")));
      },
    );
  }

  Widget _buildProfileScaffold(BuildContext context, UserProfile user) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
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
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              _authService.signOut();
              // Pop until we are at the root, so the AuthGate can take over
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
            icon: Container(
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                color: Colors.white.withOpacity(0.15),
              ),
              child: const Icon(Icons.logout, color: Colors.white),
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
            const SizedBox(height: 70),
            _buildRecentActivitySection(user.recentActivity),
          ],
        ),
      ),
    );
  }

  // ... (All other _build methods remain the same)
  Widget _buildHeader({required double height}) {
    return Container(
      height: height,
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF473230), Color(0xAE473230)],
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
              backgroundImage: AssetImage(user.avatarUrl),
              backgroundColor: Colors.grey,
            ),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          user.name,
          style: const TextStyle(
            fontSize: 24,
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
            user.phone,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.white,
              fontWeight: FontWeight.w500,
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
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildStatColumn("Purchases", (user.purchases / 1000).toStringAsFixed(0) + "K", "₸"),
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
    'coffee': const Color(0xFFF59E0B),
    'local_pizza': const Color(0xFF10B981),
    'set_meal': const Color(0xFF3B82F6),
    'fastfood': const Color(0xFFEF4444),
  };

  Widget _buildModernActivityItem(ActivityItem item) {
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
              color: (_colorMap[item.icon] ?? Colors.grey).withOpacity(0.12),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(_iconMap[item.icon] ?? Icons.help, color: _colorMap[item.icon] ?? Colors.grey, size: 28),
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
