class DefaultRequest {
  String clientVersion;
  String clientId;
  int mbrSq;

  DefaultRequest({
    this.clientVersion = "",
    this.clientId = "",
    required this.mbrSq,
  });

  factory DefaultRequest.fromJson(Map<String, dynamic> json) {
    return DefaultRequest(
      clientVersion: json["clientVersion"] as String,
      clientId: json["clientId"] as String,
      mbrSq: json["mbrSq"] as int,
    );
  }

  Map<String, dynamic> toJson() => {
        "clientVersion": clientVersion,
        "clientId": clientId,
        "mbrSq": mbrSq,
      };
}
