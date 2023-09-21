class TermDetailRequest {
  String clientVersion;
  String clientId;
  int trmSq;

  TermDetailRequest({
    this.clientVersion = "",
    this.clientId = "",
    required this.trmSq,
  });

  factory TermDetailRequest.fromJson(Map<String, dynamic> json) {
    return TermDetailRequest(
      clientVersion: json["clientVersion"] as String,
      clientId: json["clientId"] as String,
      trmSq: json["trmSq"] as int,
    );
  }

  Map<String, dynamic> toJson() => {
        "clientVersion": clientVersion,
        "clientId": clientId,
        "trmSq": trmSq,
      };
}
