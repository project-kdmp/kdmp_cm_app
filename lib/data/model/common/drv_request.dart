import 'package:kdmp_cm_app/data/constant/client_info.dart';

class DrvRequest {
  String clientVersion = ClientInfo.clientVersion;
  String clientId = ClientInfo.clientId;
  int drvReqSq;

  DrvRequest({
    required this.drvReqSq,
  });

  factory DrvRequest.fromJson(Map<String, dynamic> json) => DrvRequest(
        drvReqSq: json["drvReqSq"],
      );

  Map<String, dynamic> toJson() => {
        "clientVersion": clientVersion,
        "clientId": clientId,
        "drvReqSq": drvReqSq,
      };
}
