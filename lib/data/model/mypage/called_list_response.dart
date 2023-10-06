import 'dart:convert';

import 'package:kdmp_cm_app/data/model/common/pagenation_model.dart';
import 'package:kdmp_cm_app/data/model/common/stopover_model.dart';

class CalledListResponse {
  String serverVersion;
  String serverId;
  Pagination pagination;
  List<Called> resultList;

  CalledListResponse({
    required this.serverVersion,
    required this.serverId,
    required this.pagination,
    required this.resultList,
  });

  factory CalledListResponse.fromJson(Map<String, dynamic> json) => CalledListResponse(
        serverVersion: json["serverVersion"],
        serverId: json["serverId"],
        pagination: Pagination.fromJson(json["pagination"]),
        resultList: List<Called>.from(json["resultList"].map((x) => Called.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "serverVersion": serverVersion,
        "serverId": serverId,
        "pagination": pagination.toJson(),
        "resultList": List<dynamic>.from(resultList.map((x) => x.toJson())),
      };
}

class Called {
  int drvReqSq;
  String? drvStartDt;
  String? drvEndDt;
  String? drvReqSt;
  String? reqStartAddress;
  List<StopOver> stopOverLst;
  String? reqEndAddress;
  int? drvPaymPrice;
  String? payCardInfo;

  Called({
    required this.drvReqSq,
    this.drvStartDt,
    this.drvEndDt,
    this.drvReqSt,
    this.reqStartAddress,
    required this.stopOverLst,
    this.reqEndAddress,
    this.drvPaymPrice,
    this.payCardInfo,
  });

  factory Called.fromJson(Map<String, dynamic> json) => Called(
        drvReqSq: json["drvReqSq"],
        drvStartDt: json["drvStartDt"],
        drvEndDt: json["drvEndDt"],
        drvReqSt: json["drvReqSt"],
        reqStartAddress: json["reqStartAddress"],
        stopOverLst: json["stopOverLst"] != null && json["stopOverLst"] != "" ? List<StopOver>.from(jsonDecode(json["stopOverLst"]).map((x) => StopOver.fromJson(x))) : List.empty(),
        reqEndAddress: json["reqEndAddress"],
        drvPaymPrice: json["drvPaymPrice"],
        payCardInfo: json["payCardInfo"],
      );

  Map<String, dynamic> toJson() => {
        "drvReqSq": drvReqSq,
        "drvStartDt": drvStartDt,
        "drvEndDt": drvEndDt,
        "drvReqSt": drvReqSt,
        "reqStartAddress": reqStartAddress,
        "stopOverLst": stopOverLst.isNotEmpty ? List<dynamic>.from(stopOverLst.map((x) => x.toJson())) : "",
        "reqEndAddress": reqEndAddress,
        "drvPaymPrice": drvPaymPrice,
        "payCardInfo": payCardInfo,
      };
}
