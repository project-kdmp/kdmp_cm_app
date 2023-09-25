class PlaceDeleteRequest {
  String clientVersion;
  String clientId;
  int fplaceSq;

  PlaceDeleteRequest({
    this.clientVersion = "",
    this.clientId = "",
    required this.fplaceSq,
  });

  factory PlaceDeleteRequest.fromJson(Map<String, dynamic> json) => PlaceDeleteRequest(
        clientVersion: json["clientVersion"],
        clientId: json["clientId"],
        fplaceSq: json["fplaceSq"],
      );

  Map<String, dynamic> toJson() => {
        "clientVersion": clientVersion,
        "clientId": clientId,
        "fplaceSq": fplaceSq,
      };
}
