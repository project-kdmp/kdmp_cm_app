class LoginRequest {
  String clientVersion;
  String clientId;
  String mbrId;
  String mbrDeviceId;
  String password;

  LoginRequest({
    this.clientVersion = "",
    this.clientId = "",
    required this.mbrId,
    required this.mbrDeviceId,
    required this.password,
  });

  factory LoginRequest.fromJson(Map<String, dynamic> json) {
    return LoginRequest(
      clientVersion: json["clientVersion"] as String,
      clientId: json["clientId"] as String,
      mbrId: json["mbrId"] as String,
      mbrDeviceId: json["mbrDeviceId"] as String,
      password: json["password"] as String,
    );
  }

  Map<String, dynamic> toJson() => {
        "clientVersion": clientVersion,
        "clientId": clientId,
        "mbrId": mbrId,
        "mbrDeviceId": mbrDeviceId,
        "password": password,
      };
}
