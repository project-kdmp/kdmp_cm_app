import 'package:kdmp_cm_app/data/constant/client_info.dart';

class DeleteCardInfoRequest {
  String clientVersion = ClientInfo.clientVersion;
  String clientId = ClientInfo.clientId;
  int mbrSq;
  String cardId;

  DeleteCardInfoRequest({
    required this.mbrSq,
    required this.cardId,
  });

  factory DeleteCardInfoRequest.fromJson(Map<String, dynamic> json) => DeleteCardInfoRequest(
        mbrSq: json["mbrSq"],
        cardId: json["cardId"],
      );

  Map<String, dynamic> toJson() => {
        "clientVersion": clientVersion,
        "clientId": clientId,
        "mbrSq": mbrSq,
        "cardId": cardId,
      };
}
