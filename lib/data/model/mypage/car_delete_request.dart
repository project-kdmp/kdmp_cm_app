import 'package:kdmp_cm_app/data/constant/client_info.dart';

class CarDeleteRequest {
  String clientVersion = ClientInfo.clientVersion;
  String clientId = ClientInfo.clientId;
  int mbrSq;
  String carNumId;

  CarDeleteRequest({
    required this.mbrSq,
    required this.carNumId,
  });

  factory CarDeleteRequest.fromJson(Map<String, dynamic> json) => CarDeleteRequest(
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
