import 'package:kdmp_cm_app/data/constant/client_info.dart';

class InquiryWriteRequest {
  String clientVersion = ClientInfo.clientVersion;
  String clientId = ClientInfo.clientId;
  int cmMbrSq;
  String inqAskTitle;
  String inqAskContent;
  String inqRegIp;

  InquiryWriteRequest({
    required this.cmMbrSq,
    required this.inqAskTitle,
    required this.inqAskContent,
    required this.inqRegIp,
  });

  factory InquiryWriteRequest.fromJson(Map<String, dynamic> json) => InquiryWriteRequest(
        cmMbrSq: json["cmMbrSq"],
        inqAskTitle: json["inqAskTitle"],
        inqAskContent: json["inqAskContent"],
        inqRegIp: json["inqRegIp"],
      );

  Map<String, dynamic> toJson() => {
        "clientVersion": clientVersion,
        "clientId": clientId,
        "cmMbrSq": cmMbrSq,
        "inqAskTitle": inqAskTitle,
        "inqAskContent": inqAskContent,
        "inqRegIp": inqRegIp,
      };
}
