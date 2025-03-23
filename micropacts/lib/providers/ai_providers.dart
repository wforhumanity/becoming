import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../models/pact_model.dart';
import '../services/ai_service_interface.dart';
import 'pact_providers.dart';
import 'service_providers.dart';

/// Provider for pact suggestions
final pactSuggestionsProvider = FutureProvider<List<String>>((ref) async {
  final aiService = ref.watch(aiServiceProvider);
  final pactsAsync = ref.watch(pactsProvider);
  
  // Wait for pacts to load
  final pacts = await pactsAsync.when(
    data: (data) => Future.value(data),
    loading: () => Future.value(<Pact>[]),
    error: (_, __) => Future.value(<Pact>[]),
  );
  
  // Get suggestions based on past pacts
  return aiService.generatePactSuggestions(pacts);
});

/// Provider for reflection prompts for a specific pact
final reflectionPromptsProvider = FutureProvider.family<List<String>, Pact>((ref, pact) async {
  final aiService = ref.watch(aiServiceProvider);
  return aiService.generateReflectionPrompts(pact);
});

/// Provider for pact pattern analysis
final pactPatternAnalysisProvider = FutureProvider<Map<String, dynamic>>((ref) async {
  final aiService = ref.watch(aiServiceProvider);
  final pactsAsync = ref.watch(completedPactsProvider);
  
  // Wait for completed pacts to load
  final completedPacts = await pactsAsync.when(
    data: (data) => Future.value(data),
    loading: () => Future.value(<Pact>[]),
    error: (_, __) => Future.value(<Pact>[]),
  );
  
  // Get pattern analysis based on completed pacts
  return aiService.analyzePactPatterns(completedPacts);
});
