class PlaceAddRequest {
  String clientVersion;
  String clientId;
  int mbrSq;
  String fplaceNicknm;
  String fplacePlaceNm;
  String fplaceAddress;
  double gpsLat;
  double gpsLong;

  PlaceAddRequest({
    this.clientVersion = "",
    this.clientId = "",
    required this.mbrSq,
    required this.fplaceNicknm,
    required this.fplacePlaceNm,
    required this.fplaceAddress,
    required this.gpsLat,
    required this.gpsLong,
  });

  factory PlaceAddRequest.fromJson(Map<String, dynamic> json) => PlaceAddRequest(
        clientVersion: json["clientVersion"],
        clientId: json["clientId"],
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
