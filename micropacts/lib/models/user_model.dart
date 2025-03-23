/// Represents a user in the app
class User {
  /// Unique identifier for the user
  final String id;
  
  /// Display name of the user
  final String displayName;
  
  /// Email address of the user
  final String? email;
  
  /// URL to the user's profile photo
  final String? photoUrl;
  
  /// Whether the user's email is verified
  final bool isEmailVerified;
  
  /// Constructor
  const User({
    required this.id,
    required this.displayName,
    this.email,
    this.photoUrl,
    this.isEmailVerified = false,
  });
  
  /// Create a copy of this user with optional new values
  User copyWith({
    String? id,
    String? displayName,
    String? email,
    String? photoUrl,
    bool? isEmailVerified,
  }) {
    return User(
      id: id ?? this.id,
      displayName: displayName ?? this.displayName,
      email: email ?? this.email,
      photoUrl: photoUrl ?? this.photoUrl,
      isEmailVerified: isEmailVerified ?? this.isEmailVerified,
    );
  }
  
  /// Convert the user to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'displayName': displayName,
      'email': email,
      'photoUrl': photoUrl,
      'isEmailVerified': isEmailVerified,
    };
  }
  
  /// Create a user from a JSON map
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      displayName: json['displayName'] as String,
      email: json['email'] as String?,
      photoUrl: json['photoUrl'] as String?,
      isEmailVerified: json['isEmailVerified'] as bool? ?? false,
    );
  }
  
  /// Create a user from a Firebase user
  factory User.fromFirebase(dynamic firebaseUser) {
    return User(
      id: firebaseUser.uid,
      displayName: firebaseUser.displayName ?? 'User',
      email: firebaseUser.email,
      photoUrl: firebaseUser.photoURL,
      isEmailVerified: firebaseUser.emailVerified,
    );
  }
  
  /// Create an anonymous user
  factory User.anonymous() {
    return const User(
      id: '',
      displayName: 'Anonymous',
    );
  }
}
