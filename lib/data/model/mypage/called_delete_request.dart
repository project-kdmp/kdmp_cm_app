class CalledDeleteRequest {
  String clientVersion;
  String clientId;
  int drvReqSq;

  CalledDeleteRequest({
    this.clientVersion = "",
    this.clientId = "",
    required this.drvReqSq,
  });

  factory CalledDeleteRequest.fromJson(Map<String, dynamic> json) => CalledDeleteRequest(
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
