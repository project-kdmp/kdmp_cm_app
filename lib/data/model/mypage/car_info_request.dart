class CarInfoRequest {
  String clientVersion;
  String clientId;
  int mbrSq;
  String carNumId;

  CarInfoRequest({
    this.clientVersion = "",
    this.clientId = "",
    required this.mbrSq,
    required this.carNumId,
  });

  factory CarInfoRequest.fromJson(Map<String, dynamic> json) => CarInfoRequest(
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
