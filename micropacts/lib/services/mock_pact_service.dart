import '../models/pact_model.dart';
import 'pact_service_interface.dart';

/// Mock implementation of the PactServiceInterface for testing
class MockPactService implements PactServiceInterface {
  /// In-memory list of pacts
  final List<Pact> _pacts = [];
  
  @override
  Future<Pact> createPact(Pact pact) async {
    // Generate a unique ID if not provided
    final newPact = pact.id.isEmpty 
        ? pact.copyWith(id: DateTime.now().millisecondsSinceEpoch.toString())
        : pact;
    
    _pacts.add(newPact);
    return newPact;
  }
  
  @override
  Future<List<Pact>> getAllPacts() async {
    return List.from(_pacts);
  }
  
  @override
  Future<List<Pact>> getActivePacts() async {
    return _pacts.where((pact) => pact.isActive).toList();
  }
  
  @override
  Future<List<Pact>> getCompletedPacts() async {
    return _pacts.where((pact) => !pact.isActive).toList();
  }
  
  @override
  Future<Pact> updatePactTracking(String pactId, DateTime date, bool completed) async {
    final pactIndex = _pacts.indexWhere((pact) => pact.id == pactId);
    
    if (pactIndex == -1) {
      throw Exception('Pact not found with ID: $pactId');
    }
    
    final pact = _pacts[pactIndex];
    final updatedTrackingData = Map<DateTime, bool>.from(pact.trackingData);
    updatedTrackingData[date] = completed;
    
    final updatedPact = pact.copyWith(trackingData: updatedTrackingData);
    _pacts[pactIndex] = updatedPact;
    
    return updatedPact;
  }
  
  @override
  Future<Pact> addReflection(String pactId, String reflection) async {
    final pactIndex = _pacts.indexWhere((pact) => pact.id == pactId);
    
    if (pactIndex == -1) {
      throw Exception('Pact not found with ID: $pactId');
    }
    
    final pact = _pacts[pactIndex];
    final updatedPact = pact.copyWith(reflection: reflection);
    _pacts[pactIndex] = updatedPact;
    
    return updatedPact;
  }
  
  @override
  Future<void> deletePact(String pactId) async {
    final pactIndex = _pacts.indexWhere((pact) => pact.id == pactId);
    
    if (pactIndex == -1) {
      throw Exception('Pact not found with ID: $pactId');
    }
    
    _pacts.removeAt(pactIndex);
  }
  
  /// Clear all pacts (for testing)
  void clear() {
    _pacts.clear();
  }
}
