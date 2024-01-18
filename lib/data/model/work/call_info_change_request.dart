import 'dart:convert';

import 'package:kdmp_cm_app/data/constant/client_info.dart';
import 'package:kdmp_cm_app/data/model/common/stopover_model.dart';

class CallInfoChangeRequest {
  String clientVersion = ClientInfo.clientVersion;
  String clientId = ClientInfo.clientId;
  int drvReqSq;
  String reqEndAddress;
  String reqEndPlaceNm;
  List<StopOver> stopOverLst;
  int drvDistance;
  int drvPaymPrice;
  double gpsEndLat;
  double gpsEndLong;

  CallInfoChangeRequest({
    required this.drvReqSq,
    required this.reqEndAddress,
    required this.reqEndPlaceNm,
    required this.stopOverLst,
    required this.drvDistance,
    required this.drvPaymPrice,
    required this.gpsEndLat,
    required this.gpsEndLong,
  });

  factory CallInfoChangeRequest.fromJson(Map<String, dynamic> json) => CallInfoChangeRequest(
        drvReqSq: json["drvReqSq"],
        reqEndAddress: json["reqEndAddress"],
        reqEndPlaceNm: json["reqEndPlaceNm"],
        stopOverLst: json["stopOverLst"] != null && json["stopOverLst"] != "" ? List<StopOver>.from(jsonDecode(json["stopOverLst"]).map((x) => StopOver.fromJson(x))) : List.empty(),
        drvDistance: json["drvDistance"],
        drvPaymPrice: json["drvPaymPrice"],
        gpsEndLat: json["gpsEndLat"],
        gpsEndLong: json["gpsEndLong"],
      );

  Map<String, dynamic> toJson() => {
        "clientVersion": clientVersion,
        "clientId": clientId,
        "drvReqSq": drvReqSq,
        "reqEndAddress": reqEndAddress,
        "reqEndPlaceNm": reqEndPlaceNm,
        "stopOverLst": stopOverLst.isNotEmpty ? jsonEncode(stopOverLst) : "",
        "drvDistance": drvDistance,
        "drvPaymPrice": drvPaymPrice,
        "gpsEndLat": gpsEndLat,
        "gpsEndLong": gpsEndLong,
      };
}
