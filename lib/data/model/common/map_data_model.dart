import 'package:flutter_naver_map/flutter_naver_map.dart';

class MapData {
  NLatLng latLng;
  String place;
  String address;
  DrivingAddress drivingAddress;

  MapData({
    required this.latLng,
    this.place = "",
    this.address = "",
    required this.drivingAddress,
  });

  factory MapData.fromJson(Map<String, dynamic> json) => MapData(
        latLng: NLatLng(json["latitude"] as double, json["longitude"] as double),
        place: json["place"],
        address: json["address"],
        drivingAddress: DrivingAddress(sido: "", sigungu: "", legalDong: ""),
      );

  Map<String, dynamic> toJson() => {
        "latitude": latLng.latitude,
        "longitude": latLng.longitude,
        "place": place,
        "address": address,
        "drivingAddress": drivingAddress,
      };
}

class DrivingAddress {
  String sido;
  String sigungu;
  String legalDong;

  DrivingAddress({
    required this.sido,
    required this.sigungu,
    required this.legalDong,
  });

  factory DrivingAddress.fromJson(Map<String, dynamic> json) => DrivingAddress(
        sido: json["sido"],
        sigungu: json["sigungu"],
        legalDong: json["legalDong"],
      );

  Map<String, dynamic> toJson() => {
        "sido": sido,
        "sigungu": sigungu,
        "legalDong": legalDong,
      };
}
