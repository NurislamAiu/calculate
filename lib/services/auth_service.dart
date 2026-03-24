import 'package:example/services/user_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final UserProfileService _userProfileService = UserProfileService();

  // Stream for auth state changes
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Get current user
  User? get currentUser => _auth.currentUser;

  // Sign in with email and password
  Future<UserCredential> signInWithEmail(String email, String password) async {
    try {
      return await _auth.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      print("Error signing in: ${e.message}");
      rethrow;
    }
  }

  // Register with email and password, optionally with a role
  Future<UserCredential> registerWithEmail(String email, String password, {String role = 'user'}) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Create a user profile with the given role
      if (userCredential.user != null) {
        await _userProfileService.createUserProfile(userCredential.user!.uid, email, role: role);
      }

      return userCredential;
    } on FirebaseAuthException catch (e) {
      print("Error registering: ${e.message}");
      rethrow;
    }
  }

  // Sign out
  Future<void> signOut() async {
    await _auth.signOut();
  }
}
