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
}
