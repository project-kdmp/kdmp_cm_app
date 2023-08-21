class AuthResponseModel {
  String serverVersion;
  String jwt;
  String autoRefresh;

  AuthResponseModel({
    required this.serverVersion,
    required this.jwt,
    required this.autoRefresh,
  });

  factory AuthResponseModel.fromJson(Map<String, dynamic> json) {
    return AuthResponseModel(
      serverVersion: json['serverVersion'] as String,
      jwt: json['jwt'] as String,
      autoRefresh: json['autoRefresh'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'serverVersion': serverVersion,
      'jwt': jwt,
      'autoRefresh': autoRefresh,
    };
  }

  @override
  String toString() {
    return 'AuthResponseModel{serverVersion: $serverVersion, jwt: $jwt, autoRefresh: $autoRefresh}';
  }
}
