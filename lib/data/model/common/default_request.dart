import 'package:kdmp_cm_app/data/constant/client_info.dart';

class DefaultRequest {
  String clientVersion = ClientInfo.clientVersion;
  String clientId = ClientInfo.clientId;
  int mbrSq;

  DefaultRequest({
    required this.mbrSq,
  });

  factory DefaultRequest.fromJson(Map<String, dynamic> json) {
    return DefaultRequest(
      mbrSq: json["mbrSq"] as int,
    );
  }

  Map<String, dynamic> toJson() => {
        "clientVersion": clientVersion,
        "clientId": clientId,
        "mbrSq": mbrSq,
      };
}
