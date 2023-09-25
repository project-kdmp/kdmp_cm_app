class PlaceAddRequest {
  String clientVersion;
  String clientId;
  int mbrSq;
  String fplaceNicknm;
  String fplaceAddress;

  PlaceAddRequest({
    this.clientVersion = "",
    this.clientId = "",
    required this.mbrSq,
    required this.fplaceNicknm,
    required this.fplaceAddress,
  });

  factory PlaceAddRequest.fromJson(Map<String, dynamic> json) => PlaceAddRequest(
        clientVersion: json["clientVersion"],
        clientId: json["clientId"],
        mbrSq: json["mbrSq"],
        fplaceNicknm: json["fplaceNicknm"],
        fplaceAddress: json["fplaceAddress"],
      );

  Map<String, dynamic> toJson() => {
        "clientVersion": clientVersion,
        "clientId": clientId,
        "mbrSq": mbrSq,
        "fplaceNicknm": fplaceNicknm,
        "fplaceAddress": fplaceAddress,
      };
}
