import 'package:kdmp_cm_app/data/constant/client_info.dart';

class CarAddRequest {
  String clientVersion = ClientInfo.clientVersion;
  String clientId = ClientInfo.clientId;
  int mbrSq;
  String carNumId;

  CarAddRequest({
    required this.mbrSq,
    required this.carNumId,
  });

  factory CarAddRequest.fromJson(Map<String, dynamic> json) => CarAddRequest(
        mbrSq: json["mbrSq"],
        carNumId: json["carNumId"],
      );

  Map<String, dynamic> toJson() => {
        "clientVersion": clientVersion,
        "clientId": clientId,
        "mbrSq": mbrSq,
        "carNumId": carNumId,
      };
}
