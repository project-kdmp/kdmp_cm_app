class PlaceResponse {
  String serverVersion;
  String serverId;
  int fplaceSq;

  PlaceResponse({
    required this.serverVersion,
    required this.serverId,
    required this.fplaceSq,
  });

  factory PlaceResponse.fromJson(Map<String, dynamic> json) => PlaceResponse(
        serverVersion: json["serverVersion"],
        serverId: json["serverId"],
        fplaceSq: json["fplaceSq"],
      );

  Map<String, dynamic> toJson() => {
        "serverVersion": serverVersion,
        "serverId": serverId,
        "fplaceSq": fplaceSq,
      };
}
