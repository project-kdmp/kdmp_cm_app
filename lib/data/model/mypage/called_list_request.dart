import 'package:kdmp_cm_app/data/constant/client_info.dart';

class CalledListRequest {
  String clientVersion = ClientInfo.clientVersion;
  String clientId = ClientInfo.clientId;
  int mbrCmSq;
  int page;
  int pageSize;

  CalledListRequest({
    required this.mbrCmSq,
    required this.page,
    required this.pageSize,
  });

  factory CalledListRequest.fromJson(Map<String, dynamic> json) => CalledListRequest(
        mbrCmSq: json["mbrCmSq"],
        page: json["page"],
        pageSize: json["pageSize"],
      );

  Map<String, dynamic> toJson() => {
        "clientVersion": clientVersion,
        "clientId": clientId,
        "mbrCmSq": mbrCmSq,
        "page": page,
        "pageSize": pageSize,
      };
}
