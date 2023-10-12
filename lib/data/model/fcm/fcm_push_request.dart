class FCMPushRequest {
  String clientVersion;
  String clientId;
  int mbrSqTarget;
  String title;
  String body;
  String? type;

  FCMPushRequest({
    this.clientVersion = "",
    this.clientId = "",
    required this.mbrSqTarget,
    required this.title,
    required this.body,
    this.type,
  });

  factory FCMPushRequest.fromJson(Map<String, dynamic> json) => FCMPushRequest(
        clientVersion: json["clientVersion"],
        clientId: json["clientId"],
        mbrSqTarget: json["mbrSqTarget"],
        title: json["title"],
        body: json["body"],
        type: json["type"],
      );

  Map<String, dynamic> toJson() => {
        "clientVersion": clientVersion,
        "clientId": clientId,
        "mbrSqTarget": mbrSqTarget,
        "title": title,
        "body": body,
        "type": type,
      };
}
