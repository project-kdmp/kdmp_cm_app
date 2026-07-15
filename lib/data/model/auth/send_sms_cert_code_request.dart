import 'dart:io';

import 'package:kdmp_cm_app/data/constant/client_info.dart';

class SendSmsCertCodeRequest {
  String clientVersion = ClientInfo.clientVersion;
  String clientId = ClientInfo.clientId;
  String receiver;
  String appSignature;
  String platform = Platform.isAndroid ? "android" : "iOS";

  SendSmsCertCodeRequest({
    required this.receiver,
    this.appSignature = "",
  });

  Map<String, dynamic> toJson() => {
        "clientVersion": clientVersion,
        "clientId": clientId,
        "receiver": receiver,
        "appSignature": appSignature,
        "platform": platform,
      };
}
