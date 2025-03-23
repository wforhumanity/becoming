/// Interface for the Storage Service
abstract class StorageServiceInterface {
  /// Save data
  Future<void> saveData<T>(String key, T data);
  
  /// Load data
  Future<T?> loadData<T>(String key);
  
  /// Delete data
  Future<void> deleteData(String key);
  
  /// Check if data exists
  Future<bool> hasData(String key);
}
