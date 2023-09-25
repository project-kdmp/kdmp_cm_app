class CarAddRequest {
  String clientVersion;
  String clientId;
  int mbrSq;
  String carNumId;

  CarAddRequest({
    this.clientVersion = "",
    this.clientId = "",
    required this.mbrSq,
    required this.carNumId,
  });

  factory CarAddRequest.fromJson(Map<String, dynamic> json) => CarAddRequest(
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
