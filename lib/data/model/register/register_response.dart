class RegisterResponse {
  String serverVersion;
  String serverId;
  int mbrSq;
  String mbrId;
  String mbrPwd;

  RegisterResponse({
    required this.serverVersion,
    required this.serverId,
    required this.mbrSq,
    required this.mbrId,
    required this.mbrPwd,
  });

  factory RegisterResponse.fromJson(Map<String, dynamic> json) {
    return RegisterResponse(
      serverVersion: json["serverVersion"] as String,
      serverId: json["serverId"] as String,
      mbrSq: json["mbrSq"] as int,
      mbrId: json["mbrId"] as String,
      mbrPwd: json["mbrPwd"] as String,
    );
  }

  Map<String, dynamic> toJson() => {
        "serverVersion": serverVersion,
        "serverId": serverId,
        "mbrSq": mbrSq,
        "mbrId": mbrId,
        "mbrPwd": mbrPwd,
      };
}
