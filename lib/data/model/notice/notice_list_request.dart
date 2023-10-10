class NoticeListRequest {
  String clientVersion;
  String clientId;
  int page;
  int pageSize;

  NoticeListRequest({
    this.clientVersion = "",
    this.clientId = "",
    required this.page,
    required this.pageSize,
  });

  factory NoticeListRequest.fromJson(Map<String, dynamic> json) {
    return NoticeListRequest(
      clientVersion: json["clientVersion"] as String,
      clientId: json["clientId"] as String,
      page: json["page"] as int,
      pageSize: json["pageSize"] as int,
    );
  }

  Map<String, dynamic> toJson() => {
        "clientVersion": clientVersion,
        "clientId": clientId,
        "page": page,
        "pageSize": pageSize,
      };
}
