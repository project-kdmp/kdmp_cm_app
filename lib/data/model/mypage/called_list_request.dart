class CalledListRequest {
  String clientVersion;
  String clientId;
  int mbrCmSq;
  int page;
  int pageSize;

  CalledListRequest({
    this.clientVersion = "",
    this.clientId = "",
    required this.mbrCmSq,
    required this.page,
    required this.pageSize,
  });

  factory CalledListRequest.fromJson(Map<String, dynamic> json) => CalledListRequest(
        clientVersion: json["clientVersion"],
        clientId: json["clientId"],
        mbrCmSq: json["mbrCmSq"],
        page: json["page"],
        pageSize: json["pageSize"],
      );

  Map<String, dynamic> toJson() => {
        "clientVersion": clientVersion,
        "clientId": clientId,
        "mbrCmSq": mbrCmSq,
        "page": page,
        "pageSize": pageSize,
      };
}
