import 'package:kdmp_cm_app/data/constant/client_info.dart';

class FCMTokenRequest {
  String clientVersion = ClientInfo.clientVersion;
  String clientId = ClientInfo.clientId;
  int mbrSq;
  String mbrFcmToken;

  FCMTokenRequest({
    required this.mbrSq,
    required this.mbrFcmToken,
  });

  factory FCMTokenRequest.fromJson(Map<String, dynamic> json) => FCMTokenRequest(
        mbrSq: json["mbrSq"],
        mbrFcmToken: json["mbrFcmToken"],
      );

  Map<String, dynamic> toJson() => {
        "clientVersion": clientVersion,
        "clientId": clientId,
        "mbrSq": mbrSq,
        "mbrFcmToken": mbrFcmToken,
      };
}
