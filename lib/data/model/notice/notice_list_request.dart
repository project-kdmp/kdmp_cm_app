import 'package:kdmp_cm_app/data/constant/client_info.dart';

class NoticeListRequest {
  String clientVersion = ClientInfo.clientVersion;
  String clientId = ClientInfo.clientId;
  int page;
  int pageSize;

  NoticeListRequest({
    required this.page,
    required this.pageSize,
  });

  factory NoticeListRequest.fromJson(Map<String, dynamic> json) {
    return NoticeListRequest(
      page: json["page"] as int,
      pageSize: json["pageSize"] as int,
    );
  }

  Map<String, dynamic> toJson() => {
        "clientVersion": clientVersion,
        "clientId": clientId,
        "page": page,
        "pageSize": pageSize,
      };
}
