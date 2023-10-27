import 'package:kdmp_cm_app/data/constant/client_info.dart';

class CallCancelRequest {
  String clientVersion = ClientInfo.clientVersion;
  String clientId = ClientInfo.clientId;
  int mbrCmSq;
  int drvReqSq;

  CallCancelRequest({
    required this.mbrCmSq,
    required this.drvReqSq,
  });

  factory CallCancelRequest.fromJson(Map<String, dynamic> json) => CallCancelRequest(
        mbrCmSq: json["mbrCmSq"],
        drvReqSq: json["drvReqSq"],
      );

  Map<String, dynamic> toJson() => {
        "clientVersion": clientVersion,
        "clientId": clientId,
        "mbrCmSq": mbrCmSq,
        "drvReqSq": drvReqSq,
      };
}
