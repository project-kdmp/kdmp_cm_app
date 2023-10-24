import 'dart:convert';

import 'package:kdmp_cm_app/data/model/common/stopover_model.dart';

class CalledDetailResponse {
  String serverVersion;
  String serverId;
  int drvReqSq;
  String? reqRegDt;
  String? drvStartDt;
  String? drvEndDt;
  String? drvReqSt;
  String reqStartAddress;
  String reqStartPlaceNm;
  String reqEndAddress;
  String reqEndPlaceNm;
  List<StopOver> stopOverLst;
  int? drvPaymPrice;
  String? payCardInfo;
  String? paymKind;
  String? dmMbrNm;
  String? dmMbrId;
  int? mbrDmSq;
  String? carNumId;
  String? drvReqEndId;
  String? reviewContent;
  int? starPoint;

  CalledDetailResponse({
    required this.serverVersion,
    required this.serverId,
    required this.drvReqSq,
    this.reqRegDt,
    this.drvStartDt,
    this.drvEndDt,
    this.drvReqSt,
    required this.reqStartAddress,
    required this.reqStartPlaceNm,
    required this.reqEndAddress,
    required this.reqEndPlaceNm,
    required this.stopOverLst,
    this.drvPaymPrice,
    this.payCardInfo,
    this.paymKind,
    this.dmMbrNm,
    this.dmMbrId,
    this.mbrDmSq,
    this.carNumId,
    this.drvReqEndId,
    this.reviewContent,
    this.starPoint,
  });

  factory CalledDetailResponse.fromJson(Map<String, dynamic> json) => CalledDetailResponse(
        serverVersion: json["serverVersion"],
        serverId: json["serverId"],
        drvReqSq: json["drvReqSq"],
        reqRegDt: json["reqRegDt"],
        drvStartDt: json["drvStartDt"],
        drvEndDt: json["drvEndDt"],
        drvReqSt: json["drvReqSt"],
        reqStartAddress: json["reqStartAddress"],
        reqStartPlaceNm: json["reqStartPlaceNm"],
        reqEndAddress: json["reqEndAddress"],
        reqEndPlaceNm: json["reqEndPlaceNm"],
        stopOverLst: json["stopOverLst"] != null && json["stopOverLst"] != "" ? List<StopOver>.from(jsonDecode(json["stopOverLst"]).map((x) => StopOver.fromJson(x))) : List.empty(),
        drvPaymPrice: json["drvPaymPrice"],
        payCardInfo: json["payCardInfo"],
        paymKind: json["paymKind"],
        dmMbrNm: json["dmMbrNm"],
        dmMbrId: json["dmMbrId"],
        mbrDmSq: json["mbrDmSq"],
        carNumId: json["carNumId"],
        drvReqEndId: json["drvReqEndId"],
        reviewContent: json["reviewContent"],
        starPoint: json["starPoint"],
      );

  Map<String, dynamic> toJson() => {
        "serverVersion": serverVersion,
        "serverId": serverId,
        "drvReqSq": drvReqSq,
        "reqRegDt": reqRegDt,
        "drvStartDt": drvStartDt,
        "drvEndDt": drvEndDt,
        "drvReqSt": drvReqSt,
        "reqStartAddress": reqStartAddress,
        "reqStartPlaceNm": reqStartPlaceNm,
        "reqEndAddress": reqEndAddress,
        "reqEndPlaceNm": reqEndPlaceNm,
        "stopOverLst": stopOverLst.isNotEmpty ? jsonEncode(stopOverLst) : "",
        "drvPaymPrice": drvPaymPrice,
        "payCardInfo": payCardInfo,
        "paymKind": paymKind,
        "dmMbrNm": dmMbrNm,
        "dmMbrId": dmMbrId,
        "mbrDmSq": mbrDmSq,
        "carNumId": carNumId,
        "drvReqEndId": drvReqEndId,
        "reviewContent": reviewContent,
        "starPoint": starPoint,
      };
}
