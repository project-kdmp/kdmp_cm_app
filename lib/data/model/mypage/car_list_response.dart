class CarListResponse {
  String serverVersion;
  String serverId;
  List<Car> resultList;

  CarListResponse({
    required this.serverVersion,
    required this.serverId,
    required this.resultList,
  });

  factory CarListResponse.fromJson(Map<String, dynamic> json) => CarListResponse(
        serverVersion: json["serverVersion"],
        serverId: json["serverId"],
        resultList: List<Car>.from(json["resultList"].map((x) => Car.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "serverVersion": serverVersion,
        "serverId": serverId,
        "resultList": List<dynamic>.from(resultList.map((x) => x.toJson())),
      };
}

class Car {
  String? carNumId;

  Car({
    this.carNumId,
  });

  factory Car.fromJson(Map<String, dynamic> json) => Car(
        carNumId: json["carNumId"],
      );

  Map<String, dynamic> toJson() => {
        "carNumId": carNumId,
      };
}
