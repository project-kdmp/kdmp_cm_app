import 'package:kdmp_cm_app/data/constant/client_info.dart';

class FCMPushRequest {
  String clientVersion = ClientInfo.clientVersion;
  String clientId = ClientInfo.clientId;
  int mbrSqTarget;
  String title;
  String body;
  String? type;

  FCMPushRequest({
    required this.mbrSqTarget,
    required this.title,
    required this.body,
    this.type,
  });

  factory FCMPushRequest.fromJson(Map<String, dynamic> json) => FCMPushRequest(
        mbrSqTarget: json["mbrSqTarget"],
        title: json["title"],
        body: json["body"],
        type: json["type"],
      );

  Map<String, dynamic> toJson() => {
        "clientVersion": clientVersion,
        "clientId": clientId,
        "mbrSqTarget": mbrSqTarget,
        "title": title,
        "body": body,
        "type": type,
      };
}
