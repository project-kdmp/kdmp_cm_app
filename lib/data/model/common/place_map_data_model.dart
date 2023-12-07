import 'package:flutter_naver_map/flutter_naver_map.dart';

class PlaceMapData {
  NLatLng latLng;
  String place;
  // TODO: 서버에 도로명, 지번 둘다 저장할 경우 address -> addressJibun 변경, addressRoad 추가
  String address;

  PlaceMapData({
    required this.latLng,
    this.place = "",
    this.address = "",
  });

  factory PlaceMapData.fromJson(Map<String, dynamic> json) => PlaceMapData(
        latLng: NLatLng(json["latitude"] as double, json["longitude"] as double),
        place: json["place"],
      );

  Map<String, dynamic> toJson() => {
        "latitude": latLng.latitude,
        "longitude": latLng.longitude,
        "place": place,
        "address": address,
      };
}
