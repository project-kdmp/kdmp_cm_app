class LoginResponse {
  String serverVersion;
  String serverId;
  int mbrSq;
  String mbrId;
  String mbrPrivilegeTp;
  String mbrRegisterTp;
  String mbrSt;
  String mbrRegprogressSt;
  String jwt;
  String autoRefresh;
  bool bagreeTrmUpdate;

  LoginResponse({
    required this.serverVersion,
    required this.serverId,
    required this.mbrSq,
    required this.mbrId,
    required this.mbrPrivilegeTp,
    required this.mbrRegisterTp,
    required this.mbrSt,
    required this.mbrRegprogressSt,
    required this.jwt,
    required this.autoRefresh,
    required this.bagreeTrmUpdate,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      serverVersion: json["serverVersion"] as String,
      serverId: json["serverId"] as String,
      mbrSq: json["mbrSq"] as int,
      mbrId: json["mbrId"] as String,
      mbrPrivilegeTp: json["mbrPrivilegeTp"] as String,
      mbrRegisterTp: json["mbrRegisterTp"] as String,
      mbrSt: json["mbrSt"] as String,
      mbrRegprogressSt: json["mbrRegprogressSt"] as String,
      jwt: json["jwt"] as String,
      autoRefresh: json["autoRefresh"] as String,
      bagreeTrmUpdate: json["bagreeTrmUpdate"] as bool,
    );
  }

  Map<String, dynamic> toJson() => {
        "serverVersion": serverVersion,
        "serverId": serverId,
        "mbrSq": mbrSq,
        "mbrId": mbrId,
        "mbrPrivilegeTp": mbrPrivilegeTp,
        "mbrRegisterTp": mbrRegisterTp,
        "mbrSt": mbrSt,
        "mbrRegprogressSt": mbrRegprogressSt,
        "jwt": jwt,
        "autoRefresh": autoRefresh,
        "bagreeTrmUpdate": bagreeTrmUpdate,
      };
}
