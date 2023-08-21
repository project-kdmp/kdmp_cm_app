class AuthRequestModel {
  String clientVersion;
  String userId;
  String userEmail;
  String password;

  AuthRequestModel({
    required this.clientVersion,
    required this.userId,
    required this.userEmail,
    required this.password,
  });

  factory AuthRequestModel.fromJson(Map<String, dynamic> json) {
    return AuthRequestModel(
      clientVersion: json['clientVersion'] as String,
      userId: json['userId'] as String,
      userEmail: json['userEmail'] as String,
      password: json['password'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'clientVersion': clientVersion,
      'userId': userId,
      'userEmail': userEmail,
      'password': password,
    };
  }

  @override
  String toString() {
    return 'AuthRequestModel{clientVersion: $clientVersion, userId: $userId, userEmail: $userEmail, password: $password}';
  }

}
