import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_profile.dart';

class UserProfileService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get user profile stream
  Stream<UserProfile> getUserProfileStream(String userId) {
    return _firestore.collection('users').doc(userId).snapshots().map((snapshot) {
      if (snapshot.exists && snapshot.data() != null) {
        return UserProfile.fromMap(snapshot.data()!);
      } else {
        // You might want to create a default profile here or handle this case in the UI
        throw Exception("User profile not found");
      }
    });
  }

  // Create or update user profile data
  // This can be called after registration
  Future<void> createUserProfile(String userId, String email) async {
    // We use a Map to create the data
    Map<String, dynamic> userProfileData = {
      'name': email.split('@')[0], // A default name from the email
      'phone': '',
      'avatarUrl': 'assets/profile.png',
      'purchases': 0,
      'loyaltyPoints': 0,
      'rank': 'Bronze',
      'recentActivity': [],
    };

    // Use .set() to create the document if it doesn't exist
    await _firestore.collection('users').doc(userId).set(userProfileData);
  }
}
