import 'package:kdmp_cm_app/data/constant/client_info.dart';

class VerifyRequest {
  String clientVersion = ClientInfo.clientVersion;
  String clientId = ClientInfo.clientId;
  int mbrSq;
  String impUid;

  VerifyRequest({
    this.mbrSq = 0,
    required this.impUid,
  });

  factory VerifyRequest.fromJson(Map<String, dynamic> json) => VerifyRequest(
        mbrSq: json["mbrSq"],
        impUid: json["impUid"],
      );

  Map<String, dynamic> toJson() => {
        "mbrSq": mbrSq,
        "impUid": impUid,
      };
}
