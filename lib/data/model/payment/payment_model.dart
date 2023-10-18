class Payment {
  String paymentNm;
  String cardId;

  Payment({
    required this.paymentNm,
    required this.cardId,
  });

  factory Payment.fromJson(Map<String, dynamic> json) => Payment(
        paymentNm: json["paymentNm"],
        cardId: json["cardId"],
      );

  Map<String, dynamic> toJson() => {
        "paymentNm": paymentNm,
        "cardId": cardId,
      };
}
