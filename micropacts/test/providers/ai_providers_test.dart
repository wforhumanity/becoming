import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:micropacts/models/pact_model.dart';
import 'package:micropacts/providers/ai_providers.dart';
import 'package:micropacts/providers/pact_providers.dart';
import 'package:micropacts/providers/service_providers.dart';
import 'package:micropacts/services/mock_ai_service.dart';
import 'package:micropacts/services/mock_pact_service.dart';

void main() {
  group('AIProviders', () {
    late ProviderContainer container;
    late MockAIService mockAIService;
    late MockPactService mockPactService;
    
    setUp(() {
      mockAIService = MockAIService();
      mockPactService = MockPactService();
      
      container = ProviderContainer(
        overrides: [
          // Override the aiServiceProvider to use our mock
          aiServiceProvider.overrideWithValue(mockAIService),
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
    
    test('pactSuggestionsProvider should provide suggestions', () async {
      // Act
      final suggestionsAsync = container.read(pactSuggestionsProvider);
      
      // Wait for the future to complete
      final suggestions = await suggestionsAsync.when(
        data: (data) => data,
        loading: () => <String>[],
        error: (_, __) => <String>[],
      );
      
      // Assert
      expect(suggestions.length, 3);
      expect(suggestions[0], isA<String>());
      expect(suggestions[1], isA<String>());
      expect(suggestions[2], isA<String>());
    });
    
    test('reflectionPromptsProvider should provide prompts for a pact', () async {
      // Arrange
      final pact = Pact(
        id: '1',
        title: 'Test Pact',
        purpose: 'Testing',
        action: 'Test',
        startDate: DateTime(2023, 1, 1),
        endDate: DateTime(2023, 1, 7),
        trackingData: {},
      );
      
      // Act
      final promptsAsync = container.read(reflectionPromptsProvider(pact));
      
      // Wait for the future to complete
      final prompts = await promptsAsync.when(
        data: (data) => data,
        loading: () => <String>[],
        error: (_, __) => <String>[],
      );
      
      // Assert
      expect(prompts.length, 4);
      expect(prompts[0], contains('Test'));
    });
    
    test('pactPatternAnalysisProvider should provide analysis', () async {
      // Act
      final analysisAsync = container.read(pactPatternAnalysisProvider);
      
      // Wait for the future to complete
      final analysis = await analysisAsync.when(
        data: (data) => data,
        loading: () => <String, dynamic>{},
        error: (_, __) => <String, dynamic>{},
      );
      
      // Assert
      expect(analysis, isA<Map<String, dynamic>>());
      expect(analysis['completionRate'], isA<double>());
      expect(analysis['mostSuccessfulCategory'], isA<String>());
      expect(analysis['recommendedDuration'], isA<int>());
      expect(analysis['insights'], isA<List>());
    });
    
    test('pactSuggestionsProvider should handle empty pacts', () async {
      // Arrange
      mockPactService.clear();
      
      // Act
      final suggestionsAsync = container.read(pactSuggestionsProvider);
      
      // Wait for the future to complete
      final suggestions = await suggestionsAsync.when(
        data: (data) => data,
        loading: () => <String>[],
        error: (_, __) => <String>[],
      );
      
      // Assert
      expect(suggestions.length, 3);
    });
    
    test('pactPatternAnalysisProvider should handle empty completed pacts', () async {
      // Arrange
      mockPactService.clear();
      
      // Act
      final analysisAsync = container.read(pactPatternAnalysisProvider);
      
      // Wait for the future to complete
      final analysis = await analysisAsync.when(
        data: (data) => data,
        loading: () => <String, dynamic>{},
        error: (_, __) => <String, dynamic>{},
      );
      
      // Assert
      expect(analysis, isA<Map<String, dynamic>>());
      expect(analysis['completionRate'], isA<double>());
      expect(analysis['insights'], isA<List>());
    });
  });
}

/// Add test pacts to the mock service
void addTestPacts(MockPactService pactService) async {
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
    reflection: 'This was a good experience',
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
}
