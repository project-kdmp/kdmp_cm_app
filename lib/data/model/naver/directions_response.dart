class DirectionsResponse {
  int code;
  String message;
  String currentDateTime;
  Route route;

  DirectionsResponse({
    required this.code,
    required this.message,
    required this.currentDateTime,
    required this.route,
  });

  factory DirectionsResponse.fromJson(Map<String, dynamic> json) => DirectionsResponse(
        code: json["code"],
        message: json["message"],
        currentDateTime: json["currentDateTime"],
        route: Route.fromJson(json["route"]),
      );
}

class Route {
  List<Traoptimal> traoptimal;

  Route({
    required this.traoptimal,
  });

  factory Route.fromJson(Map<String, dynamic> json) => Route(
        traoptimal: List<Traoptimal>.from(json["traoptimal"].map((x) => Traoptimal.fromJson(x))),
      );
}

class Traoptimal {
  Summary summary;
  List<List<double>> path;
  List<Section>? section;
  List<Guide>? guide;

  Traoptimal({
    required this.summary,
    required this.path,
    this.section,
    this.guide,
  });

  factory Traoptimal.fromJson(Map<String, dynamic> json) => Traoptimal(
        summary: Summary.fromJson(json["summary"]),
        path: List<List<double>>.from(json["path"].map((x) => List<double>.from(x.map((x) => x.toDouble())))),
        section: List<Section>.from((json["section"] ?? List<Section>.empty()).map((x) => Section.fromJson(x))),
        guide: List<Guide>.from((json["guide"] ?? List<Guide>.empty()).map((x) => Guide.fromJson(x))),
      );
}

class Guide {
  int pointIndex;
  int type;
  String? instructions;
  int distance;
  int duration;

  Guide({
    required this.pointIndex,
    required this.type,
    this.instructions,
    required this.distance,
    required this.duration,
  });

  factory Guide.fromJson(Map<String, dynamic> json) => Guide(
        pointIndex: json["pointIndex"],
        type: json["type"],
        instructions: json["instructions"],
        distance: json["distance"],
        duration: json["duration"],
      );
}

class Section {
  int pointIndex;
  int pointCount;
  int distance;
  String name;
  int? congestion;
  int? speed;

  Section({
    required this.pointIndex,
    required this.pointCount,
    required this.distance,
    required this.name,
    this.congestion,
    this.speed,
  });

  factory Section.fromJson(Map<String, dynamic> json) => Section(
        pointIndex: json["pointIndex"],
        pointCount: json["pointCount"],
        distance: json["distance"],
        name: json["name"],
        congestion: json["congestion"],
        speed: json["speed"],
      );
}

class Summary {
  Start start;
  Goal goal;
  int distance;
  int duration;
  int etaServiceType;
  String departureTime;
  List<List<double>> bbox;
  int tollFare;
  int taxiFare;
  int fuelPrice;

  Summary({
    required this.start,
    required this.goal,
    required this.distance,
    required this.duration,
    required this.etaServiceType,
    required this.departureTime,
    required this.bbox,
    required this.tollFare,
    required this.taxiFare,
    required this.fuelPrice,
  });

  factory Summary.fromJson(Map<String, dynamic> json) => Summary(
        start: Start.fromJson(json["start"]),
        goal: Goal.fromJson(json["goal"]),
        distance: json["distance"],
        duration: json["duration"],
        etaServiceType: json["etaServiceType"],
        departureTime: json["departureTime"],
        bbox: List<List<double>>.from(json["bbox"].map((x) => List<double>.from(x.map((x) => x.toDouble())))),
        tollFare: json["tollFare"],
        taxiFare: json["taxiFare"],
        fuelPrice: json["fuelPrice"],
      );
}

class Goal {
  List<double> location;
  int dir;

  Goal({
    required this.location,
    required this.dir,
  });

  factory Goal.fromJson(Map<String, dynamic> json) => Goal(
        location: List<double>.from(json["location"].map((x) => x.toDouble())),
        dir: json["dir"],
      );
}

class Start {
  List<double> location;

  Start({
    required this.location,
  });

  factory Start.fromJson(Map<String, dynamic> json) => Start(
        location: List<double>.from(json["location"].map((x) => x.toDouble())),
      );
}
