class LostChildListResponse {
  String serverVersion;
  String serverId;
  List<LostChild> resultList;
  int lostChildHour;

  LostChildListResponse({
    required this.serverVersion,
    required this.serverId,
    required this.resultList,
    required this.lostChildHour,
  });

  factory LostChildListResponse.fromJson(Map<String, dynamic> json) => LostChildListResponse(
        serverVersion: json["serverVersion"],
        serverId: json["serverId"],
        resultList: List<LostChild>.from(json["resultList"].map((x) => LostChild.fromJson(x))),
        lostChildHour: json["lostChildHour"] ?? 24,
      );

  Map<String, dynamic> toJson() => {
        "serverVersion": serverVersion,
        "serverId": serverId,
        "resultList": List<dynamic>.from(resultList.map((x) => x.toJson())),
        "lostChildHour": lostChildHour,
      };
}

class LostChild {
  int msspsnIdntfccd;
  String nm;
  int age;
  int ageNow;
  String sexdstnDscd;
  String? occrde;
  String? occrAdres;
  String? etcSpfeatr;
  String? tknphotoFile;
  int? tknphotolength;
  String? alldressingDscd;
  String? writngTrgetDscd;
  int views;
  String? createDt;

  LostChild({
    required this.msspsnIdntfccd,
    required this.nm,
    required this.age,
    required this.ageNow,
    required this.sexdstnDscd,
    this.occrde,
    this.occrAdres,
    this.etcSpfeatr,
    this.tknphotoFile,
    this.tknphotolength,
    this.alldressingDscd,
    this.writngTrgetDscd,
    required this.views,
    this.createDt,
  });

  factory LostChild.fromJson(Map<String, dynamic> json) => LostChild(
        msspsnIdntfccd: json["msspsnIdntfccd"],
        nm: json["nm"],
        age: json["age"],
        ageNow: json["ageNow"],
        sexdstnDscd: json["sexdstnDscd"],
        occrde: json["occrde"],
        occrAdres: json["occrAdres"],
        etcSpfeatr: json["etcSpfeatr"],
        tknphotoFile: json["tknphotoFile"],
        tknphotolength: json["tknphotolength"],
        alldressingDscd: json["alldressingDscd"],
        writngTrgetDscd: json["writngTrgetDscd"],
        views: json["views"] ?? 0,
        createDt: json["createDt"],
      );

  Map<String, dynamic> toJson() => {
        "msspsnIdntfccd": msspsnIdntfccd,
        "nm": nm,
        "age": age,
        "ageNow": ageNow,
        "sexdstnDscd": sexdstnDscd,
        "occrde": occrde,
        "occrAdres": occrAdres,
        "etcSpfeatr": etcSpfeatr,
        "tknphotoFile": tknphotoFile,
        "tknphotolength": tknphotolength,
        "alldressingDscd": alldressingDscd,
        "writngTrgetDscd": writngTrgetDscd,
        "views": views,
        "createDt": createDt,
      };
}
