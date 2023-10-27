import 'package:kdmp_cm_app/data/constant/client_info.dart';

class NoticeDetailRequest {
  String clientVersion = ClientInfo.clientVersion;
  String clientId = ClientInfo.clientId;
  int notiSq;

  NoticeDetailRequest({
    required this.notiSq,
  });

  factory NoticeDetailRequest.fromJson(Map<String, dynamic> json) {
    return NoticeDetailRequest(
      notiSq: json["notiSq"] as int,
    );
  }

  Map<String, dynamic> toJson() => {
        "clientVersion": clientVersion,
        "clientId": clientId,
        "notiSq": notiSq,
      };
}
