/// 진행 중인 콜 목록(listNowDriving) 응답.
/// 한 고객이 동시에 진행 중인 콜 전체를 카드 요약으로 받는다.
class NowDrivingResponse {
  String serverVersion;
  String serverId;
  int? cmMbrSq;
  List<NowDrivingCall> resultList;

  NowDrivingResponse({
    required this.serverVersion,
    required this.serverId,
    this.cmMbrSq,
    required this.resultList,
  });

  factory NowDrivingResponse.fromJson(Map<String, dynamic> json) => NowDrivingResponse(
        serverVersion: json["serverVersion"] ?? "",
        serverId: json["serverId"] ?? "",
        cmMbrSq: json["cmMbrSq"],
        resultList: json["resultList"] == null
            ? []
            : List<NowDrivingCall>.from(json["resultList"].map((x) => NowDrivingCall.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "serverVersion": serverVersion,
        "serverId": serverId,
        "cmMbrSq": cmMbrSq,
        "resultList": List<dynamic>.from(resultList.map((x) => x.toJson())),
      };
}

/// 콜 1건 요약 (서버 CallListVO).
class NowDrivingCall {
  int drvReqSq;
  String? drvReqSt;
  String? paymKind;
  String? drvReqNm;
  String? reqStartPlaceNm;
  String? reqStartAddress;
  String? reqEndPlaceNm;
  String? reqEndAddress;
  int? drvPaymPrice;
  int? drvDistance;
  int? mbrDmSq;
  int? appointDmSq;
  String? reqRegDt;

  NowDrivingCall({
    required this.drvReqSq,
    this.drvReqSt,
    this.paymKind,
    this.drvReqNm,
    this.reqStartPlaceNm,
    this.reqStartAddress,
    this.reqEndPlaceNm,
    this.reqEndAddress,
    this.drvPaymPrice,
    this.drvDistance,
    this.mbrDmSq,
    this.appointDmSq,
    this.reqRegDt,
  });

  factory NowDrivingCall.fromJson(Map<String, dynamic> json) => NowDrivingCall(
        drvReqSq: json["drvReqSq"],
        drvReqSt: json["drvReqSt"],
        paymKind: json["paymKind"],
        drvReqNm: json["drvReqNm"],
        reqStartPlaceNm: json["reqStartPlaceNm"],
        reqStartAddress: json["reqStartAddress"],
        reqEndPlaceNm: json["reqEndPlaceNm"],
        reqEndAddress: json["reqEndAddress"],
        drvPaymPrice: json["drvPaymPrice"],
        drvDistance: json["drvDistance"],
        mbrDmSq: json["mbrDmSq"],
        appointDmSq: json["appointDmSq"],
        reqRegDt: json["reqRegDt"],
      );

  Map<String, dynamic> toJson() => {
        "drvReqSq": drvReqSq,
        "drvReqSt": drvReqSt,
        "paymKind": paymKind,
        "drvReqNm": drvReqNm,
        "reqStartPlaceNm": reqStartPlaceNm,
        "reqStartAddress": reqStartAddress,
        "reqEndPlaceNm": reqEndPlaceNm,
        "reqEndAddress": reqEndAddress,
        "drvPaymPrice": drvPaymPrice,
        "drvDistance": drvDistance,
        "mbrDmSq": mbrDmSq,
        "appointDmSq": appointDmSq,
        "reqRegDt": reqRegDt,
      };
}
