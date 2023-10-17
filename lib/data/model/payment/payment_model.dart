class Payment {
  int paymentSq;
  String paymentNm;
  String customKey;

  Payment({
    this.paymentSq = 0,
    required this.paymentNm,
    required this.customKey,
  });

  factory Payment.fromJson(Map<String, dynamic> json) => Payment(
        paymentSq: json["paymentSq"],
        paymentNm: json["paymentNm"],
        customKey: json["customKey"],
      );

  Map<String, dynamic> toJson() => {
        "paymentSq": paymentSq,
        "paymentNm": paymentNm,
        "customKey": customKey,
      };
}
