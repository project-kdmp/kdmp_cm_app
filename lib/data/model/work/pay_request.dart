class PayRequest {
  String clientVersion;
  String clientId;
  int mbrSq;
  int drvReqSq;
  int price;
  String paymKind;
  String carNumId;

  PayRequest({
    this.clientVersion = "",
    this.clientId = "",
    required this.mbrSq,
    required this.drvReqSq,
    required this.price,
    required this.paymKind,
    required this.carNumId,
  });

  factory PayRequest.fromJson(Map<String, dynamic> json) => PayRequest(
        clientVersion: json["clientVersion"],
        clientId: json["clientId"],
        mbrSq: json["mbrSq"],
        drvReqSq: json["drvReqSq"],
        price: json["price"],
        paymKind: json["paymKind"],
        carNumId: json["carNumId"],
      );

  Map<String, dynamic> toJson() => {
        "clientVersion": clientVersion,
        "clientId": clientId,
        "mbrSq": mbrSq,
        "drvReqSq": drvReqSq,
        "price": price,
        "paymKind": paymKind,
        "carNumId": carNumId,
      };
}
