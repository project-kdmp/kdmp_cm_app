class DriverListResponse {
  String serverVersion;
  String serverId;
  List<Driver> resultList;

  DriverListResponse({
    required this.serverVersion,
    required this.serverId,
    required this.resultList,
  });

  factory DriverListResponse.fromJson(Map<String, dynamic> json) => DriverListResponse(
        serverVersion: json["serverVersion"],
        serverId: json["serverId"],
        resultList: json["resultList"] != null ? List<Driver>.from(json["resultList"].map((x) => Driver.fromJson(x))) : List.empty(),
      );

  Map<String, dynamic> toJson() => {
        "serverVersion": serverVersion,
        "serverId": serverId,
        "resultList": List<dynamic>.from(resultList.map((x) => x.toJson())),
      };
}

/// 지정 호출 대상 기사.
/// 탭마다 서버가 채우는 항목이 다르다. 최근 탭은 lastDrvDt, 주변 탭은 distance 가 온다.
class Driver {
  int mbrDmSq;
  String drvNm;
  String drvNo;
  String drvWorkSt;
  String favorYn;
  double drvGrade;
  int drvGradeCnt;
  int? drvCnt;
  int? acceptRate;
  int? distance;
  int? arrivalMinute;
  String? lastDrvDt;
  String? belongNm;

  Driver({
    required this.mbrDmSq,
    required this.drvNm,
    required this.drvNo,
    required this.drvWorkSt,
    required this.favorYn,
    required this.drvGrade,
    required this.drvGradeCnt,
    this.drvCnt,
    this.acceptRate,
    this.distance,
    this.arrivalMinute,
    this.lastDrvDt,
    this.belongNm,
  });

  bool get isFavorite => favorYn == "Y";

  factory Driver.fromJson(Map<String, dynamic> json) => Driver(
        mbrDmSq: json["mbrDmSq"],
        drvNm: json["drvNm"] ?? "",
        drvNo: json["drvNo"] ?? "",
        drvWorkSt: json["drvWorkSt"] ?? "",
        favorYn: json["favorYn"] ?? "N",
        drvGrade: json["drvGrade"] != null ? (json["drvGrade"] as num).toDouble() : 0,
        drvGradeCnt: json["drvGradeCnt"] ?? 0,
        drvCnt: json["drvCnt"],
        acceptRate: json["acceptRate"],
        distance: json["distance"],
        arrivalMinute: json["arrivalMinute"],
        lastDrvDt: json["lastDrvDt"],
        belongNm: json["belongNm"],
      );

  Map<String, dynamic> toJson() => {
        "mbrDmSq": mbrDmSq,
        "drvNm": drvNm,
        "drvNo": drvNo,
        "drvWorkSt": drvWorkSt,
        "favorYn": favorYn,
        "drvGrade": drvGrade,
        "drvGradeCnt": drvGradeCnt,
        "drvCnt": drvCnt,
        "acceptRate": acceptRate,
        "distance": distance,
        "arrivalMinute": arrivalMinute,
        "lastDrvDt": lastDrvDt,
        "belongNm": belongNm,
      };
}
