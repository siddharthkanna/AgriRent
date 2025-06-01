class User {
  final String id;
  final String email;
  final String name;
  final String? phoneNumber;
  final String photoUrl;
  final DateTime createdAt;
  final DateTime updatedAt;

  User({
    required this.id,
    required this.email,
    required this.name,
    this.phoneNumber,
    required this.photoUrl,
    required this.createdAt,
    required this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? '',
      email: json['email'] ?? '',
      name: json['name'] ?? '',
      phoneNumber: json['phoneNumber'],
      photoUrl: json['photoUrl'] ?? '',
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'phoneNumber': phoneNumber,
      'photoUrl': photoUrl,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  // Create a user from Supabase auth metadata
  factory User.fromAuthMetadata(Map<String, dynamic> metadata, String userId) {
    return User(
      id: userId,
      email: metadata['email'] ?? '',
      name: metadata['full_name'] ?? '',
      phoneNumber: metadata['phone'],
      photoUrl: metadata['avatar_url'] ?? '',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }
}
