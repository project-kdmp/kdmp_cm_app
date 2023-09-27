class ReverseGeocodingRequest {
  String coords;
  String output;
  String orders;

  ReverseGeocodingRequest({
    required this.coords,
    this.output = "json",
    this.orders = "roadaddr,addr",
  });

  factory ReverseGeocodingRequest.fromJson(Map<String, dynamic> json) => ReverseGeocodingRequest(
        coords: json["coords"],
        output: json["output"],
        orders: json["orders"],
      );

  Map<String, dynamic> toJson() => {
        "coords": coords,
        "output": output,
        "orders": orders,
      };
}
