import 'package:kdmp_cm_app/data/constant/client_info.dart';

class DrivingRequest {
  String clientVersion = ClientInfo.clientVersion;
  String clientId = ClientInfo.clientId;
  int cmMbrSq;

  DrivingRequest({
    required this.cmMbrSq,
  });

  factory DrivingRequest.fromJson(Map<String, dynamic> json) => DrivingRequest(
        cmMbrSq: json["cmMbrSq"],
      );

  Map<String, dynamic> toJson() => {
        "clientVersion": clientVersion,
        "clientId": clientId,
        "cmMbrSq": cmMbrSq,
      };
}
