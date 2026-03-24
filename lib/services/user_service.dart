import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../models/user_profile.dart';

class UserProfileService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // Get user profile stream - Improved with fallback for missing documents
  Stream<UserProfile> getUserProfileStream(String userId) {
    return _firestore.collection('users').doc(userId).snapshots().map((snapshot) {
      if (snapshot.exists && snapshot.data() != null) {
        return UserProfile.fromMap(snapshot.data()!);
      } else {
        // Return a default profile if not found in Firestore yet
        return UserProfile(
          name: "Guest User",
          phone: "",
          avatarUrl: 'assets/profile.jpg',
          purchases: 0,
          loyaltyPoints: 0,
          rank: "Bronze",
          role: "user",
          recentActivity: [],
        );
      }
    });
  }

  // Create or update user profile data
  Future<void> createUserProfile(String userId, String email, {String role = 'user'}) async {
    Map<String, dynamic> userProfileData = {
      'name': email.split('@')[0], 
      'phone': '',
      'avatarUrl': 'assets/profile.jpg',
      'purchases': 0,
      'loyaltyPoints': 0,
      'rank': 'Bronze',
      'role': role,
      'recentActivity': [],
    };
    await _firestore.collection('users').doc(userId).set(userProfileData, SetOptions(merge: true));
  }

  Future<void> placeOrder({
    required String userId,
    required String userName,
    required List<Map<String, dynamic>> items,
    required int totalPrice,
    required String address,
    required String paymentMethod,
  }) async {
    try {
      await _firestore.collection('orders').add({
        'userId': userId,
        'customerName': userName,
        'items': items,
        'totalPrice': totalPrice,
        'address': address,
        'paymentMethod': paymentMethod,
        'timestamp': FieldValue.serverTimestamp(),
        'status': 'Pending',
      });

      final activityItem = {
        'icon': 'fastfood',
        'title': items.length > 1 ? '${items[0]['name']} & more' : items[0]['name'],
        'subtitle': '-$totalPrice ₸',
        'time': 'Just now',
      };

      await _firestore.collection('users').doc(userId).update({
        'recentActivity': FieldValue.arrayUnion([activityItem]),
        'purchases': FieldValue.increment(totalPrice),
        'loyaltyPoints': FieldValue.increment((totalPrice / 100).floor()),
      });
    } catch (e) {
      print("Error placing order: $e");
      rethrow;
    }
  }

  Future<String> uploadAvatar(String userId, File imageFile) async {
    try {
      final ref = _storage.ref().child('user_avatars').child('$userId.jpg');
      final uploadTask = await ref.putFile(imageFile);
      final downloadUrl = await uploadTask.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      print("Error uploading avatar: $e");
      rethrow;
    }
  }

  Future<void> updateUserProfile(String userId, Map<String, dynamic> data) async {
    try {
      await _firestore.collection('users').doc(userId).update(data);
    } catch (e) {
      print("Error updating profile: $e");
      rethrow;
    }
  }
}
