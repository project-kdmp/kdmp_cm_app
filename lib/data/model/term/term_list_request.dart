import 'package:kdmp_cm_app/data/constant/client_info.dart';

class TermListRequest {
  String clientVersion = ClientInfo.clientVersion;
  String clientId = ClientInfo.clientId;
  String trmTp;

  TermListRequest({
    required this.trmTp,
  });

  factory TermListRequest.fromJson(Map<String, dynamic> json) {
    return TermListRequest(
      trmTp: json["trmTp"] as String,
    );
  }

  Map<String, dynamic> toJson() => {
        "clientVersion": clientVersion,
        "clientId": clientId,
        "trmTp": trmTp,
      };
}
