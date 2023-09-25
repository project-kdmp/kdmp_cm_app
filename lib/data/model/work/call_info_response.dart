class CallInfoResponse {
  String serverVersion;
  String serverId;
  int? drvReqSq;
  String? paymKind;
  String? carNumId;
  int? mbrCmSq;
  int? mbrDmSq;
  String? drvReqNm;
  String? drvReqSt;
  String? reqRegDt;
  String? drvReserveDt;
  String? drvEndDt;
  String? drvStartDt;
  String? reqStartAddress;
  String? reqStartPlaceNm;
  String? reqEndAddress;
  String? reqEndPlaceNm;
  String? stopOverLst;
  String? drvSafeCall;
  int? drvPaymPrice;
  int? drvDistance;
  String? reqAsk;
  int? gpsStartLat;
  int? gpsStartLong;
  int? gpsEndLat;
  int? gpsEndLong;
  String? createId;
  String? createDt;
  String? updateId;
  String? updateDt;

  CallInfoResponse({
    required this.serverVersion,
    required this.serverId,
    required this.drvReqSq,
    this.paymKind,
    this.carNumId,
    this.mbrCmSq,
    this.mbrDmSq,
    this.drvReqNm,
    this.drvReqSt,
    this.reqRegDt,
    this.drvReserveDt,
    this.drvEndDt,
    this.drvStartDt,
    this.reqStartAddress,
    this.reqStartPlaceNm,
    this.reqEndAddress,
    this.reqEndPlaceNm,
    this.stopOverLst,
    this.drvSafeCall,
    this.drvPaymPrice,
    this.drvDistance,
    this.reqAsk,
    this.gpsStartLat,
    this.gpsStartLong,
    this.gpsEndLat,
    this.gpsEndLong,
    this.createId,
    this.createDt,
    this.updateId,
    this.updateDt,
  });

  factory CallInfoResponse.fromJson(Map<String, dynamic> json) => CallInfoResponse(
        serverVersion: json["serverVersion"],
        serverId: json["serverId"],
        drvReqSq: json["drvReqSq"],
        paymKind: json["paymKind"],
        carNumId: json["carNumId"],
        mbrCmSq: json["mbrCmSq"],
        mbrDmSq: json["mbrDmSq"],
        drvReqNm: json["drvReqNm"],
        drvReqSt: json["drvReqSt"],
        reqRegDt: json["reqRegDt"],
        drvReserveDt: json["drvReserveDt"],
        drvEndDt: json["drvEndDt"],
        drvStartDt: json["drvStartDt"],
        reqStartAddress: json["reqStartAddress"],
        reqStartPlaceNm: json["reqStartPlaceNm"],
        reqEndAddress: json["reqEndAddress"],
        reqEndPlaceNm: json["reqEndPlaceNm"],
        stopOverLst: json["stopOverLst"],
        drvSafeCall: json["drvSafeCall"],
        drvPaymPrice: json["drvPaymPrice"],
        drvDistance: json["drvDistance"],
        reqAsk: json["reqAsk"],
        gpsStartLat: json["gpsStartLat"],
        gpsStartLong: json["gpsStartLong"],
        gpsEndLat: json["gpsEndLat"],
        gpsEndLong: json["gpsEndLong"],
        createId: json["createId"],
        createDt: json["createDt"],
        updateId: json["updateId"],
        updateDt: json["updateDt"],
      );

  Map<String, dynamic> toJson() => {
        "serverVersion": serverVersion,
        "serverId": serverId,
        "drvReqSq": drvReqSq,
        "paymKind": paymKind,
        "carNumId": carNumId,
        "mbrCmSq": mbrCmSq,
        "mbrDmSq": mbrDmSq,
        "drvReqNm": drvReqNm,
        "drvReqSt": drvReqSt,
        "reqRegDt": reqRegDt,
        "drvReserveDt": drvReserveDt,
        "drvEndDt": drvEndDt,
        "drvStartDt": drvStartDt,
        "reqStartAddress": reqStartAddress,
        "reqStartPlaceNm": reqStartPlaceNm,
        "reqEndAddress": reqEndAddress,
        "reqEndPlaceNm": reqEndPlaceNm,
        "stopOverLst": stopOverLst,
        "drvSafeCall": drvSafeCall,
        "drvPaymPrice": drvPaymPrice,
        "drvDistance": drvDistance,
        "reqAsk": reqAsk,
        "gpsStartLat": gpsStartLat,
        "gpsStartLong": gpsStartLong,
        "gpsEndLat": gpsEndLat,
        "gpsEndLong": gpsEndLong,
        "createId": createId,
        "createDt": createDt,
        "updateId": updateId,
        "updateDt": updateDt,
      };
}
