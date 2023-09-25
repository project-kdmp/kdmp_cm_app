class CalledDetailRequest {
  String clientVersion;
  String clientId;
  int drvReqSq;

  CalledDetailRequest({
    this.clientVersion = "",
    this.clientId = "",
    required this.drvReqSq,
  });

  factory CalledDetailRequest.fromJson(Map<String, dynamic> json) => CalledDetailRequest(
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
