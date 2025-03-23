import 'dart:convert';
import 'storage_service_interface.dart';

/// Mock implementation of the StorageServiceInterface for testing
class MockStorageService implements StorageServiceInterface {
  /// In-memory storage map
  final Map<String, String> _storage = {};
  
  @override
  Future<void> saveData<T>(String key, T data) async {
    // Convert data to JSON string
    final jsonData = jsonEncode(data);
    _storage[key] = jsonData;
  }
  
  @override
  Future<T?> loadData<T>(String key) async {
    if (!_storage.containsKey(key)) {
      return null;
    }
    
    final jsonData = _storage[key];
    // This is a simplified implementation for testing
    // In a real implementation, we would need to handle different types properly
    return jsonDecode(jsonData!) as T;
  }
  
  @override
  Future<void> deleteData(String key) async {
    _storage.remove(key);
  }
  
  @override
  Future<bool> hasData(String key) async {
    return _storage.containsKey(key);
  }
  
  /// Clear all data (for testing)
  void clear() {
    _storage.clear();
  }
}
