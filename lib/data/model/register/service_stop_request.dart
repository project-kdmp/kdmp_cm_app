import 'package:kdmp_cm_app/data/constant/client_info.dart';

class ServiceStopRequest {
  String clientVersion = ClientInfo.clientVersion;
  String clientId = ClientInfo.clientId;
  int cmMbrSq;

  ServiceStopRequest({
    required this.cmMbrSq,
  });

  factory ServiceStopRequest.fromJson(Map<String, dynamic> json) {
    return ServiceStopRequest(
      cmMbrSq: json["cmMbrSq"] as int,
    );
  }

  Map<String, dynamic> toJson() => {
        "clientVersion": clientVersion,
        "clientId": clientId,
        "cmMbrSq": cmMbrSq,
      };
}
