class SendSmsCertCodeResponse {
  String serverVersion;
  String serverId;
  String reqNo;

  SendSmsCertCodeResponse({
    required this.serverVersion,
    required this.serverId,
    required this.reqNo,
  });

  factory SendSmsCertCodeResponse.fromJson(Map<String, dynamic> json) => SendSmsCertCodeResponse(
        serverVersion: json["serverVersion"],
        serverId: json["serverId"],
        reqNo: json["reqNo"].toString(),
      );

  Map<String, dynamic> toJson() => {
        "serverVersion": serverVersion,
        "serverId": serverId,
        "reqNo": reqNo,
      };
}
