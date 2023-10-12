class FCMTokenRequest {
  String clientVersion;
  String clientId;
  int mbrSq;
  String mbrFcmToken;

  FCMTokenRequest({
    this.clientVersion = "",
    this.clientId = "",
    required this.mbrSq,
    required this.mbrFcmToken,
  });

  factory FCMTokenRequest.fromJson(Map<String, dynamic> json) => FCMTokenRequest(
        clientVersion: json["clientVersion"],
        clientId: json["clientId"],
        mbrSq: json["mbrSq"],
        mbrFcmToken: json["mbrFcmToken"],
      );

  Map<String, dynamic> toJson() => {
        "clientVersion": clientVersion,
        "clientId": clientId,
        "mbrSq": mbrSq,
        "mbrFcmToken": mbrFcmToken,
      };
}
