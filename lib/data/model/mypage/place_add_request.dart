import 'package:kdmp_cm_app/data/constant/client_info.dart';

class PlaceAddRequest {
  String clientVersion = ClientInfo.clientVersion;
  String clientId = ClientInfo.clientId;
  int mbrSq;
  String fplaceNicknm;
  String fplacePlaceNm;
  String fplaceAddress;
  double gpsLat;
  double gpsLong;

  PlaceAddRequest({
    required this.mbrSq,
    required this.fplaceNicknm,
    required this.fplacePlaceNm,
    required this.fplaceAddress,
    required this.gpsLat,
    required this.gpsLong,
  });

  factory PlaceAddRequest.fromJson(Map<String, dynamic> json) => PlaceAddRequest(
        mbrSq: json["mbrSq"],
        fplaceNicknm: json["fplaceNicknm"],
        fplacePlaceNm: json["fplacePlaceNm"],
        fplaceAddress: json["fplaceAddress"],
        gpsLat: json["gpsLat"],
        gpsLong: json["gpsLong"],
      );

  Map<String, dynamic> toJson() => {
        "clientVersion": clientVersion,
        "clientId": clientId,
        "mbrSq": mbrSq,
        "fplaceNicknm": fplaceNicknm,
        "fplacePlaceNm": fplacePlaceNm,
        "fplaceAddress": fplaceAddress,
        "gpsLat": gpsLat,
        "gpsLong": gpsLong,
      };
}
