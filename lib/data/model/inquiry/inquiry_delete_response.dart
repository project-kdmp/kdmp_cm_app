import 'package:kdmp_cm_app/data/constant/client_info.dart';

class InquiryDeleteRequest {
  String clientVersion = ClientInfo.clientVersion;
  String clientId = ClientInfo.clientId;
  int inqSq;

  InquiryDeleteRequest({
    required this.inqSq,
  });

  factory InquiryDeleteRequest.fromJson(Map<String, dynamic> json) => InquiryDeleteRequest(
        inqSq: json["inqSq"],
      );

  Map<String, dynamic> toJson() => {
        "clientVersion": clientVersion,
        "clientId": clientId,
        "inqSq": inqSq,
      };
}
