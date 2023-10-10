class NoticeDetailRequest {
  String clientVersion;
  String clientId;
  int notiSq;

  NoticeDetailRequest({
    this.clientVersion = "",
    this.clientId = "",
    required this.notiSq,
  });

  factory NoticeDetailRequest.fromJson(Map<String, dynamic> json) {
    return NoticeDetailRequest(
      clientVersion: json["clientVersion"] as String,
      clientId: json["clientId"] as String,
      notiSq: json["notiSq"] as int,
    );
  }

  Map<String, dynamic> toJson() => {
        "clientVersion": clientVersion,
        "clientId": clientId,
        "notiSq": notiSq,
      };
}
