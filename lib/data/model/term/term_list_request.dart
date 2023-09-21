class TermListRequest {
  String clientVersion;
  String clientId;
  String trmTp;

  TermListRequest({
    this.clientVersion = "",
    this.clientId = "",
    required this.trmTp,
  });

  factory TermListRequest.fromJson(Map<String, dynamic> json) {
    return TermListRequest(
      clientVersion: json["clientVersion"] as String,
      clientId: json["clientId"] as String,
      trmTp: json["trmTp"] as String,
    );
  }

  Map<String, dynamic> toJson() => {
        "clientVersion": clientVersion,
        "clientId": clientId,
        "trmTp": trmTp,
      };
}
