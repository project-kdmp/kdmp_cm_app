class PlaceModifyRequest {
  String clientVersion;
  String clientId;
  int fplaceSq;
  String fplaceNicknm;
  String fplacePlaceNm;
  String fplaceAddress;
  double gpsLat;
  double gpsLong;

  PlaceModifyRequest({
    this.clientVersion = "",
    this.clientId = "",
    required this.fplaceSq,
    required this.fplaceNicknm,
    required this.fplacePlaceNm,
    required this.fplaceAddress,
    required this.gpsLat,
    required this.gpsLong,
  });

  factory PlaceModifyRequest.fromJson(Map<String, dynamic> json) => PlaceModifyRequest(
        clientVersion: json["clientVersion"],
        clientId: json["clientId"],
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
