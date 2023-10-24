class DrivingRequest {
  String clientVersion;
  String clientId;
  int cmMbrSq;

  DrivingRequest({
    this.clientVersion = "",
    this.clientId = "",
    required this.cmMbrSq,
  });

  factory DrivingRequest.fromJson(Map<String, dynamic> json) => DrivingRequest(
        clientVersion: json["clientVersion"],
        clientId: json["clientId"],
        cmMbrSq: json["cmMbrSq"],
      );

  Map<String, dynamic> toJson() => {
        "clientVersion": clientVersion,
        "clientId": clientId,
        "cmMbrSq": cmMbrSq,
      };
}
