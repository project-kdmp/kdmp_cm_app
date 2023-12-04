import 'package:kdmp_cm_app/data/constant/client_info.dart';

import 'package:kdmp_cm_app/data/constant/client_info.dart';

class KGMobilBillingKeyRequest {
  String clientVersion = ClientInfo.clientVersion;
  String clientId = ClientInfo.clientId;
  int mbrSq;
  String aliasNm;
  String cardNumber;
  String cardExpirationYear;
  String cardExpirationMonth;
  String cardPassword;
  String customerIdentityNumber;
  // String customerKey;
  bool breGenerate;

  KGMobilBillingKeyRequest({
    required this.mbrSq,
    required this.aliasNm,
    required this.cardNumber,
    required this.cardExpirationYear,
    required this.cardExpirationMonth,
    required this.cardPassword,
    required this.customerIdentityNumber,
    // required this.customerKey,
    required this.breGenerate,
  });

  factory KGMobilBillingKeyRequest.fromJson(Map<String, dynamic> json) => KGMobilBillingKeyRequest(
        mbrSq: json["mbrSq"],
        aliasNm: json["aliasNm"],
        cardNumber: json["cardNumber"],
        cardExpirationYear: json["cardExpirationYear"],
        cardExpirationMonth: json["cardExpirationMonth"],
        cardPassword: json["cardPassword"],
        customerIdentityNumber: json["customerIdentityNumber"],
        // customerKey: json["customerKey"],
        breGenerate: json["breGenerate"],
      );

  Map<String, dynamic> toJson() => {
        "clientVersion": clientVersion,
        "clientId": clientId,
        "mbrSq": mbrSq,
        "aliasNm": aliasNm,
        "cardNumber": cardNumber,
        "cardExpirationYear": cardExpirationYear,
        "cardExpirationMonth": cardExpirationMonth,
        "cardPassword": cardPassword,
        "customerIdentityNumber": customerIdentityNumber,
        // "customerKey": customerKey,
        "breGenerate": breGenerate,
      };
}
