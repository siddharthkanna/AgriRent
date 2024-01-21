class User {
  final String displayName;
  final String email;
  final String googleId;

  User(
      {required this.displayName, required this.email, required this.googleId});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      displayName: json['displayName'],
      email: json['email'],
      googleId: json['googleId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'displayName': displayName,
      'email': email,
      'googleId': googleId,
    };
  }
}
