class CalledDetailResponse {
  String serverVersion;
  String serverId;
  int drvReqSq;
  String? drvStartDt;
  String? drvEndDt;
  String? drvReqSt;
  String? reqStartAddress;
  String? reqStartPlaceNm;
  String? reqEndAddress;
  String? reqEndPlaceNm;
  String? stopOverLst;
  int? drvPaymPrice;
  String? payCardInfo;
  String? dmMbrNm;
  String? carNumId;
  String? reviewContent;
  int? starPoint;

  CalledDetailResponse({
    required this.serverVersion,
    required this.serverId,
    required this.drvReqSq,
    this.drvStartDt,
    this.drvEndDt,
    this.drvReqSt,
    this.reqStartAddress,
    this.reqStartPlaceNm,
    this.reqEndAddress,
    this.reqEndPlaceNm,
    this.stopOverLst,
    this.drvPaymPrice,
    this.payCardInfo,
    this.dmMbrNm,
    this.carNumId,
    this.reviewContent,
    this.starPoint,
  });

  factory CalledDetailResponse.fromJson(Map<String, dynamic> json) => CalledDetailResponse(
        serverVersion: json["serverVersion"],
        serverId: json["serverId"],
        drvReqSq: json["drvReqSq"],
        drvStartDt: json["drvStartDt"],
        drvEndDt: json["drvEndDt"],
        drvReqSt: json["drvReqSt"],
        reqStartAddress: json["reqStartAddress"],
        reqStartPlaceNm: json["reqStartPlaceNm"],
        reqEndAddress: json["reqEndAddress"],
        reqEndPlaceNm: json["reqEndPlaceNm"],
        stopOverLst: json["stopOverLst"],
        drvPaymPrice: json["drvPaymPrice"],
        payCardInfo: json["payCardInfo"],
        dmMbrNm: json["dmMbrNm"],
        carNumId: json["carNumId"],
        reviewContent: json["reviewContent"],
        starPoint: json["starPoint"],
      );

  Map<String, dynamic> toJson() => {
        "serverVersion": serverVersion,
        "serverId": serverId,
        "drvReqSq": drvReqSq,
        "drvStartDt": drvStartDt,
        "drvEndDt": drvEndDt,
        "drvReqSt": drvReqSt,
        "reqStartAddress": reqStartAddress,
        "reqStartPlaceNm": reqStartPlaceNm,
        "reqEndAddress": reqEndAddress,
        "reqEndPlaceNm": reqEndPlaceNm,
        "stopOverLst": stopOverLst,
        "drvPaymPrice": drvPaymPrice,
        "payCardInfo": payCardInfo,
        "dmMbrNm": dmMbrNm,
        "carNumId": carNumId,
        "reviewContent": reviewContent,
        "starPoint": starPoint,
      };
}
