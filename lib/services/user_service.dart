// ЗАГОТОВКА ДЛЯ FIREBASE: Раскомментируйте
// import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_profile.dart';

class UserProfileService {
  /// Имитирует загрузку профиля текущего пользователя.
  /// В реальности здесь будет запрос к Firebase для получения данных
  /// залогиненного пользователя.
  Future<UserProfile> getUserProfile() async {
    // Имитация сетевой задержки
    await Future.delayed(const Duration(seconds: 1));

    // Возвращаем статичные данные
    return UserProfile(
      name: "Squidward Tentacles",
      phone: "+7 702 594 66 51",
      avatarUrl: 'assets/profile.png',
      purchases: 10000,
      loyaltyPoints: 750,
      rank: "Gold",
      recentActivity: [
        ActivityItem(icon: 'coffee', title: 'Americano', subtitle: '-1,200 ₸', time: 'Today, 09:41 AM'),
        ActivityItem(icon: 'local_pizza', title: 'Pepperoni Pizza', subtitle: '-3,500 ₸', time: 'Yesterday, 19:20 PM'),
        ActivityItem(icon: 'set_meal', title: 'Sushi Set', subtitle: '-8,000 ₸', time: 'Oct 12, 14:00 PM'),
        ActivityItem(icon: 'fastfood', title: 'Burger Combo', subtitle: '-2,500 ₸', time: 'Oct 10, 13:15 PM'),
      ],
    );
  }

  // ЗАГОТОВКА ДЛЯ FIREBASE
  /*
  Future<UserProfile> getUserProfileFromFirebase(String userId) async {
    try {
      final docSnapshot = await FirebaseFirestore.instance
          .collection('users') // Ваша коллекция пользователей
          .doc(userId) // ID текущего пользователя
          .get();

      if (docSnapshot.exists && docSnapshot.data() != null) {
        return UserProfile.fromFirestore(docSnapshot.data()!);
      } else {
        throw Exception("User profile not found");
      }
    } catch (e) {
      print("Error fetching user profile: $e");
      rethrow;
    }
  }
  */
}
