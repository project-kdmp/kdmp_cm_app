class TossBillingKeyResponse {
  String serverVersion;
  String serverId;
  int mbrSq;
  String cardId;

  TossBillingKeyResponse({
    this.serverVersion = "",
    this.serverId = "",
    required this.mbrSq,
    required this.cardId,
  });

  factory TossBillingKeyResponse.fromJson(Map<String, dynamic> json) => TossBillingKeyResponse(
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
