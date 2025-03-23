import '../models/pact_model.dart';

/// Interface for the AI Service
abstract class AIServiceInterface {
  /// Generate pact suggestions based on past pacts
  Future<List<String>> generatePactSuggestions(List<Pact> pastPacts);
  
  /// Generate reflection prompts based on a specific pact
  Future<List<String>> generateReflectionPrompts(Pact pact);
  
  /// Analyze pact patterns and provide insights
  Future<Map<String, dynamic>> analyzePactPatterns(List<Pact> completedPacts);
}
