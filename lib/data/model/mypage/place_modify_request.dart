class PlaceModifyRequest {
  String clientVersion;
  String clientId;
  int fplaceSq;
  String fplaceNicknm;
  String fplaceAddress;

  PlaceModifyRequest({
    this.clientVersion = "",
    this.clientId = "",
    required this.fplaceSq,
    required this.fplaceNicknm,
    required this.fplaceAddress,
  });

  factory PlaceModifyRequest.fromJson(Map<String, dynamic> json) => PlaceModifyRequest(
        clientVersion: json["clientVersion"],
        clientId: json["clientId"],
        fplaceSq: json["fplaceSq"],
        fplaceNicknm: json["fplaceNicknm"],
        fplaceAddress: json["fplaceAddress"],
      );

  Map<String, dynamic> toJson() => {
        "clientVersion": clientVersion,
        "clientId": clientId,
        "fplaceSq": fplaceSq,
        "fplaceNicknm": fplaceNicknm,
        "fplaceAddress": fplaceAddress,
      };
}
