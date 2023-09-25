class DrvRequest {
  String clientVersion;
  String clientId;
  int drvReqSq;

  DrvRequest({
    this.clientVersion = "",
    this.clientId = "",
    required this.drvReqSq,
  });

  factory DrvRequest.fromJson(Map<String, dynamic> json) => DrvRequest(
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
