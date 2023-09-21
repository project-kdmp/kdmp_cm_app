import 'package:kdmp_cm_app/data/constant/codes.dart';

class RegisterRequest {
  String clientVersion;
  String clientId;
  String mbrNm;
  String mbrSt;
  String mbrMobilePhone;
  String mbrDeviceId;
  String mbrRegprogressSt;
  String mbrRegisterTp;
  String mbrSelfIdenyn;
  String mbrCi;
  List<AgreeTerm> agreeTermList;

  RegisterRequest({
    this.clientVersion = "",
    this.clientId = "",
    required this.mbrNm,
    this.mbrSt = MbrSt.temp,
    required this.mbrMobilePhone,
    required this.mbrDeviceId,
    this.mbrRegprogressSt = MbrRegprogressSt.cm10,
    this.mbrRegisterTp = MbrRegisterTp.phone,
    this.mbrSelfIdenyn = "Y",
    required this.mbrCi,
    required this.agreeTermList,
  });

  factory RegisterRequest.fromJson(Map<String, dynamic> json) {
    final agreeTermList = <AgreeTerm>[];
    json["agreeTermList"].forEach((v) {
      agreeTermList.add(AgreeTerm.fromJson(v));
    });
    return RegisterRequest(
      clientVersion: json["clientVersion"] as String,
      clientId: json["clientId"] as String,
      mbrNm: json["mbrNm"] as String,
      mbrSt: json["mbrSt"] as String,
      mbrMobilePhone: json["mbrMobilePhone"] as String,
      mbrDeviceId: json["mbrDeviceId"] as String,
      mbrRegprogressSt: json["mbrRegprogressSt"] as String,
      mbrRegisterTp: json["mbrRegisterTp"] as String,
      mbrSelfIdenyn: json["mbrSelfIdenyn"] as String,
      mbrCi: json["mbrCi"] as String,
      agreeTermList: agreeTermList,
    );
  }

  Map<String, dynamic> toJson() => {
    "clientVersion": clientVersion,
    "clientId": clientId,
    "mbrNm": mbrNm,
    "mbrSt": mbrSt,
    "mbrMobilePhone": mbrMobilePhone,
    "mbrDeviceId": mbrDeviceId,
    "mbrRegprogressSt": mbrRegprogressSt,
    "mbrRegisterTp": mbrRegisterTp,
    "mbrSelfIdenyn": mbrSelfIdenyn,
    "mbrCi": mbrCi,
    "agreeTermList": agreeTermList.map((v) => v.toJson()).toList(),
  };
}

class AgreeTerm {
  int trmSq;
  String agreeYn;
  String trmMandatoryYn;

  AgreeTerm({
    required this.trmSq,
    this.agreeYn = "N",
    required this.trmMandatoryYn,
  });

  factory AgreeTerm.fromJson(Map<String, dynamic> json) {
    return AgreeTerm(
      trmSq: json["trmSq"],
      trmMandatoryYn: json["trmMandatoryYn"],
    );
  }

  Map<String, dynamic> toJson() => {
    "trmSq": trmSq,
    "agreeYn": agreeYn,
    "trmMandatoryYn": trmMandatoryYn,
  };
}
