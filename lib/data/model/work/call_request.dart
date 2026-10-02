import 'dart:convert';

import 'package:kdmp_cm_app/data/model/common/stopover_model.dart';

import 'package:kdmp_cm_app/data/constant/client_info.dart';

class CallRequest {
  String clientVersion = ClientInfo.clientVersion;
  String clientId = ClientInfo.clientId;
  int mbrCmSq;
  String paymKind;
  String carNumId;

  // String drvReqNm;
  String drvReqSt;
  String reqRegDt;
  String? drvReserveDt;

  // String drvEndDt;
  // String drvStartDt;
  String reqStartAddress;
  String reqStartPlaceNm;
  String reqEndAddress;
  String reqEndPlaceNm;
  List<StopOver> stopOverLst;
  int drvPaymPrice;
  int drvDistance;

  // String reqAsk;
  double gpsStartLat;
  double gpsStartLong;
  double gpsEndLat;
  double gpsEndLong;

  String tossCardId;

  /// 지정 호출한 기사. 지정하지 않으면 null 이고 서버가 일반 배차로 처리한다
  int? appointDmSq;

  CallRequest({
    required this.mbrCmSq,
    required this.paymKind,
    required this.carNumId,
    // required this.drvReqNm,
    required this.drvReqSt,
    required this.reqRegDt,
    this.drvReserveDt,
    // required this.drvEndDt,
    // required this.drvStartDt,
    required this.reqStartAddress,
    required this.reqStartPlaceNm,
    required this.reqEndAddress,
    required this.reqEndPlaceNm,
    required this.stopOverLst,
    required this.drvPaymPrice,
    required this.drvDistance,
    // required this.reqAsk,
    required this.gpsStartLat,
    required this.gpsStartLong,
    required this.gpsEndLat,
    required this.gpsEndLong,
    required this.tossCardId,
    this.appointDmSq,
  });

  factory CallRequest.fromJson(Map<String, dynamic> json) => CallRequest(
        mbrCmSq: json["mbrCmSq"],
        paymKind: json["paymKind"],
        carNumId: json["carNumId"],
        // drvReqNm: json["drvReqNm"],
        drvReqSt: json["drvReqSt"],
        reqRegDt: json["reqRegDt"],
        drvReserveDt: json["drvReserveDt"],
        // drvEndDt: json["drvEndDt"],
        // drvStartDt: json["drvStartDt"],
        reqStartAddress: json["reqStartAddress"],
        reqStartPlaceNm: json["reqStartPlaceNm"],
        reqEndAddress: json["reqEndAddress"],
        reqEndPlaceNm: json["reqEndPlaceNm"],
        stopOverLst: json["stopOverLst"] != null && json["stopOverLst"] != "" ? List<StopOver>.from(jsonDecode(json["stopOverLst"]).map((x) => StopOver.fromJson(x))) : List.empty(),
        drvPaymPrice: json["drvPaymPrice"],
        drvDistance: json["drvDistance"],
        // reqAsk: json["reqAsk"],
        gpsStartLat: json["gpsStartLat"],
        gpsStartLong: json["gpsStartLong"],
        gpsEndLat: json["gpsEndLat"],
        gpsEndLong: json["gpsEndLong"],
        tossCardId: json["tossCardId"],
        appointDmSq: json["appointDmSq"],
      );

  Map<String, dynamic> toJson() => {
        "clientVersion": clientVersion,
        "clientId": clientId,
        "mbrCmSq": mbrCmSq,
        "paymKind": paymKind,
        "carNumId": carNumId,
        // "drvReqNm": drvReqNm,
        "drvReqSt": drvReqSt,
        "reqRegDt": reqRegDt,
        "drvReserveDt": drvReserveDt,
        // "drvEndDt": drvEndDt,
        // "drvStartDt": drvStartDt,
        "reqStartAddress": reqStartAddress,
        "reqStartPlaceNm": reqStartPlaceNm,
        "reqEndAddress": reqEndAddress,
        "reqEndPlaceNm": reqEndPlaceNm,
        "stopOverLst": stopOverLst.isNotEmpty ? jsonEncode(stopOverLst) : "",
        "drvPaymPrice": drvPaymPrice,
        "drvDistance": drvDistance,
        // "reqAsk": reqAsk,
        "gpsStartLat": gpsStartLat,
        "gpsStartLong": gpsStartLong,
        "gpsEndLat": gpsEndLat,
        "gpsEndLong": gpsEndLong,
        "tossCardId": tossCardId,
        "appointDmSq": appointDmSq,
      };
}
