class PlaceListResponse {
  String serverVersion;
  String serverId;
  List<Place> resultList;

  PlaceListResponse({
    required this.serverVersion,
    required this.serverId,
    required this.resultList,
  });

  factory PlaceListResponse.fromJson(Map<String, dynamic> json) => PlaceListResponse(
        serverVersion: json["serverVersion"],
        serverId: json["serverId"],
        resultList: List<Place>.from(json["resultList"].map((x) => Place.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "serverVersion": serverVersion,
        "serverId": serverId,
        "resultList": List<dynamic>.from(resultList.map((x) => x.toJson())),
      };
}

class Place {
  int fplaceSq;
  String fplaceNicknm;
  String fplaceAddress;
  String fplacePlaceNm;
  double gpsLat;
  double gpsLong;

  Place({
    required this.fplaceSq,
    required this.fplaceNicknm,
    required this.fplaceAddress,
    required this.fplacePlaceNm,
    required this.gpsLat,
    required this.gpsLong,
  });

  factory Place.fromJson(Map<String, dynamic> json) => Place(
        fplaceSq: json["fplaceSq"],
        fplaceNicknm: json["fplaceNicknm"],
        fplaceAddress: json["fplaceAddress"],
        fplacePlaceNm: json["fplacePlaceNm"],
        gpsLat: json["gpsLat"],
        gpsLong: json["gpsLong"],
      );

  Map<String, dynamic> toJson() => {
        "fplaceSq": fplaceSq,
        "fplaceNicknm": fplaceNicknm,
        "fplaceAddress": fplaceAddress,
        "fplacePlaceNm": fplacePlaceNm,
        "gpsLat": gpsLat,
        "gpsLong": gpsLong,
      };
}
