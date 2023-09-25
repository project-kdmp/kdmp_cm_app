class CallDetailRequest {
  String clientVersion;
  String clientId;
  int drvReqSq;

  CallDetailRequest({
    this.clientVersion = "",
    this.clientId = "",
    required this.drvReqSq,
  });

  factory CallDetailRequest.fromJson(Map<String, dynamic> json) => CallDetailRequest(
        clientVersion: json["clientVersion"],
        clientId: json["clientId"],
        drvReqSq: json["drvReqSq"],
      );

  Map<String, dynamic> toJson() => {
        "clientVersion": clientVersion,
        "clientId": clientId,
        "drvReqSq": drvReqSq,
      };
}
