import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'storage_service_interface.dart';

/// Implementation of the StorageServiceInterface using Firestore
class FirestoreStorageService implements StorageServiceInterface {
  final FirebaseFirestore _firestore;
  final firebase_auth.FirebaseAuth _auth;
  
  /// Constructor
  FirestoreStorageService({
    FirebaseFirestore? firestore,
    firebase_auth.FirebaseAuth? auth,
  })  : _firestore = firestore ?? FirebaseFirestore.instance,
        _auth = auth ?? firebase_auth.FirebaseAuth.instance;
  
  /// Get the current user ID
  String? get _userId => _auth.currentUser?.uid;
  
  /// Get the user document reference
  DocumentReference get _userDoc {
    final userId = _userId;
    if (userId == null) {
      throw Exception('No user signed in');
    }
    return _firestore.collection('users').doc(userId);
  }
  
  @override
  Future<void> saveData<T>(String key, T data) async {
    try {
      // If user is not signed in, throw an exception
      if (_userId == null) {
        throw Exception('No user signed in');
      }
      
      // Convert data to JSON
      final jsonData = _convertToJson(data);
      
      // Save data to Firestore
      await _userDoc.collection('data').doc(key).set({
        'data': jsonData,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Failed to save data: $e');
    }
  }
  
  @override
  Future<T?> loadData<T>(String key) async {
    try {
      // If user is not signed in, return null
      if (_userId == null) {
        return null;
      }
      
      // Get data from Firestore
      final doc = await _userDoc.collection('data').doc(key).get();
      
      if (!doc.exists || !doc.data()!.containsKey('data')) {
        return null;
      }
      
      // Convert data from JSON
      return _convertFromJson<T>(doc.data()!['data']);
    } catch (e) {
      throw Exception('Failed to load data: $e');
    }
  }
  
  @override
  Future<void> deleteData(String key) async {
    try {
      // If user is not signed in, throw an exception
      if (_userId == null) {
        throw Exception('No user signed in');
      }
      
      // Delete data from Firestore
      await _userDoc.collection('data').doc(key).delete();
    } catch (e) {
      throw Exception('Failed to delete data: $e');
    }
  }
  
  @override
  Future<bool> hasData(String key) async {
    try {
      // If user is not signed in, return false
      if (_userId == null) {
        return false;
      }
      
      // Check if data exists in Firestore
      final doc = await _userDoc.collection('data').doc(key).get();
      return doc.exists && doc.data()!.containsKey('data');
    } catch (e) {
      throw Exception('Failed to check data: $e');
    }
  }
  
  /// Convert data to JSON
  dynamic _convertToJson<T>(T data) {
    if (data is String || data is bool || data is int || data is double) {
      return data;
    } else if (data is List<String>) {
      return data;
    } else {
      // For complex objects, convert to JSON
      return jsonEncode(data);
    }
  }
  
  /// Convert data from JSON
  T? _convertFromJson<T>(dynamic jsonData) {
    if (jsonData == null) {
      return null;
    }
    
    if (T == String && jsonData is String) {
      return jsonData as T;
    } else if (T == bool && jsonData is bool) {
      return jsonData as T;
    } else if (T == int && jsonData is int) {
      return jsonData as T;
    } else if (T == double && jsonData is double) {
      return jsonData as T;
    } else if (jsonData is List<dynamic>) {
      if (T.toString() == 'List<String>') {
        return jsonData.cast<String>() as T;
      }
    } else if (jsonData is String) {
      // For complex objects, parse from JSON
      return jsonDecode(jsonData) as T;
    } else {
      // For already decoded JSON objects
      return jsonData as T;
    }
  }
}
