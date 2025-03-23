import 'dart:convert';
import '../models/pact_model.dart';
import 'pact_service_interface.dart';
import 'storage_service_interface.dart';

/// Implementation of the PactServiceInterface using StorageService
class PactService implements PactServiceInterface {
  final StorageServiceInterface _storageService;
  static const String _pactsKey = 'pacts';
  
  /// Constructor
  PactService(this._storageService);
  
  @override
  Future<Pact> createPact(Pact pact) async {
    final pacts = await getAllPacts();
    
    // Generate a unique ID if not provided
    final newPact = pact.id.isEmpty 
        ? pact.copyWith(id: DateTime.now().millisecondsSinceEpoch.toString())
        : pact;
    
    pacts.add(newPact);
    await _savePacts(pacts);
    
    return newPact;
  }
  
  @override
  Future<List<Pact>> getAllPacts() async {
    final jsonData = await _storageService.loadData<List<dynamic>>(_pactsKey);
    
    if (jsonData == null) {
      return [];
    }
    
    try {
      return jsonData
          .map((item) => Pact.fromJson(item as Map<String, dynamic>))
          .toList();
    } catch (e) {
      // If there's an error parsing the data, return an empty list
      return [];
    }
  }
  
  @override
  Future<List<Pact>> getActivePacts() async {
    final pacts = await getAllPacts();
    return pacts.where((pact) => pact.isActive).toList();
  }
  
  @override
  Future<List<Pact>> getCompletedPacts() async {
    final pacts = await getAllPacts();
    return pacts.where((pact) => !pact.isActive).toList();
  }
  
  @override
  Future<Pact> updatePactTracking(String pactId, DateTime date, bool completed) async {
    final pacts = await getAllPacts();
    final pactIndex = pacts.indexWhere((pact) => pact.id == pactId);
    
    if (pactIndex == -1) {
      throw Exception('Pact not found with ID: $pactId');
    }
    
    final pact = pacts[pactIndex];
    final updatedTrackingData = Map<DateTime, bool>.from(pact.trackingData);
    updatedTrackingData[date] = completed;
    
    final updatedPact = pact.copyWith(trackingData: updatedTrackingData);
    pacts[pactIndex] = updatedPact;
    
    await _savePacts(pacts);
    return updatedPact;
  }
  
  @override
  Future<Pact> addReflection(String pactId, String reflection) async {
    final pacts = await getAllPacts();
    final pactIndex = pacts.indexWhere((pact) => pact.id == pactId);
    
    if (pactIndex == -1) {
      throw Exception('Pact not found with ID: $pactId');
    }
    
    final pact = pacts[pactIndex];
    final updatedPact = pact.copyWith(reflection: reflection);
    pacts[pactIndex] = updatedPact;
    
    await _savePacts(pacts);
    return updatedPact;
  }
  
  @override
  Future<void> deletePact(String pactId) async {
    final pacts = await getAllPacts();
    final pactIndex = pacts.indexWhere((pact) => pact.id == pactId);
    
    if (pactIndex == -1) {
      throw Exception('Pact not found with ID: $pactId');
    }
    
    pacts.removeAt(pactIndex);
    await _savePacts(pacts);
  }
  
  /// Save the list of pacts to storage
  Future<void> _savePacts(List<Pact> pacts) async {
    final jsonData = pacts.map((pact) => pact.toJson()).toList();
    await _storageService.saveData(_pactsKey, jsonData);
  }
}
