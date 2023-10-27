import 'package:kdmp_cm_app/data/constant/client_info.dart';

class PlaceModifyRequest {
  String clientVersion = ClientInfo.clientVersion;
  String clientId = ClientInfo.clientId;
  int fplaceSq;
  String fplaceNicknm;
  String fplacePlaceNm;
  String fplaceAddress;
  double gpsLat;
  double gpsLong;

  PlaceModifyRequest({
    required this.fplaceSq,
    required this.fplaceNicknm,
    required this.fplacePlaceNm,
    required this.fplaceAddress,
    required this.gpsLat,
    required this.gpsLong,
  });

  factory PlaceModifyRequest.fromJson(Map<String, dynamic> json) => PlaceModifyRequest(
        fplaceSq: json["fplaceSq"],
        fplaceNicknm: json["fplaceNicknm"],
        fplacePlaceNm: json["fplacePlaceNm"],
        fplaceAddress: json["fplaceAddress"],
        gpsLat: json["gpsLat"],
        gpsLong: json["gpsLong"],
      );

  Map<String, dynamic> toJson() => {
        "clientVersion": clientVersion,
        "clientId": clientId,
        "fplaceSq": fplaceSq,
        "fplaceNicknm": fplaceNicknm,
        "fplacePlaceNm": fplacePlaceNm,
        "fplaceAddress": fplaceAddress,
        "gpsLat": gpsLat,
        "gpsLong": gpsLong,
      };
}
