class ReverseGeocodingResponse {
  Status status;
  List<Result> results;

  ReverseGeocodingResponse({
    required this.status,
    required this.results,
  });

  factory ReverseGeocodingResponse.fromJson(Map<String, dynamic> json) => ReverseGeocodingResponse(
        status: Status.fromJson(json["status"]),
        results: json.containsKey("results") ? List<Result>.from(json["results"].map((x) => Result.fromJson(x))) : List.empty(),
      );

  Map<String, dynamic> toJson() => {
        "status": status.toJson(),
        "results": List<dynamic>.from(results.map((x) => x.toJson())),
      };
}

class Result {
  String name;
  Code code;
  Region region;
  Land? land;

  Result({
    required this.name,
    required this.code,
    required this.region,
    this.land,
  });

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        name: json["name"],
        code: Code.fromJson(json["code"]),
        region: Region.fromJson(json["region"]),
        land: Land.fromJson(json["land"]),
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "code": code.toJson(),
        "region": region.toJson(),
        "land": land?.toJson(),
      };
}

class Code {
  String id;
  String type;
  String mappingId;

  Code({
    required this.id,
    required this.type,
    required this.mappingId,
  });

  factory Code.fromJson(Map<String, dynamic> json) => Code(
        id: json["id"],
        type: json["type"],
        mappingId: json["mappingId"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "type": type,
        "mappingId": mappingId,
      };
}

class Land {
  String? type;
  String? number1;
  String? number2;
  Addition? addition0;
  Addition? addition1;
  Addition? addition2;
  Addition? addition3;
  Addition? addition4;
  String? name;
  Coords? coords;

  Land({
    this.type,
    this.number1,
    this.number2,
    this.addition0,
    this.addition1,
    this.addition2,
    this.addition3,
    this.addition4,
    required this.name,
    this.coords,
  });

  factory Land.fromJson(Map<String, dynamic> json) => Land(
        type: json["type"],
        number1: json["number1"],
        number2: json["number2"],
        addition0: Addition.fromJson(json["addition0"]),
        addition1: Addition.fromJson(json["addition1"]),
        addition2: Addition.fromJson(json["addition2"]),
        addition3: Addition.fromJson(json["addition3"]),
        addition4: Addition.fromJson(json["addition4"]),
        name: json["name"],
        coords: Coords.fromJson(json["coords"]),
      );

  Map<String, dynamic> toJson() => {
        "type": type,
        "number1": number1,
        "number2": number2,
        "addition0": addition0?.toJson(),
        "addition1": addition1?.toJson(),
        "addition2": addition2?.toJson(),
        "addition3": addition3?.toJson(),
        "addition4": addition4?.toJson(),
        "name": name,
        "coords": coords?.toJson(),
      };
}

class Addition {
  String type;
  String value;

  Addition({
    required this.type,
    required this.value,
  });

  factory Addition.fromJson(Map<String, dynamic> json) => Addition(
        type: json["type"],
        value: json["value"],
      );

  Map<String, dynamic> toJson() => {
        "type": type,
        "value": value,
      };
}

class Region {
  Area? area0;
  Area? area1;
  Area? area2;
  Area? area3;
  Area? area4;

  Region({
    this.area0,
    this.area1,
    this.area2,
    this.area3,
    this.area4,
  });

  factory Region.fromJson(Map<String, dynamic> json) => Region(
        area0: Area.fromJson(json["area0"]),
        area1: Area.fromJson(json["area1"]),
        area2: Area.fromJson(json["area2"]),
        area3: Area.fromJson(json["area3"]),
        area4: Area.fromJson(json["area4"]),
      );

  Map<String, dynamic> toJson() => {
        "area0": area0?.toJson(),
        "area1": area1?.toJson(),
        "area2": area2?.toJson(),
        "area3": area3?.toJson(),
        "area4": area4?.toJson(),
      };
}

class Area {
  String name;
  Coords coords;

  Area({
    required this.name,
    required this.coords,
  });

  factory Area.fromJson(Map<String, dynamic> json) => Area(
        name: json["name"],
        coords: Coords.fromJson(json["coords"]),
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "coords": coords.toJson(),
      };
}

class Coords {
  Center center;

  Coords({
    required this.center,
  });

  factory Coords.fromJson(Map<String, dynamic> json) => Coords(
        center: Center.fromJson(json["center"]),
      );

  Map<String, dynamic> toJson() => {
        "center": center.toJson(),
      };
}

class Center {
  String crs;
  double x;
  double y;

  Center({
    required this.crs,
    required this.x,
    required this.y,
  });

  factory Center.fromJson(Map<String, dynamic> json) => Center(
        crs: json["crs"],
        x: json["x"].toDouble(),
        y: json["y"].toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "crs": crs,
        "x": x,
        "y": y,
      };
}

class Status {
  int code;
  String name;
  String message;

  Status({
    required this.code,
    required this.name,
    required this.message,
  });

  factory Status.fromJson(Map<String, dynamic> json) => Status(
        code: json["code"],
        name: json["name"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "name": name,
        "message": message,
      };
}
