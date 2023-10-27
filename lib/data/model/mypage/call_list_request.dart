import 'package:kdmp_cm_app/data/constant/client_info.dart';

class CallListRequest {
  String clientVersion = ClientInfo.clientVersion;
  String clientId = ClientInfo.clientId;
  int mbrCmSq;

  CallListRequest({
    required this.mbrCmSq,
  });

  factory CallListRequest.fromJson(Map<String, dynamic> json) => CallListRequest(
        mbrCmSq: json["mbrCmSq"],
      );

  Map<String, dynamic> toJson() => {
        "clientVersion": clientVersion,
        "clientId": clientId,
        "mbrCmSq": mbrCmSq,
      };
}
