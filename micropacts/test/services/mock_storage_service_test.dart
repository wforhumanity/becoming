import 'package:flutter_test/flutter_test.dart';
import 'package:micropacts/services/mock_storage_service.dart';

void main() {
  group('MockStorageService', () {
    late MockStorageService storageService;
    
    setUp(() {
      storageService = MockStorageService();
    });
    
    test('should save and load string data', () async {
      // Arrange
      const key = 'test_string';
      const value = 'Hello, World!';
      
      // Act
      await storageService.saveData(key, value);
      final loadedValue = await storageService.loadData<String>(key);
      
      // Assert
      expect(loadedValue, value);
    });
    
    test('should save and load int data', () async {
      // Arrange
      const key = 'test_int';
      const value = 42;
      
      // Act
      await storageService.saveData(key, value);
      final loadedValue = await storageService.loadData<int>(key);
      
      // Assert
      expect(loadedValue, value);
    });
    
    test('should save and load double data', () async {
      // Arrange
      const key = 'test_double';
      const value = 3.14;
      
      // Act
      await storageService.saveData(key, value);
      final loadedValue = await storageService.loadData<double>(key);
      
      // Assert
      expect(loadedValue, value);
    });
    
    test('should save and load bool data', () async {
      // Arrange
      const key = 'test_bool';
      const value = true;
      
      // Act
      await storageService.saveData(key, value);
      final loadedValue = await storageService.loadData<bool>(key);
      
      // Assert
      expect(loadedValue, value);
    });
    
    test('should save and load list data', () async {
      // Arrange
      const key = 'test_list';
      final value = [1, 2, 3, 4, 5];
      
      // Act
      await storageService.saveData(key, value);
      final loadedValue = await storageService.loadData<List<dynamic>>(key);
      
      // Assert
      expect(loadedValue, value);
    });
    
    test('should save and load map data', () async {
      // Arrange
      const key = 'test_map';
      final value = {
        'name': 'John',
        'age': 30,
        'isActive': true,
      };
      
      // Act
      await storageService.saveData(key, value);
      final loadedValue = await storageService.loadData<Map<String, dynamic>>(key);
      
      // Assert
      expect(loadedValue, value);
    });
    
    test('should return null for non-existent key', () async {
      // Arrange
      const key = 'non_existent_key';
      
      // Act
      final loadedValue = await storageService.loadData<String>(key);
      
      // Assert
      expect(loadedValue, null);
    });
    
    test('should delete data', () async {
      // Arrange
      const key = 'test_delete';
      const value = 'Delete me';
      
      // Act
      await storageService.saveData(key, value);
      await storageService.deleteData(key);
      final loadedValue = await storageService.loadData<String>(key);
      
      // Assert
      expect(loadedValue, null);
    });
    
    test('should check if data exists', () async {
      // Arrange
      const key = 'test_exists';
      const value = 'I exist';
      
      // Act
      await storageService.saveData(key, value);
      final exists = await storageService.hasData(key);
      
      // Assert
      expect(exists, true);
    });
    
    test('should check if data does not exist', () async {
      // Arrange
      const key = 'test_not_exists';
      
      // Act
      final exists = await storageService.hasData(key);
      
      // Assert
      expect(exists, false);
    });
    
    test('should clear all data', () async {
      // Arrange
      await storageService.saveData('key1', 'value1');
      await storageService.saveData('key2', 'value2');
      
      // Act
      storageService.clear();
      final value1 = await storageService.loadData<String>('key1');
      final value2 = await storageService.loadData<String>('key2');
      
      // Assert
      expect(value1, null);
      expect(value2, null);
    });
    
    test('should overwrite existing data', () async {
      // Arrange
      const key = 'test_overwrite';
      const value1 = 'Original value';
      const value2 = 'New value';
      
      // Act
      await storageService.saveData(key, value1);
      await storageService.saveData(key, value2);
      final loadedValue = await storageService.loadData<String>(key);
      
      // Assert
      expect(loadedValue, value2);
    });
  });
}
