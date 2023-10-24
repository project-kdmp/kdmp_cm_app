import 'dart:convert';

import 'package:kdmp_cm_app/data/model/common/stopover_model.dart';

class CallListResponse {
  String serverVersion;
  String serverId;
  List<Call> resultList;

  CallListResponse({
    required this.serverVersion,
    required this.serverId,
    required this.resultList,
  });

  factory CallListResponse.fromJson(Map<String, dynamic> json) => CallListResponse(
        serverVersion: json["serverVersion"],
        serverId: json["serverId"],
        resultList: List<Call>.from(json["resultList"].map((x) => Call.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "serverVersion": serverVersion,
        "serverId": serverId,
        "resultList": List<dynamic>.from(resultList.map((x) => x.toJson())),
      };
}

class Call {
  int drvReqSq;
  String? reqRegDt;
  String? drvStartDt;
  String? drvEndDt;
  String? drvReqSt;
  String reqStartAddress;
  String reqStartPlaceNm;
  List<StopOver> stopOverLst;
  String reqEndAddress;
  String reqEndPlaceNm;
  int? drvPaymPrice;
  String? paymKind;

  Call({
    required this.drvReqSq,
    this.reqRegDt,
    this.drvStartDt,
    this.drvEndDt,
    this.drvReqSt,
    required this.reqStartAddress,
    required this.reqStartPlaceNm,
    required this.stopOverLst,
    required this.reqEndAddress,
    required this.reqEndPlaceNm,
    this.drvPaymPrice,
    this.paymKind,
  });

  factory Call.fromJson(Map<String, dynamic> json) => Call(
        drvReqSq: json["drvReqSq"],
        reqRegDt: json["reqRegDt"],
        drvStartDt: json["drvStartDt"],
        drvEndDt: json["drvEndDt"],
        drvReqSt: json["drvReqSt"],
        reqStartAddress: json["reqStartAddress"],
        reqStartPlaceNm: json["reqStartPlaceNm"],
        stopOverLst: json["stopOverLst"] != null && json["stopOverLst"] != "" ? List<StopOver>.from(jsonDecode(json["stopOverLst"]).map((x) => StopOver.fromJson(x))) : List.empty(),
        reqEndAddress: json["reqEndAddress"],
        reqEndPlaceNm: json["reqEndPlaceNm"],
        drvPaymPrice: json["drvPaymPrice"],
        paymKind: json["paymKind"],
      );

  Map<String, dynamic> toJson() => {
        "drvReqSq": drvReqSq,
        "reqRegDt": reqRegDt,
        "drvStartDt": drvStartDt,
        "drvEndDt": drvEndDt,
        "drvReqSt": drvReqSt,
        "reqStartAddress": reqStartAddress,
        "reqStartPlaceNm": reqStartPlaceNm,
        "stopOverLst": stopOverLst.isNotEmpty ? jsonEncode(stopOverLst) : "",
        "reqEndAddress": reqEndAddress,
        "reqEndPlaceNm": reqEndPlaceNm,
        "drvPaymPrice": drvPaymPrice,
        "paymKind": paymKind,
      };
}
