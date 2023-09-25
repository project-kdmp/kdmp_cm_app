class CarDeleteRequest {
  String clientVersion;
  String clientId;
  int mbrSq;
  String carNumId;

  CarDeleteRequest({
    this.clientVersion = "",
    this.clientId = "",
    required this.mbrSq,
    required this.carNumId,
  });

  factory CarDeleteRequest.fromJson(Map<String, dynamic> json) => CarDeleteRequest(
        clientVersion: json["clientVersion"],
        clientId: json["clientId"],
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
