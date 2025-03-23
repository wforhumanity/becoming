import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import '../models/user_model.dart';
import 'auth_service_interface.dart';

/// Implementation of the AuthServiceInterface using Firebase Authentication
class FirebaseAuthService implements AuthServiceInterface {
  final firebase_auth.FirebaseAuth _firebaseAuth;
  
  /// Constructor
  FirebaseAuthService({firebase_auth.FirebaseAuth? firebaseAuth})
      : _firebaseAuth = firebaseAuth ?? firebase_auth.FirebaseAuth.instance;
  
  @override
  User? get currentUser {
    final firebaseUser = _firebaseAuth.currentUser;
    if (firebaseUser == null) {
      return null;
    }
    return User.fromFirebase(firebaseUser);
  }
  
  @override
  Stream<User?> get authStateChanges {
    return _firebaseAuth.authStateChanges().map((firebaseUser) {
      if (firebaseUser == null) {
        return null;
      }
      return User.fromFirebase(firebaseUser);
    });
  }
  
  @override
  Future<User> signInWithEmailAndPassword(String email, String password) async {
    try {
      final result = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      if (result.user == null) {
        throw Exception('Failed to sign in: No user returned');
      }
      
      return User.fromFirebase(result.user!);
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw _handleFirebaseAuthException(e);
    }
  }
  
  @override
  Future<User> createUserWithEmailAndPassword(String email, String password) async {
    try {
      final result = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      if (result.user == null) {
        throw Exception('Failed to create user: No user returned');
      }
      
      return User.fromFirebase(result.user!);
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw _handleFirebaseAuthException(e);
    }
  }
  
  @override
  Future<User> signInWithApple() async {
    try {
      // Get Apple sign in credentials
      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );
      
      // Create OAuthCredential
      final oauthCredential = firebase_auth.OAuthProvider('apple.com').credential(
        idToken: appleCredential.identityToken,
        accessToken: appleCredential.authorizationCode,
      );
      
      // Sign in with credential
      final result = await _firebaseAuth.signInWithCredential(oauthCredential);
      
      if (result.user == null) {
        throw Exception('Failed to sign in with Apple: No user returned');
      }
      
      // Update user profile with name from Apple if available
      if (appleCredential.givenName != null && result.user != null) {
        final displayName = '${appleCredential.givenName} ${appleCredential.familyName ?? ''}';
        await result.user!.updateDisplayName(displayName.trim());
      }
      
      return User.fromFirebase(result.user!);
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw _handleFirebaseAuthException(e);
    } catch (e) {
      throw Exception('Failed to sign in with Apple: $e');
    }
  }
  
  @override
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }
  
  @override
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw _handleFirebaseAuthException(e);
    }
  }
  
  @override
  Future<User> updateProfile({String? displayName, String? photoUrl}) async {
    try {
      final user = _firebaseAuth.currentUser;
      
      if (user == null) {
        throw Exception('No user signed in');
      }
      
      await user.updateDisplayName(displayName);
      await user.updatePhotoURL(photoUrl);
      
      // Reload user to get updated data
      await user.reload();
      
      return User.fromFirebase(_firebaseAuth.currentUser!);
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw _handleFirebaseAuthException(e);
    }
  }
  
  @override
  Future<void> deleteAccount() async {
    try {
      final user = _firebaseAuth.currentUser;
      
      if (user == null) {
        throw Exception('No user signed in');
      }
      
      await user.delete();
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw _handleFirebaseAuthException(e);
    }
  }
  
  /// Handle Firebase Auth exceptions and convert them to user-friendly messages
  Exception _handleFirebaseAuthException(firebase_auth.FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return Exception('No user found with this email');
      case 'wrong-password':
        return Exception('Incorrect password');
      case 'email-already-in-use':
        return Exception('Email is already in use');
      case 'weak-password':
        return Exception('Password is too weak');
      case 'invalid-email':
        return Exception('Invalid email address');
      case 'user-disabled':
        return Exception('This account has been disabled');
      case 'requires-recent-login':
        return Exception('Please sign in again to complete this action');
      default:
        return Exception('Authentication error: ${e.message}');
    }
  }
}
