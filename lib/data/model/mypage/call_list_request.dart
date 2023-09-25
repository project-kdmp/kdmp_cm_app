class CallListRequest {
  String clientVersion;
  String clientId;
  int mbrCmSq;

  CallListRequest({
    this.clientVersion = "",
    this.clientId = "",
    required this.mbrCmSq,
  });

  factory CallListRequest.fromJson(Map<String, dynamic> json) => CallListRequest(
        clientVersion: json["clientVersion"],
        clientId: json["clientId"],
        mbrCmSq: json["mbrCmSq"],
      );

  Map<String, dynamic> toJson() => {
        "clientVersion": clientVersion,
        "clientId": clientId,
        "mbrCmSq": mbrCmSq,
      };
}
