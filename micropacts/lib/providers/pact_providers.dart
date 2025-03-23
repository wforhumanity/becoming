import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../models/pact_model.dart';
import '../services/pact_service_interface.dart';
import 'service_providers.dart';

/// Provider for all pacts
final pactsProvider = StateNotifierProvider<PactsNotifier, AsyncValue<List<Pact>>>((ref) {
  final pactService = ref.watch(pactServiceProvider);
  return PactsNotifier(pactService);
});

/// Provider for active pacts
final activePactsProvider = Provider<AsyncValue<List<Pact>>>((ref) {
  final pactsAsync = ref.watch(pactsProvider);
  
  return pactsAsync.when(
    data: (pacts) => AsyncValue.data(pacts.where((pact) => pact.isActive).toList()),
    loading: () => const AsyncValue.loading(),
    error: (error, stackTrace) => AsyncValue.error(error, stackTrace),
  );
});

/// Provider for completed pacts
final completedPactsProvider = Provider<AsyncValue<List<Pact>>>((ref) {
  final pactsAsync = ref.watch(pactsProvider);
  
  return pactsAsync.when(
    data: (pacts) => AsyncValue.data(pacts.where((pact) => !pact.isActive).toList()),
    loading: () => const AsyncValue.loading(),
    error: (error, stackTrace) => AsyncValue.error(error, stackTrace),
  );
});

/// Notifier for pacts
class PactsNotifier extends StateNotifier<AsyncValue<List<Pact>>> {
  final PactServiceInterface _pactService;
  
  PactsNotifier(this._pactService) : super(const AsyncValue.loading()) {
    loadPacts();
  }
  
  /// Load all pacts
  Future<void> loadPacts() async {
    try {
      state = const AsyncValue.loading();
      final pacts = await _pactService.getAllPacts();
      state = AsyncValue.data(pacts);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
  
  /// Add a new pact
  Future<void> addPact(Pact pact) async {
    try {
      await _pactService.createPact(pact);
      loadPacts();
    } catch (e) {
      // Handle error
      rethrow;
    }
  }
  
  /// Update pact tracking
  Future<void> updatePactTracking(String pactId, DateTime date, bool completed) async {
    try {
      await _pactService.updatePactTracking(pactId, date, completed);
      loadPacts();
    } catch (e) {
      // Handle error
      rethrow;
    }
  }
  
  /// Add reflection to pact
  Future<void> addReflection(String pactId, String reflection) async {
    try {
      await _pactService.addReflection(pactId, reflection);
      loadPacts();
    } catch (e) {
      // Handle error
      rethrow;
    }
  }
  
  /// Delete pact
  Future<void> deletePact(String pactId) async {
    try {
      await _pactService.deletePact(pactId);
      loadPacts();
    } catch (e) {
      // Handle error
      rethrow;
    }
  }
}
