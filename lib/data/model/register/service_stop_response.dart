class ServiceStopResponse {
  String serverVersion;
  String serverId;
  String stopSvrContent;

  ServiceStopResponse({
    required this.serverVersion,
    required this.serverId,
    required this.stopSvrContent,
  });

  factory ServiceStopResponse.fromJson(Map<String, dynamic> json) {
    return ServiceStopResponse(
      serverVersion: json["serverVersion"] as String,
      serverId: json["serverId"] as String,
      stopSvrContent: json["stopSvrContent"] as String,
    );
  }

  Map<String, dynamic> toJson() => {
        "serverVersion": serverVersion,
        "serverId": serverId,
        "stopSvrContent": stopSvrContent,
      };
}
