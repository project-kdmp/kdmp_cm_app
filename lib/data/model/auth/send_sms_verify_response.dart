class SendSmsVerifyResponse {
  String serverVersion;
  String serverId;
  bool result;

  SendSmsVerifyResponse({
    required this.serverVersion,
    required this.serverId,
    required this.result,
  });

  factory SendSmsVerifyResponse.fromJson(Map<String, dynamic> json) => SendSmsVerifyResponse(
        serverVersion: json["serverVersion"],
        serverId: json["serverId"],
        result: json["result"] ?? false,
      );

  Map<String, dynamic> toJson() => {
        "serverVersion": serverVersion,
        "serverId": serverId,
        "result": result,
      };
}
