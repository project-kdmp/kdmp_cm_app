class DrvResponse {
  String serverVersion;
  String serverId;
  int? mbrSq;
  int? drvReqSq;

  /// 지정한 기사가 퇴근·탈퇴 상태라 지정이 풀리고 일반 배차로 접수됐는지
  bool appointReleased;

  DrvResponse({
    required this.serverVersion,
    required this.serverId,
    required this.mbrSq,
    required this.drvReqSq,
    this.appointReleased = false,
  });

  factory DrvResponse.fromJson(Map<String, dynamic> json) => DrvResponse(
        serverVersion: json["serverVersion"],
        serverId: json["serverId"],
        mbrSq: json["mbrSq"],
        drvReqSq: json["drvReqSq"],
        appointReleased: json["appointReleased"] ?? false,
      );

  Map<String, dynamic> toJson() => {
        "serverVersion": serverVersion,
        "serverId": serverId,
        "mbrSq": mbrSq,
        "drvReqSq": drvReqSq,
        "appointReleased": appointReleased,
      };
}
