import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart' as app_models;
import '../services/ai_service.dart';
import '../services/ai_service_interface.dart';
import '../services/auth_service_interface.dart';
import '../services/firebase_auth_service.dart';
import '../services/firestore_storage_service.dart';
import '../services/mock_auth_service.dart';
import '../services/pact_service.dart';
import '../services/pact_service_interface.dart';
import '../services/storage_service.dart';
import '../services/storage_service_interface.dart';

/// Provider for the OpenAI API key
final apiKeyProvider = Provider<String>((ref) {
  // In a real app, this would be loaded from secure storage or environment variables
  return 'YOUR_OPENAI_API_KEY';
});

/// Provider for Firebase Auth instance
final firebaseAuthProvider = Provider<firebase_auth.FirebaseAuth>((ref) {
  return firebase_auth.FirebaseAuth.instance;
});

/// Provider for the AuthService
final authServiceProvider = Provider<AuthServiceInterface>((ref) {
  // Use mock service for development/testing
  if (const bool.fromEnvironment('USE_MOCK_SERVICES', defaultValue: false)) {
    return MockAuthService();
  }
  
  // Use Firebase Auth service for production
  final firebaseAuth = ref.watch(firebaseAuthProvider);
  return FirebaseAuthService(firebaseAuth: firebaseAuth);
});

/// Provider for the current user
final currentUserProvider = StreamProvider<app_models.User?>((ref) {
  final authService = ref.watch(authServiceProvider);
  return authService.authStateChanges;
});

/// Provider for SharedPreferences instance
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('SharedPreferences not initialized');
});

/// Provider for Firestore instance
final firestoreProvider = Provider<FirebaseFirestore>((ref) {
  return FirebaseFirestore.instance;
});

/// Provider for the StorageService
final storageServiceProvider = Provider<StorageServiceInterface>((ref) {
  // Check if user is authenticated
  final userAsync = ref.watch(currentUserProvider);
  
  return userAsync.when(
    data: (user) {
      if (user != null) {
        // Use Firestore storage for authenticated users
        final firestore = ref.watch(firestoreProvider);
        final auth = ref.watch(firebaseAuthProvider);
        return FirestoreStorageService(firestore: firestore, auth: auth);
      } else {
        // Use local storage for anonymous users
        final prefs = ref.watch(sharedPreferencesProvider);
        return StorageService(prefs);
      }
    },
    loading: () {
      // Use local storage while loading
      final prefs = ref.watch(sharedPreferencesProvider);
      return StorageService(prefs);
    },
    error: (_, __) {
      // Use local storage on error
      final prefs = ref.watch(sharedPreferencesProvider);
      return StorageService(prefs);
    },
  );
});

/// Provider for the PactService
final pactServiceProvider = Provider<PactServiceInterface>((ref) {
  final storageService = ref.watch(storageServiceProvider);
  return PactService(storageService);
});

/// Provider for the AIService
final aiServiceProvider = Provider<AIServiceInterface>((ref) {
  final apiKey = ref.watch(apiKeyProvider);
  return AIService(apiKey);
});
