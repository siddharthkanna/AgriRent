class User {
  final String displayName;
  final String email;
  final String googleId;
  final String photoURL;
  final String mobileNumber;

  User(
      {required this.displayName,
      required this.email,
      required this.googleId,
      required this.photoURL,
      required this.mobileNumber});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      displayName: json['displayName'],
      email: json['email'],
      googleId: json['googleId'],
      photoURL: json['photoURL'],
      mobileNumber: json['mobileNumber'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'displayName': displayName,
      'email': email,
      'googleId': googleId,
      'photoURL': photoURL,
      'mobileNumber': mobileNumber,
    };
  }
}
