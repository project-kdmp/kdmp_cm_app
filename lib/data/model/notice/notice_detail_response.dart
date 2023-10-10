class NoticeDetailResponse {
  String serverVersion;
  String serverId;
  int notiSq;
  String? notiTitle;
  String? notiContent;
  String? notiContentHtml;
  String? createDt;

  NoticeDetailResponse({
    required this.serverVersion,
    required this.serverId,
    required this.notiSq,
    this.notiTitle,
    this.notiContent,
    this.notiContentHtml,
    this.createDt,
  });

  factory NoticeDetailResponse.fromJson(Map<String, dynamic> json) => NoticeDetailResponse(
        serverVersion: json["serverVersion"],
        serverId: json["serverId"],
        notiSq: json["notiSq"],
        notiTitle: json["notiTitle"],
        notiContent: json["notiContent"],
        notiContentHtml: json["notiContentHtml"],
        createDt: json["createDt"],
      );

  Map<String, dynamic> toJson() => {
        "serverVersion": serverVersion,
        "serverId": serverId,
        "notiSq": notiSq,
        "notiTitle": notiTitle,
        "notiContent": notiContent,
        "notiContentHtml": notiContentHtml,
        "createDt": createDt,
      };
}
