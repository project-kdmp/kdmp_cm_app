class VerifyResponse {
  String serverVersion;
  String serverId;
  String? name;
  String? gender;
  String birth;
  String? uniqueKey;
  String? phone;

  VerifyResponse({
    required this.serverVersion,
    required this.serverId,
    required this.name,
    required this.gender,
    required this.birth,
    required this.uniqueKey,
    required this.phone,
  });

  factory VerifyResponse.fromJson(Map<String, dynamic> json) => VerifyResponse(
        serverVersion: json["serverVersion"],
        serverId: json["serverId"],
        name: json["name"],
        gender: json["gender"],
        birth: json["birth"],
        uniqueKey: json["uniqueKey"],
        phone: json["phone"],
      );

  Map<String, dynamic> toJson() => {
        "serverVersion": serverVersion,
        "serverId": serverId,
        "name": name,
        "gender": gender,
        "birth": birth,
        "uniqueKey": uniqueKey,
        "phone": phone,
      };
}
