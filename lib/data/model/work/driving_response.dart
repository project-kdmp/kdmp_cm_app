class DrivingResponse {
  String serverVersion;
  String serverId;
  int? drvReqSq;
  bool driving;

  DrivingResponse({
    required this.serverVersion,
    required this.serverId,
    required this.drvReqSq,
    required this.driving,
  });

  factory DrivingResponse.fromJson(Map<String, dynamic> json) => DrivingResponse(
        serverVersion: json["serverVersion"],
        serverId: json["serverId"],
        drvReqSq: json["drvReqSq"],
        driving: json["driving"],
      );

  Map<String, dynamic> toJson() => {
        "serverVersion": serverVersion,
        "serverId": serverId,
        "drvReqSq": drvReqSq,
        "driving": driving,
      };
}
