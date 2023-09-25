class CarModifyRequest {
  String clientVersion;
  String clientId;
  int mbrSq;
  String beforeCarNumId;
  String afterCarNumId;

  CarModifyRequest({
    this.clientVersion = "",
    this.clientId = "",
    required this.mbrSq,
    required this.beforeCarNumId,
    required this.afterCarNumId,
  });

  factory CarModifyRequest.fromJson(Map<String, dynamic> json) => CarModifyRequest(
        clientVersion: json["clientVersion"],
        clientId: json["clientId"],
        mbrSq: json["mbrSq"],
        beforeCarNumId: json["beforeCarNumId"],
        afterCarNumId: json["afterCarNumId"],
      );

  Map<String, dynamic> toJson() => {
        "clientVersion": clientVersion,
        "clientId": clientId,
        "mbrSq": mbrSq,
        "beforeCarNumId": beforeCarNumId,
        "afterCarNumId": afterCarNumId,
      };
}
