import 'package:kdmp_cm_app/data/constant/client_info.dart';

class TermDetailRequest {
  String clientVersion = ClientInfo.clientVersion;
  String clientId = ClientInfo.clientId;
  int trmSq;

  TermDetailRequest({
    required this.trmSq,
  });

  factory TermDetailRequest.fromJson(Map<String, dynamic> json) {
    return TermDetailRequest(
      trmSq: json["trmSq"] as int,
    );
  }

  Map<String, dynamic> toJson() => {
        "clientVersion": clientVersion,
        "clientId": clientId,
        "trmSq": trmSq,
      };
}
