import 'package:kdmp_cm_app/data/constant/client_info.dart';

class ConfirmCallCancelRequest {
  String clientVersion = ClientInfo.clientVersion;
  String clientId = ClientInfo.clientId;
  int mbrCmSq;
  int drvReqSq;
  String drvCancelTp;

  ConfirmCallCancelRequest({
    required this.mbrCmSq,
    required this.drvReqSq,
    required this.drvCancelTp,
  });

  factory ConfirmCallCancelRequest.fromJson(Map<String, dynamic> json) => ConfirmCallCancelRequest(
        mbrCmSq: json["mbrCmSq"],
        drvReqSq: json["drvReqSq"],
        drvCancelTp: json["drvCancelTp"],
      );

  Map<String, dynamic> toJson() => {
        "clientVersion": clientVersion,
        "clientId": clientId,
        "mbrCmSq": mbrCmSq,
        "drvReqSq": drvReqSq,
        "drvCancelTp": drvCancelTp,
      };
}
