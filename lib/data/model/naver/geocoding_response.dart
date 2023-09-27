class GeocodingResponse {
  String status;
  Meta? meta;
  List<Address>? addresses;
  String errorMessage;

  GeocodingResponse({
    required this.status,
    this.meta,
    this.addresses,
    required this.errorMessage,
  });

  factory GeocodingResponse.fromJson(Map<String, dynamic> json) => GeocodingResponse(
        status: json["status"],
        meta: json["meta"] != null ? Meta.fromJson(json["meta"]) : null,
        addresses: json["addresses"] != null ? List<Address>.from(json["addresses"].map((x) => Address.fromJson(x))) : List.empty(),
        errorMessage: json["errorMessage"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "meta": meta != null ? meta!.toJson() : null,
        "addresses": List<dynamic>.from(addresses != null ? addresses!.map((x) => x.toJson()) : List.empty()),
        "errorMessage": errorMessage,
      };
}

class Address {
  String roadAddress;
  String jibunAddress;
  String englishAddress;
  List<AddressElement> addressElements;
  String x;
  String y;
  double distance;

  Address({
    required this.roadAddress,
    required this.jibunAddress,
    required this.englishAddress,
    required this.addressElements,
    required this.x,
    required this.y,
    required this.distance,
  });

  factory Address.fromJson(Map<String, dynamic> json) => Address(
        roadAddress: json["roadAddress"],
        jibunAddress: json["jibunAddress"],
        englishAddress: json["englishAddress"],
        addressElements: List<AddressElement>.from(json["addressElements"].map((x) => AddressElement.fromJson(x))),
        x: json["x"],
        y: json["y"],
        distance: json["distance"].toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "roadAddress": roadAddress,
        "jibunAddress": jibunAddress,
        "englishAddress": englishAddress,
        "addressElements": List<dynamic>.from(addressElements.map((x) => x.toJson())),
        "x": x,
        "y": y,
        "distance": distance,
      };
}

class AddressElement {
  List<String> types;
  String longName;
  String shortName;
  String code;

  AddressElement({
    required this.types,
    required this.longName,
    required this.shortName,
    required this.code,
  });

  factory AddressElement.fromJson(Map<String, dynamic> json) => AddressElement(
        types: List<String>.from(json["types"].map((x) => x)),
        longName: json["longName"],
        shortName: json["shortName"],
        code: json["code"],
      );

  Map<String, dynamic> toJson() => {
        "types": List<dynamic>.from(types.map((x) => x)),
        "longName": longName,
        "shortName": shortName,
        "code": code,
      };
}

class Meta {
  int totalCount;
  int? page;
  int count;

  Meta({
    required this.totalCount,
    required this.count,
    this.page,
  });

  factory Meta.fromJson(Map<String, dynamic> json) => Meta(
        totalCount: json["totalCount"],
        page: json["page"],
        count: json["count"],
      );

  Map<String, dynamic> toJson() => {
        "totalCount": totalCount,
        "page": page,
        "count": count,
      };
}
