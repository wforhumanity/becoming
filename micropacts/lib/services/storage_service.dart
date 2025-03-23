import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'storage_service_interface.dart';

/// Implementation of the StorageServiceInterface using SharedPreferences
class StorageService implements StorageServiceInterface {
  final SharedPreferences _prefs;
  
  /// Constructor
  StorageService(this._prefs);
  
  @override
  Future<void> saveData<T>(String key, T data) async {
    String jsonData;
    
    if (data is String) {
      await _prefs.setString(key, data);
      return;
    } else if (data is bool) {
      await _prefs.setBool(key, data);
      return;
    } else if (data is int) {
      await _prefs.setInt(key, data);
      return;
    } else if (data is double) {
      await _prefs.setDouble(key, data);
      return;
    } else if (data is List<String>) {
      await _prefs.setStringList(key, data);
      return;
    } else {
      // For complex objects, convert to JSON
      try {
        jsonData = jsonEncode(data);
        await _prefs.setString(key, jsonData);
      } catch (e) {
        throw Exception('Failed to save data: $e');
      }
    }
  }
  
  @override
  Future<T?> loadData<T>(String key) async {
    if (!_prefs.containsKey(key)) {
      return null;
    }
    
    // Handle primitive types
    if (T == String) {
      return _prefs.getString(key) as T?;
    } else if (T == bool) {
      return _prefs.getBool(key) as T?;
    } else if (T == int) {
      return _prefs.getInt(key) as T?;
    } else if (T == double) {
      return _prefs.getDouble(key) as T?;
    } else if (T == List<String>) {
      return _prefs.getStringList(key) as T?;
    } else {
      // For complex objects, parse from JSON
      try {
        final jsonData = _prefs.getString(key);
        if (jsonData == null) return null;
        return jsonDecode(jsonData) as T?;
      } catch (e) {
        throw Exception('Failed to load data: $e');
      }
    }
  }
  
  @override
  Future<void> deleteData(String key) async {
    await _prefs.remove(key);
  }
  
  @override
  Future<bool> hasData(String key) async {
    return _prefs.containsKey(key);
  }
}
