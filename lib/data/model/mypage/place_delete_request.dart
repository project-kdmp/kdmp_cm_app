import 'package:kdmp_cm_app/data/constant/client_info.dart';

class PlaceDeleteRequest {
  String clientVersion = ClientInfo.clientVersion;
  String clientId = ClientInfo.clientId;
  int fplaceSq;

  PlaceDeleteRequest({
    required this.fplaceSq,
  });

  factory PlaceDeleteRequest.fromJson(Map<String, dynamic> json) => PlaceDeleteRequest(
        fplaceSq: json["fplaceSq"],
      );

  Map<String, dynamic> toJson() => {
        "clientVersion": clientVersion,
        "clientId": clientId,
        "fplaceSq": fplaceSq,
      };
}
