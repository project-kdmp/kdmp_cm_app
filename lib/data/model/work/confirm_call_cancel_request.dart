class ConfirmCallCancelRequest {
  String clientVersion;
  String clientId;
  int mbrCmSq;
  int drvReqSq;
  String drvCancelTp;

  ConfirmCallCancelRequest({
    this.clientVersion = "",
    this.clientId = "",
    required this.mbrCmSq,
    required this.drvReqSq,
    required this.drvCancelTp,
  });

  factory ConfirmCallCancelRequest.fromJson(Map<String, dynamic> json) => ConfirmCallCancelRequest(
        clientVersion: json["clientVersion"],
        clientId: json["clientId"],
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
