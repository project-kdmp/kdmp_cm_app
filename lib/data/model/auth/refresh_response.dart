class RefreshResponse {
  String serverVersion;
  String serverId;
  String jwt;
  String autoRefresh;

  RefreshResponse({
    required this.serverVersion,
    required this.serverId,
    required this.jwt,
    required this.autoRefresh,
  });

  factory RefreshResponse.fromJson(Map<String, dynamic> json) {
    return RefreshResponse(
      serverVersion: json["serverVersion"] as String,
      serverId: json["serverId"] as String,
      jwt: json["jwt"] as String,
      autoRefresh: json["autoRefresh"] as String,
    );
  }

  Map<String, dynamic> toJson() => {
    "serverVersion": serverVersion,
    "serverId": serverId,
    "jwt": jwt,
    "autoRefresh": autoRefresh,
  };
}
