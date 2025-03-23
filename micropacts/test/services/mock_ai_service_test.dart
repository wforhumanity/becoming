import 'package:flutter_test/flutter_test.dart';
import 'package:micropacts/models/pact_model.dart';
import 'package:micropacts/services/mock_ai_service.dart';

void main() {
  group('MockAIService', () {
    late MockAIService aiService;
    
    setUp(() {
      aiService = MockAIService();
    });
    
    test('should generate pact suggestions', () async {
      // Arrange
      final pastPacts = [
        Pact(
          id: '1',
          title: 'Morning Meditation',
          purpose: 'Reduce stress',
          action: 'Meditate for 5 minutes',
          startDate: DateTime(2023, 1, 1),
          endDate: DateTime(2023, 1, 7),
          trackingData: {},
          reflection: 'I felt more calm throughout the day',
        ),
        Pact(
          id: '2',
          title: 'Daily Gratitude',
          purpose: 'Increase positivity',
          action: 'Write down 3 things I\'m grateful for',
          startDate: DateTime(2023, 1, 8),
          endDate: DateTime(2023, 1, 14),
          trackingData: {},
          reflection: 'I noticed more positive things in my life',
        ),
      ];
      
      // Act
      final suggestions = await aiService.generatePactSuggestions(pastPacts);
      
      // Assert
      expect(suggestions.length, 3);
      expect(suggestions[0], isA<String>());
      expect(suggestions[1], isA<String>());
      expect(suggestions[2], isA<String>());
    });
    
    test('should generate reflection prompts', () async {
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
      final prompts = await aiService.generateReflectionPrompts(pact);
      
      // Assert
      expect(prompts.length, 4);
      expect(prompts[0], contains('Meditate for 5 minutes'));
    });
    
    test('should analyze pact patterns', () async {
      // Arrange
      final completedPacts = [
        Pact(
          id: '1',
          title: 'Morning Meditation',
          purpose: 'Reduce stress',
          action: 'Meditate for 5 minutes',
          startDate: DateTime(2023, 1, 1),
          endDate: DateTime(2023, 1, 7),
          trackingData: {
            DateTime(2023, 1, 1): true,
            DateTime(2023, 1, 2): true,
            DateTime(2023, 1, 3): true,
            DateTime(2023, 1, 4): false,
            DateTime(2023, 1, 5): true,
            DateTime(2023, 1, 6): true,
            DateTime(2023, 1, 7): true,
          },
          reflection: 'I felt more calm throughout the day',
        ),
        Pact(
          id: '2',
          title: 'Daily Gratitude',
          purpose: 'Increase positivity',
          action: 'Write down 3 things I\'m grateful for',
          startDate: DateTime(2023, 1, 8),
          endDate: DateTime(2023, 1, 14),
          trackingData: {
            DateTime(2023, 1, 8): true,
            DateTime(2023, 1, 9): true,
            DateTime(2023, 1, 10): false,
            DateTime(2023, 1, 11): false,
            DateTime(2023, 1, 12): true,
            DateTime(2023, 1, 13): true,
            DateTime(2023, 1, 14): true,
          },
          reflection: 'I noticed more positive things in my life',
        ),
      ];
      
      // Act
      final analysis = await aiService.analyzePactPatterns(completedPacts);
      
      // Assert
      expect(analysis, isA<Map<String, dynamic>>());
      expect(analysis['completionRate'], isA<double>());
      expect(analysis['mostSuccessfulCategory'], isA<String>());
      expect(analysis['recommendedDuration'], isA<int>());
      expect(analysis['insights'], isA<List>());
      expect(analysis['insights'].length, 3);
    });
    
    test('should handle empty pact list for suggestions', () async {
      // Arrange
      final emptyPacts = <Pact>[];
      
      // Act
      final suggestions = await aiService.generatePactSuggestions(emptyPacts);
      
      // Assert
      expect(suggestions.length, 3);
    });
    
    test('should handle empty pact list for analysis', () async {
      // Arrange
      final emptyPacts = <Pact>[];
      
      // Act
      final analysis = await aiService.analyzePactPatterns(emptyPacts);
      
      // Assert
      expect(analysis, isA<Map<String, dynamic>>());
      expect(analysis['completionRate'], isA<double>());
      expect(analysis['insights'], isA<List>());
    });
  });
}
