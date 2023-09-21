class DefaultResponse {
  String serverVersion;
  String serverId;
  int? mbrSq;

  DefaultResponse({
    required this.serverVersion,
    required this.serverId,
    this.mbrSq,
  });

  factory DefaultResponse.fromJson(Map<String, dynamic> json) {
    return DefaultResponse(
      serverVersion: json["serverVersion"] as String,
      serverId: json["serverId"] as String,
      mbrSq: json["mbrSq"],
    );
  }

  Map<String, dynamic> toJson() => {
        "serverVersion": serverVersion,
        "serverId": serverId,
        "mbrSq": mbrSq,
      };
}
