import 'package:kdmp_cm_app/data/constant/client_info.dart';
import 'package:kdmp_cm_app/data/model/common/map_data_model.dart';

class DrivingPriceRequest {
  String clientVersion = ClientInfo.clientVersion;
  String clientId = ClientInfo.clientId;
  DrivingAddress start;
  DrivingAddress end;
  List<DrivingAddress> stopoverList;

  DrivingPriceRequest({
    required this.start,
    required this.end,
    required this.stopoverList,
  });

  factory DrivingPriceRequest.fromJson(Map<String, dynamic> json) => DrivingPriceRequest(
        start: DrivingAddress.fromJson(json["start"]),
        end: DrivingAddress.fromJson(json["end"]),
        stopoverList: List<DrivingAddress>.from(json["stopoverList"].map((x) => DrivingAddress.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "clientVersion": clientVersion,
        "clientId": clientId,
        "start": start.toJson(),
        "end": end.toJson(),
        "stopoverList": List<dynamic>.from(stopoverList.map((x) => x.toJson())),
      };
}
