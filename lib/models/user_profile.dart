/// Модель для одного элемента в списке "Recent Activity".
class ActivityItem {
  final String icon; // В Firebase здесь можно хранить название иконки, например "coffee"
  final String title;
  final String subtitle;
  final String time;

  ActivityItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.time,
  });

  // ЗАГОТОВКА ДЛЯ FIREBASE
  /*
  factory ActivityItem.fromMap(Map<String, dynamic> map) {
    return ActivityItem(
      icon: map['icon'] ?? 'fastfood',
      title: map['title'] ?? 'No Title',
      subtitle: map['subtitle'] ?? '',
      time: map['time'] ?? '',
    );
  }
  */
}

/// Модель для данных профиля пользователя.
class UserProfile {
  final String name;
  final String phone;
  final String avatarUrl; // Путь к аватару
  final int purchases;
  final int loyaltyPoints;
  final String rank;
  final List<ActivityItem> recentActivity;

  UserProfile({
    required this.name,
    required this.phone,
    required this.avatarUrl,
    required this.purchases,
    required this.loyaltyPoints,
    required this.rank,
    required this.recentActivity,
  });

  // ЗАГОТОВКА ДЛЯ FIREBASE
  /*
  factory UserProfile.fromFirestore(Map<String, dynamic> firestoreData) {
    final activityList = firestoreData['recentActivity'] as List<dynamic>?;
    final activities = activityList != null
        ? activityList.map((activityData) => ActivityItem.fromMap(activityData)).toList()
        : <ActivityItem>[];

    return UserProfile(
      name: firestoreData['name'] ?? 'No Name',
      phone: firestoreData['phone'] ?? '',
      avatarUrl: firestoreData['avatarUrl'] ?? 'assets/profile.png', // URL или путь
      purchases: firestoreData['purchases'] ?? 0,
      loyaltyPoints: firestoreData['loyaltyPoints'] ?? 0,
      rank: firestoreData['rank'] ?? 'Bronze',
      recentActivity: activities,
    );
  }
  */
}
