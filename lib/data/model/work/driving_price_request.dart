import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:kdmp_cm_app/data/constant/client_info.dart';

class DrivingPriceRequest {
  String clientVersion = ClientInfo.clientVersion;
  String clientId = ClientInfo.clientId;
  NLatLng startCoord;
  NLatLng endCoord;
  List<NLatLng> stopoverCoordList;

  DrivingPriceRequest({
    required this.startCoord,
    required this.endCoord,
    required this.stopoverCoordList,
  });

  factory DrivingPriceRequest.fromJson(Map<String, dynamic> json) => DrivingPriceRequest(
        startCoord: _coordFromJson(json["startCoord"]),
        endCoord: _coordFromJson(json["endCoord"]),
        stopoverCoordList: List<NLatLng>.from(json["stopoverCoordList"].map((x) => _coordFromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "clientVersion": clientVersion,
        "clientId": clientId,
        "startCoord": _coordToJson(startCoord),
        "endCoord": _coordToJson(endCoord),
        "stopoverCoordList": List<dynamic>.from(stopoverCoordList.map((x) => _coordToJson(x))),
      };

  static NLatLng _coordFromJson(Map<String, dynamic> json) => NLatLng(json["lat"], json["lng"]);

  static Map<String, dynamic> _coordToJson(NLatLng coord) => {
        "lat": coord.latitude,
        "lng": coord.longitude,
      };
}
