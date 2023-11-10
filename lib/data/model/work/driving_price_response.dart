class DrivingPriceResponse {
  String serverVersion;
  String serverId;
  int price;

  DrivingPriceResponse({
    required this.serverVersion,
    required this.serverId,
    required this.price,
  });

  factory DrivingPriceResponse.fromJson(Map<String, dynamic> json) => DrivingPriceResponse(
        serverVersion: json["serverVersion"],
        serverId: json["serverId"],
        price: json["price"],
      );

  Map<String, dynamic> toJson() => {
        "serverVersion": serverVersion,
        "serverId": serverId,
        "price": price,
      };
}
