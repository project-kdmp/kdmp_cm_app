import 'package:kdmp_cm_app/data/constant/client_info.dart';

class PolicyRequest {
  String clientVersion = ClientInfo.clientVersion;
  String clientId = ClientInfo.clientId;
  String policyTp;

  PolicyRequest({
    required this.policyTp,
  });

  factory PolicyRequest.fromJson(Map<String, dynamic> json) {
    return PolicyRequest(
      policyTp: json["policyTp"],
    );
  }

  Map<String, dynamic> toJson() => {
        "clientVersion": clientVersion,
        "clientId": clientId,
        "policyTp": policyTp,
      };
}
