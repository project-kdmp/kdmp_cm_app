import 'package:kdmp_cm_app/data/constant/client_info.dart';

class SendSmsVerifyRequest {
  String clientVersion = ClientInfo.clientVersion;
  String clientId = ClientInfo.clientId;
  String reqNo;
  String certCode;

  SendSmsVerifyRequest({
    required this.reqNo,
    required this.certCode,
  });

  Map<String, dynamic> toJson() => {
        "clientVersion": clientVersion,
        "clientId": clientId,
        "reqNo": reqNo,
        "certCode": certCode,
      };
}
