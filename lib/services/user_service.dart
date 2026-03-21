import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../models/user_profile.dart';

class UserProfileService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // Get user profile stream
  Stream<UserProfile> getUserProfileStream(String userId) {
    return _firestore.collection('users').doc(userId).snapshots().map((snapshot) {
      if (snapshot.exists && snapshot.data() != null) {
        return UserProfile.fromMap(snapshot.data()!);
      } else {
        throw Exception("User profile not found");
      }
    });
  }

  // Create or update user profile data
  Future<void> createUserProfile(String userId, String email) async {
    Map<String, dynamic> userProfileData = {
      'name': email.split('@')[0], 
      'phone': '',
      'avatarUrl': 'assets/profile.png',
      'purchases': 0,
      'loyaltyPoints': 0,
      'rank': 'Bronze',
      'recentActivity': [],
    };
    await _firestore.collection('users').doc(userId).set(userProfileData);
  }

  // Upload avatar to Firebase Storage
  Future<String> uploadAvatar(String userId, File imageFile) async {
    try {
      // Create a reference to the location you want to upload to in firebase storage
      final ref = _storage.ref().child('user_avatars').child('$userId.jpg');
      
      // Upload the file
      final uploadTask = await ref.putFile(imageFile);
      
      // Get the download URL
      final downloadUrl = await uploadTask.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      print("Error uploading avatar: $e");
      rethrow;
    }
  }

  // Update user profile fields (name, phone, avatarUrl)
  Future<void> updateUserProfile(String userId, Map<String, dynamic> data) async {
    try {
      await _firestore.collection('users').doc(userId).update(data);
    } catch (e) {
      print("Error updating profile: $e");
      rethrow;
    }
  }
}
