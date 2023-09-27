class DirectionsRequest {
  String start;
  String goal;
  String? waypoints;

  DirectionsRequest({
    required this.start,
    required this.goal,
    this.waypoints,
  });

  factory DirectionsRequest.fromJson(Map<String, dynamic> json) => DirectionsRequest(
        start: json["start"],
        goal: json["goal"],
        waypoints: json["waypoints"],
      );

  Map<String, dynamic> toJson() => {
        "start": start,
        "goal": goal,
        "waypoints": waypoints,
      };
}
