import 'package:kdmp_cm_app/data/model/common/map_data_model.dart';

class StopOver {
  String address;
  String placeName;
  int stopDistance;
  double lat;
  double long;
  DrivingAddress drivingAddress;

  StopOver({
    required this.address,
    required this.placeName,
    required this.stopDistance,
    required this.lat,
    required this.long,
    required this.drivingAddress,
  });

  factory StopOver.fromJson(Map<String, dynamic> json) => StopOver(
        address: json["address"],
        placeName: json["placeName"],
        stopDistance: json["stopDistance"],
        lat: json["lat"],
        long: json["long"],
        drivingAddress: DrivingAddress.fromJson(json["drivingAddress"]),
      );

  Map<String, dynamic> toJson() => {
        "address": address,
        "placeName": placeName,
        "stopDistance": stopDistance,
        "lat": lat,
        "long": long,
        "drivingAddress": drivingAddress,
      };
}
