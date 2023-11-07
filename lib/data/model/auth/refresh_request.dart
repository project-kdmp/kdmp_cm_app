import 'package:kdmp_cm_app/data/constant/client_info.dart';

class RefreshRequest {
  String clientVersion = ClientInfo.clientVersion;
  String clientId = ClientInfo.clientId;
  int mbrSq;
  String autoRefreshToken;

  RefreshRequest({
    required this.mbrSq,
    required this.autoRefreshToken,
  });

  factory RefreshRequest.fromJson(Map<String, dynamic> json) {
    return RefreshRequest(
      mbrSq: json["mbrSq"],
      autoRefreshToken: json["autoRefreshToken"],
    );
  }

  Map<String, dynamic> toJson() => {
        "clientVersion": clientVersion,
        "clientId": clientId,
        "mbrSq": mbrSq,
        "autoRefreshToken": autoRefreshToken,
      };
}
