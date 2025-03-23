import 'dart:async';
import '../models/user_model.dart';
import 'auth_service_interface.dart';

/// Mock implementation of the AuthServiceInterface for testing
class MockAuthService implements AuthServiceInterface {
  User? _currentUser;
  final _authStateController = StreamController<User?>.broadcast();
  
  /// Constructor
  MockAuthService({User? initialUser}) : _currentUser = initialUser {
    _authStateController.add(_currentUser);
  }
  
  @override
  User? get currentUser => _currentUser;
  
  @override
  Stream<User?> get authStateChanges => _authStateController.stream;
  
  @override
  Future<User> signInWithEmailAndPassword(String email, String password) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));
    
    // Simulate authentication
    if (email == 'test@example.com' && password == 'password') {
      final user = User(
        id: '123',
        displayName: 'Test User',
        email: email,
        isEmailVerified: true,
      );
      
      _currentUser = user;
      _authStateController.add(user);
      
      return user;
    } else {
      throw Exception('Invalid email or password');
    }
  }
  
  @override
  Future<User> createUserWithEmailAndPassword(String email, String password) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));
    
    // Simulate user creation
    if (email.contains('@') && password.length >= 6) {
      final user = User(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        displayName: email.split('@').first,
        email: email,
        isEmailVerified: false,
      );
      
      _currentUser = user;
      _authStateController.add(user);
      
      return user;
    } else {
      throw Exception('Invalid email or password');
    }
  }
  
  @override
  Future<User> signInWithApple() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));
    
    // Simulate Apple sign in
    final user = User(
      id: 'apple_${DateTime.now().millisecondsSinceEpoch}',
      displayName: 'Apple User',
      email: 'apple_user@example.com',
      photoUrl: 'https://example.com/avatar.png',
      isEmailVerified: true,
    );
    
    _currentUser = user;
    _authStateController.add(user);
    
    return user;
  }
  
  @override
  Future<void> signOut() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 300));
    
    _currentUser = null;
    _authStateController.add(null);
  }
  
  @override
  Future<void> sendPasswordResetEmail(String email) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 300));
    
    // Just return, no actual email is sent in mock
    if (!email.contains('@')) {
      throw Exception('Invalid email address');
    }
  }
  
  @override
  Future<User> updateProfile({String? displayName, String? photoUrl}) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 300));
    
    if (_currentUser == null) {
      throw Exception('No user signed in');
    }
    
    final updatedUser = _currentUser!.copyWith(
      displayName: displayName ?? _currentUser!.displayName,
      photoUrl: photoUrl ?? _currentUser!.photoUrl,
    );
    
    _currentUser = updatedUser;
    _authStateController.add(updatedUser);
    
    return updatedUser;
  }
  
  @override
  Future<void> deleteAccount() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 300));
    
    if (_currentUser == null) {
      throw Exception('No user signed in');
    }
    
    _currentUser = null;
    _authStateController.add(null);
  }
  
  /// Dispose resources
  void dispose() {
    _authStateController.close();
  }
}
