class MyTermRequest {
  String clientVersion;
  String clientId;
  int mbrSq;
  List<AgreeTerm> agreeTermList;

  MyTermRequest({
    this.clientVersion = "",
    this.clientId = "",
    required this.mbrSq,
    required this.agreeTermList,
  });

  factory MyTermRequest.fromJson(Map<String, dynamic> json) => MyTermRequest(
        clientVersion: json["clientVersion"],
        clientId: json["clientId"],
        mbrSq: json["mbrSq"],
        agreeTermList: List<AgreeTerm>.from(json["agreeTermList"].map((x) => AgreeTerm.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "clientVersion": clientVersion,
        "clientId": clientId,
        "mbrSq": mbrSq,
        "agreeTermList": List<dynamic>.from(agreeTermList.map((x) => x.toJson())),
      };
}

class AgreeTerm {
  int trmSq;
  String agreeYn;

  AgreeTerm({
    required this.trmSq,
    required this.agreeYn,
  });

  factory AgreeTerm.fromJson(Map<String, dynamic> json) {
    return AgreeTerm(
      trmSq: json["trmSq"],
      agreeYn: json["agreeYn"],
    );
  }

  Map<String, dynamic> toJson() => {
        "trmSq": trmSq,
        "agreeYn": agreeYn,
      };
}

class TempAgreeTerm {
  int trmSq;
  String agreeYn;
  String? trmMandatoryYn;

  TempAgreeTerm({
    required this.trmSq,
    this.agreeYn = "N",
    required this.trmMandatoryYn,
  });

  factory TempAgreeTerm.fromJson(Map<String, dynamic> json) {
    return TempAgreeTerm(
      trmSq: json["trmSq"],
      agreeYn: json["agreeYn"],
      trmMandatoryYn: json["trmMandatoryYn"],
    );
  }

  Map<String, dynamic> toJson() => {
        "trmSq": trmSq,
        "agreeYn": agreeYn,
        "trmMandatoryYn": trmMandatoryYn,
      };
}
