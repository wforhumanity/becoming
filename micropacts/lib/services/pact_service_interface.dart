import '../models/pact_model.dart';

/// Interface for the Pact Service
abstract class PactServiceInterface {
  /// Create a new pact
  Future<Pact> createPact(Pact pact);
  
  /// Get all pacts
  Future<List<Pact>> getAllPacts();
  
  /// Get active pacts
  Future<List<Pact>> getActivePacts();
  
  /// Get completed pacts
  Future<List<Pact>> getCompletedPacts();
  
  /// Update pact tracking data
  Future<Pact> updatePactTracking(String pactId, DateTime date, bool completed);
  
  /// Add reflection to pact
  Future<Pact> addReflection(String pactId, String reflection);
  
  /// Delete pact
  Future<void> deletePact(String pactId);
}
