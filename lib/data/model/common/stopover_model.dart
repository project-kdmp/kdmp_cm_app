class StopOver {
  String address;
  String placeName;
  int stopDistance;
  double lat;
  double long;

  StopOver({
    required this.address,
    required this.placeName,
    required this.stopDistance,
    required this.lat,
    required this.long,
  });

  factory StopOver.fromJson(Map<String, dynamic> json) => StopOver(
    address: json["address"],
    placeName: json["placeName"],
    stopDistance: json["stopDistance"],
    lat: json["lat"],
    long: json["long"],
  );

  Map<String, dynamic> toJson() => {
    "address": address,
    "placeName": placeName,
    "stopDistance": stopDistance,
    "lat": lat,
    "long": long,
  };
}