import 'package:kdmp_cm_app/data/constant/client_info.dart';

class CallFeeChangeRequest {
  String clientVersion = ClientInfo.clientVersion;
  String clientId = ClientInfo.clientId;
  int mbrSq;
  int drvReqSq;
  int price;
  int beforPrice;

  CallFeeChangeRequest({
    required this.mbrSq,
    required this.drvReqSq,
    required this.price,
    required this.beforPrice,
  });

  factory CallFeeChangeRequest.fromJson(Map<String, dynamic> json) => CallFeeChangeRequest(
        mbrSq: json["mbrSq"],
        drvReqSq: json["drvReqSq"],
        price: json["price"],
        beforPrice: json["beforPrice"],
      );

  Map<String, dynamic> toJson() => {
        "clientVersion": clientVersion,
        "clientId": clientId,
        "mbrSq": mbrSq,
        "drvReqSq": drvReqSq,
        "price": price,
        "beforPrice": beforPrice,
      };
}
