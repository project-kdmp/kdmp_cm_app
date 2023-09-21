class RefreshRequest {
  String clientVersion;
  String clientId;
  String mbrId;
  String autoRefreshToken;

  RefreshRequest({
    this.clientVersion = "",
    this.clientId = "",
    required this.mbrId,
    required this.autoRefreshToken,
  });

  factory RefreshRequest.fromJson(Map<String, dynamic> json) {
    return RefreshRequest(
      clientVersion: json["clientVersion"] as String,
      clientId: json["clientId"] as String,
      mbrId: json["mbrId"] as String,
      autoRefreshToken: json["autoRefreshToken"] as String,
    );
  }

  Map<String, dynamic> toJson() => {
        "clientVersion": clientVersion,
        "clientId": clientId,
        "mbrId": mbrId,
        "autoRefreshToken": autoRefreshToken,
      };
}
