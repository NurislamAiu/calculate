class ActivityItem {
  final String icon;
  final String title;
  final String subtitle;
  final String time;

  ActivityItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.time,
  });

  factory ActivityItem.fromMap(Map<String, dynamic> map) {
    return ActivityItem(
      icon: map['icon'] ?? 'fastfood',
      title: map['title'] ?? 'No Title',
      subtitle: map['subtitle'] ?? '',
      time: map['time'] ?? '',
    );
  }
}

class UserProfile {
  final String name;
  final String phone;
  final String avatarUrl;
  final int purchases;
  final int loyaltyPoints;
  final String rank;
  final String role; // 'user' or 'employee'
  final List<ActivityItem> recentActivity;

  UserProfile({
    required this.name,
    required this.phone,
    required this.avatarUrl,
    required this.purchases,
    required this.loyaltyPoints,
    required this.rank,
    required this.role,
    required this.recentActivity,
  });

  factory UserProfile.fromMap(Map<String, dynamic> data) {
    final activityList = data['recentActivity'] as List<dynamic>?;
    final activities = activityList != null
        ? activityList.map((activityData) => ActivityItem.fromMap(activityData)).toList()
        : <ActivityItem>[];

    return UserProfile(
      name: data['name'] ?? 'No Name',
      phone: data['phone'] ?? '',
      avatarUrl: data['avatarUrl'] ?? 'assets/profile.jpg',
      purchases: data['purchases'] ?? 0,
      loyaltyPoints: data['loyaltyPoints'] ?? 0,
      rank: data['rank'] ?? 'Bronze',
      role: data['role'] ?? 'user',
      recentActivity: activities,
    );
  }
}
