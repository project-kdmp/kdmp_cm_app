import 'package:kdmp_cm_app/data/constant/client_info.dart';

class RefreshRequest {
  String clientVersion = ClientInfo.clientVersion;
  String clientId = ClientInfo.clientId;
  String mbrId;
  String autoRefreshToken;

  RefreshRequest({
    required this.mbrId,
    required this.autoRefreshToken,
  });

  factory RefreshRequest.fromJson(Map<String, dynamic> json) {
    return RefreshRequest(
      mbrId: json["mbrId"] as String,
      autoRefreshToken: json["autoRefreshToken"] as String,
    );
  }

  Map<String, dynamic> toJson() => {
        "clientVersion": clientVersion,
        "clientId": clientId,
        "mbrId": mbrId,
        "autoRefreshToken": autoRefreshToken,
      };
}
