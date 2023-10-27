import 'package:kdmp_cm_app/data/constant/client_info.dart';

class LoginRequest {
  String clientVersion = ClientInfo.clientVersion;
  String clientId = ClientInfo.clientId;
  String mbrId;
  String mbrDeviceId;
  String password;

  LoginRequest({
    required this.mbrId,
    required this.mbrDeviceId,
    required this.password,
  });

  factory LoginRequest.fromJson(Map<String, dynamic> json) {
    return LoginRequest(
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
