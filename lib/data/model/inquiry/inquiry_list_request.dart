import 'package:kdmp_cm_app/data/constant/client_info.dart';

class InquiryListRequest {
  String clientVersion = ClientInfo.clientVersion;
  String clientId = ClientInfo.clientId;
  int cmMbrSq;
  int page;
  int pageSize;

  InquiryListRequest({
    required this.cmMbrSq,
    required this.page,
    required this.pageSize,
  });

  factory InquiryListRequest.fromJson(Map<String, dynamic> json) {
    return InquiryListRequest(
      cmMbrSq: json["cmMbrSq"] as int,
      page: json["page"] as int,
      pageSize: json["pageSize"] as int,
    );
  }

  Map<String, dynamic> toJson() => {
        "clientVersion": clientVersion,
        "clientId": clientId,
        "cmMbrSq": cmMbrSq,
        "page": page,
        "pageSize": pageSize,
      };
}
