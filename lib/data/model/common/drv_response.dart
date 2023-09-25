class DrvResponse {
  String serverVersion;
  String serverId;
  int? mbrSq;
  int? drvReqSq;

  DrvResponse({
    required this.serverVersion,
    required this.serverId,
    required this.mbrSq,
    required this.drvReqSq,
  });

  factory DrvResponse.fromJson(Map<String, dynamic> json) => DrvResponse(
        serverVersion: json["serverVersion"],
        serverId: json["serverId"],
        mbrSq: json["mbrSq"],
        drvReqSq: json["drvReqSq"],
      );

  Map<String, dynamic> toJson() => {
        "serverVersion": serverVersion,
        "serverId": serverId,
        "mbrSq": mbrSq,
        "drvReqSq": drvReqSq,
      };
}
