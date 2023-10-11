class InquiryListRequest {
  String clientVersion;
  String clientId;
  int cmMbrSq;
  int page;
  int pageSize;

  InquiryListRequest({
    this.clientVersion = "",
    this.clientId = "",
    required this.cmMbrSq,
    required this.page,
    required this.pageSize,
  });

  factory InquiryListRequest.fromJson(Map<String, dynamic> json) {
    return InquiryListRequest(
      clientVersion: json["clientVersion"] as String,
      clientId: json["clientId"] as String,
      cmMbrSq: json["cmMbrSq"] as int,
      page: json["page"] as int,
      pageSize: json["pageSize"] as int,
    );
  }

  Map<String, dynamic> toJson() => {
        "clientVersion": clientVersion,
        "clientId": clientId,
        "cmMbrSq": cmMbrSq,
        "page": page,
        "pageSize": pageSize,
      };
}
