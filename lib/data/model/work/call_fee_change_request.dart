class CallFeeChangeRequest {
  String clientVersion;
  String clientId;
  int mbrSq;
  int drvReqSq;
  int price;
  int beforPrice;

  CallFeeChangeRequest({
    this.clientVersion = "",
    this.clientId = "",
    required this.mbrSq,
    required this.drvReqSq,
    required this.price,
    required this.beforPrice,
  });

  factory CallFeeChangeRequest.fromJson(Map<String, dynamic> json) => CallFeeChangeRequest(
        clientVersion: json["clientVersion"],
        clientId: json["clientId"],
        mbrSq: json["mbrSq"],
        drvReqSq: json["drvReqSq"],
        price: json["price"],
        beforPrice: json["beforPrice"],
      );

  Map<String, dynamic> toJson() => {
        "clientVersion": clientVersion,
        "clientId": clientId,
        "mbrSq": mbrSq,
        "drvReqSq": drvReqSq,
        "price": price,
        "beforPrice": beforPrice,
      };
}
