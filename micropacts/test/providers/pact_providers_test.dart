import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:micropacts/models/pact_model.dart';
import 'package:micropacts/providers/pact_providers.dart';
import 'package:micropacts/providers/service_providers.dart';
import 'package:micropacts/services/mock_pact_service.dart';
import 'package:micropacts/services/pact_service_interface.dart';

void main() {
  group('PactProviders', () {
    late ProviderContainer container;
    late MockPactService mockPactService;
    
    setUp(() {
      mockPactService = MockPactService();
      
      container = ProviderContainer(
        overrides: [
          // Override the pactServiceProvider to use our mock
          pactServiceProvider.overrideWithValue(mockPactService),
        ],
      );
      
      // Add some test pacts
      addTestPacts(mockPactService);
    });
    
    tearDown(() {
      container.dispose();
    });
    
    test('pactsProvider should load all pacts', () async {
      // Act
      final pactsAsync = container.read(pactsProvider);
      
      // Wait for the future to complete
      await container.read(pactsProvider.notifier).loadPacts();
      
      // Get the updated state
      final updatedPactsAsync = container.read(pactsProvider);
      
      // Assert
      expect(pactsAsync, isA<AsyncValue<List<Pact>>>());
      expect(pactsAsync.isLoading, true);
      
      expect(updatedPactsAsync.hasValue, true);
      expect(updatedPactsAsync.value!.length, 3);
    });
    
    test('activePactsProvider should filter active pacts', () async {
      // Act
      await container.read(pactsProvider.notifier).loadPacts();
      final activePactsAsync = container.read(activePactsProvider);
      
      // Assert
      expect(activePactsAsync.hasValue, true);
      expect(activePactsAsync.value!.length, 2);
      expect(activePactsAsync.value![0].id, '2');
      expect(activePactsAsync.value![1].id, '3');
    });
    
    test('completedPactsProvider should filter completed pacts', () async {
      // Act
      await container.read(pactsProvider.notifier).loadPacts();
      final completedPactsAsync = container.read(completedPactsProvider);
      
      // Assert
      expect(completedPactsAsync.hasValue, true);
      expect(completedPactsAsync.value!.length, 1);
      expect(completedPactsAsync.value![0].id, '1');
    });
    
    test('addPact should add a new pact', () async {
      // Arrange
      final newPact = Pact(
        id: '',
        title: 'New Pact',
        purpose: 'Testing',
        action: 'Test',
        startDate: DateTime.now(),
        endDate: DateTime.now().add(const Duration(days: 7)),
        trackingData: {},
      );
      
      // Act
      await container.read(pactsProvider.notifier).addPact(newPact);
      
      // Assert
      final pactsAsync = container.read(pactsProvider);
      expect(pactsAsync.hasValue, true);
      expect(pactsAsync.value!.length, 4);
      expect(pactsAsync.value!.any((p) => p.title == 'New Pact'), true);
    });
    
    test('updatePactTracking should update tracking data', () async {
      // Arrange
      await container.read(pactsProvider.notifier).loadPacts();
      final pactId = '2';
      final date = DateTime(2023, 1, 1);
      
      // Act
      await container.read(pactsProvider.notifier).updatePactTracking(pactId, date, true);
      
      // Assert
      final pactsAsync = container.read(pactsProvider);
      final updatedPact = pactsAsync.value!.firstWhere((p) => p.id == pactId);
      expect(updatedPact.trackingData[date], true);
    });
    
    test('addReflection should add reflection to pact', () async {
      // Arrange
      await container.read(pactsProvider.notifier).loadPacts();
      final pactId = '1';
      const reflection = 'This was a great experience';
      
      // Act
      await container.read(pactsProvider.notifier).addReflection(pactId, reflection);
      
      // Assert
      final pactsAsync = container.read(pactsProvider);
      final updatedPact = pactsAsync.value!.firstWhere((p) => p.id == pactId);
      expect(updatedPact.reflection, reflection);
    });
    
    test('deletePact should remove a pact', () async {
      // Arrange
      await container.read(pactsProvider.notifier).loadPacts();
      final pactId = '1';
      
      // Act
      await container.read(pactsProvider.notifier).deletePact(pactId);
      
      // Assert
      final pactsAsync = container.read(pactsProvider);
      expect(pactsAsync.hasValue, true);
      expect(pactsAsync.value!.length, 2);
      expect(pactsAsync.value!.any((p) => p.id == pactId), false);
    });
  });
}

/// Add test pacts to the mock service
void addTestPacts(PactServiceInterface pactService) async {
  // Past pact (completed)
  await pactService.createPact(Pact(
    id: '1',
    title: 'Past Pact',
    purpose: 'Testing',
    action: 'Test',
    startDate: DateTime(2020, 1, 1),
    endDate: DateTime(2020, 1, 7),
    trackingData: {
      DateTime(2020, 1, 1): true,
      DateTime(2020, 1, 2): true,
      DateTime(2020, 1, 3): false,
      DateTime(2020, 1, 4): true,
      DateTime(2020, 1, 5): true,
      DateTime(2020, 1, 6): true,
      DateTime(2020, 1, 7): true,
    },
  ));
  
  // Current pact (active)
  await pactService.createPact(Pact(
    id: '2',
    title: 'Current Pact',
    purpose: 'Testing',
    action: 'Test',
    startDate: DateTime.now().subtract(const Duration(days: 3)),
    endDate: DateTime.now().add(const Duration(days: 4)),
    trackingData: {
      DateTime.now().subtract(const Duration(days: 3)): true,
      DateTime.now().subtract(const Duration(days: 2)): true,
      DateTime.now().subtract(const Duration(days: 1)): false,
    },
  ));
  
  // Future pact (active)
  await pactService.createPact(Pact(
    id: '3',
    title: 'Future Pact',
    purpose: 'Testing',
    action: 'Test',
    startDate: DateTime.now().add(const Duration(days: 1)),
    endDate: DateTime.now().add(const Duration(days: 8)),
    trackingData: {},
  ));
}
