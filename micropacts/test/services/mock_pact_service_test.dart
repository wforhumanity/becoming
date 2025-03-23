import 'package:flutter_test/flutter_test.dart';
import 'package:micropacts/models/pact_model.dart';
import 'package:micropacts/services/mock_pact_service.dart';

void main() {
  group('MockPactService', () {
    late MockPactService pactService;
    
    setUp(() {
      pactService = MockPactService();
    });
    
    test('should create a pact with a generated ID if empty', () async {
      // Arrange
      final pact = Pact(
        id: '',
        title: 'Test Pact',
        purpose: 'Testing',
        action: 'Test',
        startDate: DateTime(2023, 1, 1),
        endDate: DateTime(2023, 1, 7),
        trackingData: {},
      );
      
      // Act
      final createdPact = await pactService.createPact(pact);
      
      // Assert
      expect(createdPact.id.isNotEmpty, true);
      expect(createdPact.title, 'Test Pact');
    });
    
    test('should create a pact with the provided ID if not empty', () async {
      // Arrange
      final pact = Pact(
        id: 'test-id',
        title: 'Test Pact',
        purpose: 'Testing',
        action: 'Test',
        startDate: DateTime(2023, 1, 1),
        endDate: DateTime(2023, 1, 7),
        trackingData: {},
      );
      
      // Act
      final createdPact = await pactService.createPact(pact);
      
      // Assert
      expect(createdPact.id, 'test-id');
    });
    
    test('should get all pacts', () async {
      // Arrange
      await pactService.createPact(Pact(
        id: '1',
        title: 'Pact 1',
        purpose: 'Testing',
        action: 'Test',
        startDate: DateTime(2023, 1, 1),
        endDate: DateTime(2023, 1, 7),
        trackingData: {},
      ));
      
      await pactService.createPact(Pact(
        id: '2',
        title: 'Pact 2',
        purpose: 'Testing',
        action: 'Test',
        startDate: DateTime(2023, 1, 8),
        endDate: DateTime(2023, 1, 14),
        trackingData: {},
      ));
      
      // Act
      final pacts = await pactService.getAllPacts();
      
      // Assert
      expect(pacts.length, 2);
      expect(pacts[0].id, '1');
      expect(pacts[1].id, '2');
    });
    
    test('should get active pacts', () async {
      // Arrange
      final pastDate = DateTime(2020, 1, 1);
      final futureDate = DateTime.now().add(const Duration(days: 7));
      
      await pactService.createPact(Pact(
        id: '1',
        title: 'Past Pact',
        purpose: 'Testing',
        action: 'Test',
        startDate: pastDate,
        endDate: pastDate.add(const Duration(days: 7)),
        trackingData: {},
      ));
      
      await pactService.createPact(Pact(
        id: '2',
        title: 'Future Pact',
        purpose: 'Testing',
        action: 'Test',
        startDate: DateTime.now(),
        endDate: futureDate,
        trackingData: {},
      ));
      
      // Act
      final activePacts = await pactService.getActivePacts();
      
      // Assert
      expect(activePacts.length, 1);
      expect(activePacts[0].id, '2');
    });
    
    test('should get completed pacts', () async {
      // Arrange
      final pastDate = DateTime(2020, 1, 1);
      final futureDate = DateTime.now().add(const Duration(days: 7));
      
      await pactService.createPact(Pact(
        id: '1',
        title: 'Past Pact',
        purpose: 'Testing',
        action: 'Test',
        startDate: pastDate,
        endDate: pastDate.add(const Duration(days: 7)),
        trackingData: {},
      ));
      
      await pactService.createPact(Pact(
        id: '2',
        title: 'Future Pact',
        purpose: 'Testing',
        action: 'Test',
        startDate: DateTime.now(),
        endDate: futureDate,
        trackingData: {},
      ));
      
      // Act
      final completedPacts = await pactService.getCompletedPacts();
      
      // Assert
      expect(completedPacts.length, 1);
      expect(completedPacts[0].id, '1');
    });
    
    test('should update pact tracking data', () async {
      // Arrange
      await pactService.createPact(Pact(
        id: '1',
        title: 'Test Pact',
        purpose: 'Testing',
        action: 'Test',
        startDate: DateTime(2023, 1, 1),
        endDate: DateTime(2023, 1, 7),
        trackingData: {},
      ));
      
      final date = DateTime(2023, 1, 2);
      
      // Act
      final updatedPact = await pactService.updatePactTracking('1', date, true);
      
      // Assert
      expect(updatedPact.trackingData[date], true);
    });
    
    test('should throw exception when updating non-existent pact', () async {
      // Act & Assert
      expect(
        () => pactService.updatePactTracking('non-existent', DateTime.now(), true),
        throwsException,
      );
    });
    
    test('should add reflection to pact', () async {
      // Arrange
      await pactService.createPact(Pact(
        id: '1',
        title: 'Test Pact',
        purpose: 'Testing',
        action: 'Test',
        startDate: DateTime(2023, 1, 1),
        endDate: DateTime(2023, 1, 7),
        trackingData: {},
      ));
      
      // Act
      final updatedPact = await pactService.addReflection('1', 'This was a good experience');
      
      // Assert
      expect(updatedPact.reflection, 'This was a good experience');
    });
    
    test('should throw exception when adding reflection to non-existent pact', () async {
      // Act & Assert
      expect(
        () => pactService.addReflection('non-existent', 'Reflection'),
        throwsException,
      );
    });
    
    test('should delete pact', () async {
      // Arrange
      await pactService.createPact(Pact(
        id: '1',
        title: 'Test Pact',
        purpose: 'Testing',
        action: 'Test',
        startDate: DateTime(2023, 1, 1),
        endDate: DateTime(2023, 1, 7),
        trackingData: {},
      ));
      
      // Act
      await pactService.deletePact('1');
      final pacts = await pactService.getAllPacts();
      
      // Assert
      expect(pacts.isEmpty, true);
    });
    
    test('should throw exception when deleting non-existent pact', () async {
      // Act & Assert
      expect(
        () => pactService.deletePact('non-existent'),
        throwsException,
      );
    });
    
    test('should clear all pacts', () async {
      // Arrange
      await pactService.createPact(Pact(
        id: '1',
        title: 'Pact 1',
        purpose: 'Testing',
        action: 'Test',
        startDate: DateTime(2023, 1, 1),
        endDate: DateTime(2023, 1, 7),
        trackingData: {},
      ));
      
      await pactService.createPact(Pact(
        id: '2',
        title: 'Pact 2',
        purpose: 'Testing',
        action: 'Test',
        startDate: DateTime(2023, 1, 8),
        endDate: DateTime(2023, 1, 14),
        trackingData: {},
      ));
      
      // Act
      pactService.clear();
      final pacts = await pactService.getAllPacts();
      
      // Assert
      expect(pacts.isEmpty, true);
    });
  });
}
