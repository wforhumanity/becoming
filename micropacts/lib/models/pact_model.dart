/// Represents a PACT (Purposeful, Actionable, Continuous, Trackable) experiment
class Pact {
  /// Unique identifier for the pact
  final String id;
  
  /// Title of the pact
  final String title;
  
  /// Purpose of the pact (why the user is doing this)
  final String purpose;
  
  /// Action to be taken (what the user will do)
  final String action;
  
  /// Start date of the pact
  final DateTime startDate;
  
  /// End date of the pact
  final DateTime endDate;
  
  /// Tracking data for each day (date -> completed)
  final Map<DateTime, bool> trackingData;
  
  /// Reflection on the pact (optional)
  final String? reflection;
  
  /// Constructor
  const Pact({
    required this.id,
    required this.title,
    required this.purpose,
    required this.action,
    required this.startDate,
    required this.endDate,
    required this.trackingData,
    this.reflection,
  });
  
  /// Create a copy of this pact with optional new values
  Pact copyWith({
    String? id,
    String? title,
    String? purpose,
    String? action,
    DateTime? startDate,
    DateTime? endDate,
    Map<DateTime, bool>? trackingData,
    String? reflection,
  }) {
    return Pact(
      id: id ?? this.id,
      title: title ?? this.title,
      purpose: purpose ?? this.purpose,
      action: action ?? this.action,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      trackingData: trackingData ?? this.trackingData,
      reflection: reflection ?? this.reflection,
    );
  }
  
  /// Check if the pact is currently active
  bool get isActive => DateTime.now().isBefore(endDate);
  
  /// Calculate the completion percentage of the pact
  double get completionPercentage {
    if (trackingData.isEmpty) return 0.0;
    
    final totalDays = endDate.difference(startDate).inDays + 1;
    final completedDays = trackingData.values.where((completed) => completed).length;
    
    return (completedDays / totalDays) * 100;
  }
  
  /// Convert the pact to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'purpose': purpose,
      'action': action,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'trackingData': trackingData.map(
        (date, completed) => MapEntry(date.toIso8601String(), completed),
      ),
      'reflection': reflection,
    };
  }
  
  /// Create a pact from a JSON map
  factory Pact.fromJson(Map<String, dynamic> json) {
    final trackingDataJson = json['trackingData'] as Map<String, dynamic>;
    final trackingData = <DateTime, bool>{};
    
    trackingDataJson.forEach((dateStr, completed) {
      trackingData[DateTime.parse(dateStr)] = completed as bool;
    });
    
    return Pact(
      id: json['id'] as String,
      title: json['title'] as String,
      purpose: json['purpose'] as String,
      action: json['action'] as String,
      startDate: DateTime.parse(json['startDate'] as String),
      endDate: DateTime.parse(json['endDate'] as String),
      trackingData: trackingData,
      reflection: json['reflection'] as String?,
    );
  }
}
