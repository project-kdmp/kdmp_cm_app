import 'package:kdmp_cm_app/data/model/common/pagenation_model.dart';

class InquiryListResponse {
  String serverVersion;
  String serverId;
  Pagination pagination;
  List<Inquiry> resultList;

  InquiryListResponse({
    required this.serverVersion,
    required this.serverId,
    required this.pagination,
    required this.resultList,
  });

  factory InquiryListResponse.fromJson(Map<String, dynamic> json) => InquiryListResponse(
        serverVersion: json["serverVersion"],
        serverId: json["serverId"],
        pagination: Pagination.fromJson(json["pagination"]),
        resultList: List<Inquiry>.from(json["resultList"].map((x) => Inquiry.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "serverVersion": serverVersion,
        "serverId": serverId,
        "pagination": pagination.toJson(),
        "resultList": List<dynamic>.from(resultList.map((x) => x.toJson())),
      };
}

class Inquiry {
  int inqSq;
  String? inqAskTitle;
  String? inqRtnSt;
  String? createDt;

  Inquiry({
    required this.inqSq,
    this.inqAskTitle,
    this.inqRtnSt,
    this.createDt,
  });

  factory Inquiry.fromJson(Map<String, dynamic> json) => Inquiry(
        inqSq: json["inqSq"],
        inqAskTitle: json["inqAskTitle"],
        inqRtnSt: json["inqRtnSt"],
        createDt: json["createDt"],
      );

  Map<String, dynamic> toJson() => {
        "inqSq": inqSq,
        "inqAskTitle": inqAskTitle,
        "inqRtnSt": inqRtnSt,
        "createDt": createDt,
      };
}
