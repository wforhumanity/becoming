import '../models/pact_model.dart';
import 'ai_service_interface.dart';

/// Mock implementation of the AIServiceInterface for testing
class MockAIService implements AIServiceInterface {
  @override
  Future<List<String>> generatePactSuggestions(List<Pact> pastPacts) async {
    // Return mock suggestions
    return [
      "Try meditating for 5 minutes each morning to start your day with clarity and focus.",
      "Write down three things you're grateful for before bed to cultivate a positive mindset.",
      "Take a 10-minute walk during your lunch break to boost your energy and creativity."
    ];
  }
  
  @override
  Future<List<String>> generateReflectionPrompts(Pact pact) async {
    // Return mock reflection prompts
    return [
      "What did you learn about yourself while practicing ${pact.action}?",
      "How did this experiment affect your daily routine?",
      "What challenges did you face, and how did you overcome them?",
      "Would you continue this practice beyond the experiment period? Why or why not?"
    ];
  }
  
  @override
  Future<Map<String, dynamic>> analyzePactPatterns(List<Pact> completedPacts) async {
    // Return mock analysis
    return {
      'completionRate': 75.5,
      'mostSuccessfulCategory': 'Morning routines',
      'recommendedDuration': 14,
      'insights': [
        'You tend to be more consistent with morning activities',
        'Shorter experiments (7-14 days) have higher completion rates',
        'Physical activities show better adherence than mental exercises'
      ]
    };
  }
}
