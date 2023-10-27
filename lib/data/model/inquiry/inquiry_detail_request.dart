import 'package:kdmp_cm_app/data/constant/client_info.dart';

class InquiryDetailRequest {
  String clientVersion = ClientInfo.clientVersion;
  String clientId = ClientInfo.clientId;
  int inqSq;

  InquiryDetailRequest({
    required this.inqSq,
  });

  factory InquiryDetailRequest.fromJson(Map<String, dynamic> json) {
    return InquiryDetailRequest(
      inqSq: json["inqSq"] as int,
    );
  }

  Map<String, dynamic> toJson() => {
        "clientVersion": clientVersion,
        "clientId": clientId,
        "inqSq": inqSq,
      };
}
