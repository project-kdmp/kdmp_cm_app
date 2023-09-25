class CallDetailResponse {
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
  String? paymKind;
  String? dmMbrNm;
  String? carNumId;

  CallDetailResponse({
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
    this.paymKind,
    this.dmMbrNm,
    this.carNumId,
  });

  factory CallDetailResponse.fromJson(Map<String, dynamic> json) => CallDetailResponse(
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
        paymKind: json["paymKind"],
        dmMbrNm: json["dmMbrNm"],
        carNumId: json["carNumId"],
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
        "paymKind": paymKind,
        "dmMbrNm": dmMbrNm,
        "carNumId": carNumId,
      };
}
