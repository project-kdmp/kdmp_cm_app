import 'package:kdmp_cm_app/data/constant/client_info.dart';

import 'package:kdmp_cm_app/data/constant/client_info.dart';

class PayRequest {
  String clientVersion = ClientInfo.clientVersion;
  String clientId = ClientInfo.clientId;
  int mbrSq;
  int drvReqSq;
  int price;
  String paymKind;
  String carNumId;

  PayRequest({
    required this.mbrSq,
    required this.drvReqSq,
    required this.price,
    required this.paymKind,
    required this.carNumId,
  });

  factory PayRequest.fromJson(Map<String, dynamic> json) => PayRequest(
        mbrSq: json["mbrSq"],
        drvReqSq: json["drvReqSq"],
        price: json["price"],
        paymKind: json["paymKind"],
        carNumId: json["carNumId"],
      );

  Map<String, dynamic> toJson() => {
        "clientVersion": clientVersion,
        "clientId": clientId,
        "mbrSq": mbrSq,
        "drvReqSq": drvReqSq,
        "price": price,
        "paymKind": paymKind,
        "carNumId": carNumId,
      };
}
