import 'package:kdmp_cm_app/data/constant/client_info.dart';

class CarModifyRequest {
  String clientVersion = ClientInfo.clientVersion;
  String clientId = ClientInfo.clientId;
  int mbrSq;
  String beforeCarNumId;
  String afterCarNumId;

  CarModifyRequest({
    required this.mbrSq,
    required this.beforeCarNumId,
    required this.afterCarNumId,
  });

  factory CarModifyRequest.fromJson(Map<String, dynamic> json) => CarModifyRequest(
        mbrSq: json["mbrSq"],
        beforeCarNumId: json["beforeCarNumId"],
        afterCarNumId: json["afterCarNumId"],
      );

  Map<String, dynamic> toJson() => {
        "clientVersion": clientVersion,
        "clientId": clientId,
        "mbrSq": mbrSq,
        "beforeCarNumId": beforeCarNumId,
        "afterCarNumId": afterCarNumId,
      };
}
