import 'package:kdmp_cm_app/data/model/common/pagenation_model.dart';

class NoticeListResponse {
  String serverVersion;
  String serverId;
  Pagination pagination;
  List<Notice> resultList;

  NoticeListResponse({
    required this.serverVersion,
    required this.serverId,
    required this.pagination,
    required this.resultList,
  });

  factory NoticeListResponse.fromJson(Map<String, dynamic> json) => NoticeListResponse(
        serverVersion: json["serverVersion"],
        serverId: json["serverId"],
        pagination: Pagination.fromJson(json["pagination"]),
        resultList: List<Notice>.from(json["resultList"].map((x) => Notice.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "serverVersion": serverVersion,
        "serverId": serverId,
        "pagination": pagination.toJson(),
        "resultList": List<dynamic>.from(resultList.map((x) => x.toJson())),
      };
}

class Notice {
  int notiSq;
  String? notiTitle;
  String? admNotiFixYn;
  String? createDt;

  Notice({
    required this.notiSq,
    this.notiTitle,
    this.admNotiFixYn,
    this.createDt,
  });

  factory Notice.fromJson(Map<String, dynamic> json) => Notice(
        notiSq: json["notiSq"],
        notiTitle: json["notiTitle"],
        admNotiFixYn: json["admNotiFixYn"],
        createDt: json["createDt"],
      );

  Map<String, dynamic> toJson() => {
        "notiSq": notiSq,
        "notiTitle": notiTitle,
        "admNotiFixYn": admNotiFixYn,
        "createDt": createDt,
      };
}
