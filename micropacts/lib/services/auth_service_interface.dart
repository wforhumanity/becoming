import '../models/user_model.dart';

/// Interface for the Authentication Service
abstract class AuthServiceInterface {
  /// Get the current user
  User? get currentUser;
  
  /// Stream of authentication state changes
  Stream<User?> get authStateChanges;
  
  /// Sign in with email and password
  Future<User> signInWithEmailAndPassword(String email, String password);
  
  /// Create a new user with email and password
  Future<User> createUserWithEmailAndPassword(String email, String password);
  
  /// Sign in with Apple
  Future<User> signInWithApple();
  
  /// Sign out
  Future<void> signOut();
  
  /// Send password reset email
  Future<void> sendPasswordResetEmail(String email);
  
  /// Update user profile
  Future<User> updateProfile({String? displayName, String? photoUrl});
  
  /// Delete user account
  Future<void> deleteAccount();
}
