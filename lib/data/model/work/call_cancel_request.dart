import 'package:kdmp_cm_app/data/constant/client_info.dart';

class CallCancelRequest {
  String clientVersion = ClientInfo.clientVersion;
  String clientId = ClientInfo.clientId;
  int mbrCmSq;
  int drvReqSq;
  String drvCancelTp;
  String cancelReason;

  CallCancelRequest({
    required this.mbrCmSq,
    required this.drvReqSq,
    required this.drvCancelTp,
    this.cancelReason = '',
  });

  factory CallCancelRequest.fromJson(Map<String, dynamic> json) => CallCancelRequest(
        mbrCmSq: json["mbrCmSq"],
        drvReqSq: json["drvReqSq"],
        drvCancelTp: json["drvCancelTp"],
        cancelReason: json["cancelReason"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "clientVersion": clientVersion,
        "clientId": clientId,
        "mbrCmSq": mbrCmSq,
        "drvReqSq": drvReqSq,
        "drvCancelTp": drvCancelTp,
        "cancelReason": cancelReason,
      };
}
