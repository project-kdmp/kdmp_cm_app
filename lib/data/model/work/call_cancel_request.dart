class CallCancelRequest {
  String clientVersion;
  String clientId;
  int mbrCmSq;
  int drvReqSq;

  CallCancelRequest({
    this.clientVersion = "",
    this.clientId = "",
    required this.mbrCmSq,
    required this.drvReqSq,
  });

  factory CallCancelRequest.fromJson(Map<String, dynamic> json) => CallCancelRequest(
        clientVersion: json["clientVersion"],
        clientId: json["clientId"],
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
