import 'package:flutter_test/flutter_test.dart';
import 'package:micropacts/models/pact_model.dart';

void main() {
  group('Pact Model', () {
    test('should create a pact with valid data', () {
      // Arrange
      final pact = Pact(
        id: '1',
        title: 'Morning Meditation',
        purpose: 'Reduce stress',
        action: 'Meditate for 5 minutes',
        startDate: DateTime(2023, 1, 1),
        endDate: DateTime(2023, 1, 7),
        trackingData: {},
      );
      
      // Assert
      expect(pact.id, '1');
      expect(pact.title, 'Morning Meditation');
      expect(pact.purpose, 'Reduce stress');
      expect(pact.action, 'Meditate for 5 minutes');
      expect(pact.startDate, DateTime(2023, 1, 1));
      expect(pact.endDate, DateTime(2023, 1, 7));
      expect(pact.trackingData, {});
      expect(pact.reflection, null);
    });
    
    test('should create a copy with updated values', () {
      // Arrange
      final pact = Pact(
        id: '1',
        title: 'Morning Meditation',
        purpose: 'Reduce stress',
        action: 'Meditate for 5 minutes',
        startDate: DateTime(2023, 1, 1),
        endDate: DateTime(2023, 1, 7),
        trackingData: {},
      );
      
      // Act
      final updatedPact = pact.copyWith(
        title: 'Evening Meditation',
        action: 'Meditate for 10 minutes',
      );
      
      // Assert
      expect(updatedPact.id, '1'); // Unchanged
      expect(updatedPact.title, 'Evening Meditation'); // Changed
      expect(updatedPact.purpose, 'Reduce stress'); // Unchanged
      expect(updatedPact.action, 'Meditate for 10 minutes'); // Changed
      expect(updatedPact.startDate, DateTime(2023, 1, 1)); // Unchanged
      expect(updatedPact.endDate, DateTime(2023, 1, 7)); // Unchanged
      expect(updatedPact.trackingData, {}); // Unchanged
      expect(updatedPact.reflection, null); // Unchanged
    });
    
    test('should correctly determine if pact is active', () {
      // Arrange
      final pastPact = Pact(
        id: '1',
        title: 'Past Pact',
        purpose: 'Test',
        action: 'Test',
        startDate: DateTime(2020, 1, 1),
        endDate: DateTime(2020, 1, 7),
        trackingData: {},
      );
      
      final futurePact = Pact(
        id: '2',
        title: 'Future Pact',
        purpose: 'Test',
        action: 'Test',
        startDate: DateTime.now().add(const Duration(days: 1)),
        endDate: DateTime.now().add(const Duration(days: 7)),
        trackingData: {},
      );
      
      // Assert
      expect(pastPact.isActive, false);
      expect(futurePact.isActive, true);
    });
    
    test('should calculate completion percentage correctly', () {
      // Arrange
      final pact = Pact(
        id: '1',
        title: 'Test Pact',
        purpose: 'Test',
        action: 'Test',
        startDate: DateTime(2023, 1, 1),
        endDate: DateTime(2023, 1, 5), // 5 days total
        trackingData: {
          DateTime(2023, 1, 1): true,
          DateTime(2023, 1, 2): true,
          DateTime(2023, 1, 3): false,
          DateTime(2023, 1, 4): true,
        },
      );
      
      // Act
      final percentage = pact.completionPercentage;
      
      // Assert
      // 3 completed days out of 5 total days = 60%
      expect(percentage, 60.0);
    });
    
    test('should return 0% completion for empty tracking data', () {
      // Arrange
      final pact = Pact(
        id: '1',
        title: 'Test Pact',
        purpose: 'Test',
        action: 'Test',
        startDate: DateTime(2023, 1, 1),
        endDate: DateTime(2023, 1, 5),
        trackingData: {},
      );
      
      // Act
      final percentage = pact.completionPercentage;
      
      // Assert
      expect(percentage, 0.0);
    });
    
    test('should convert to and from JSON correctly', () {
      // Arrange
      final originalPact = Pact(
        id: '1',
        title: 'Morning Meditation',
        purpose: 'Reduce stress',
        action: 'Meditate for 5 minutes',
        startDate: DateTime(2023, 1, 1),
        endDate: DateTime(2023, 1, 7),
        trackingData: {
          DateTime(2023, 1, 1): true,
          DateTime(2023, 1, 2): false,
        },
        reflection: 'This was a good experience',
      );
      
      // Act
      final json = originalPact.toJson();
      final recreatedPact = Pact.fromJson(json);
      
      // Assert
      expect(recreatedPact.id, originalPact.id);
      expect(recreatedPact.title, originalPact.title);
      expect(recreatedPact.purpose, originalPact.purpose);
      expect(recreatedPact.action, originalPact.action);
      expect(recreatedPact.startDate.toIso8601String(), originalPact.startDate.toIso8601String());
      expect(recreatedPact.endDate.toIso8601String(), originalPact.endDate.toIso8601String());
      expect(recreatedPact.trackingData.length, originalPact.trackingData.length);
      expect(recreatedPact.reflection, originalPact.reflection);
      
      // Check tracking data
      for (final entry in originalPact.trackingData.entries) {
        final date = entry.key;
        final completed = entry.value;
        expect(recreatedPact.trackingData[date], completed);
      }
    });
  });
}
