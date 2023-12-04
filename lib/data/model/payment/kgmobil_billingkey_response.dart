class KGMobilBillingKeyResponse {
  String serverVersion;
  String serverId;
  int mbrSq;
  String cardId;

  KGMobilBillingKeyResponse({
    this.serverVersion = "",
    this.serverId = "",
    required this.mbrSq,
    required this.cardId,
  });

  factory KGMobilBillingKeyResponse.fromJson(Map<String, dynamic> json) => KGMobilBillingKeyResponse(
        serverVersion: json["serverVersion"],
        serverId: json["serverId"],
        mbrSq: json["mbrSq"],
        cardId: json["cardId"],
      );

  Map<String, dynamic> toJson() => {
        "serverVersion": serverVersion,
        "serverId": serverId,
        "mbrSq": mbrSq,
        "cardId": cardId,
      };
}
