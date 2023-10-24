import 'package:flutter_naver_map/flutter_naver_map.dart';

class MapData {
  NLatLng latLng;
  String place;
  String address;

  MapData({
    required this.latLng,
    this.place = "",
    this.address = "",
  });

  factory MapData.fromJson(Map<String, dynamic> json) => MapData(
    latLng: NLatLng(json["latitude"] as double, json["longitude"] as double),
    place: json["place"],
    address: json["address"],
  );

  Map<String, dynamic> toJson() => {
    "latitude": latLng.latitude,
    "longitude": latLng.longitude,
    "place": place,
    "address": address,
  };
}
