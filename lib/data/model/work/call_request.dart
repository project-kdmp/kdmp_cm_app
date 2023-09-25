class CallRequest {
  String clientVersion;
  String clientId;
  int mbrCmSq;
  String paymKind;
  String carNumId;
  String drvReqNm;
  String drvReqSt;
  String reqRegDt;
  String drvReserveDt;
  String drvEndDt;
  String drvStartDt;
  String reqStartAddress;
  String reqStartPlaceNm;
  String reqEndAddress;
  String reqEndPlaceNm;
  String stopOverLst;
  int drvPaymPrice;
  int drvDistance;
  String reqAsk;
  int gpsStartLat;
  int gpsStartLong;
  int gpsEndLat;
  int gpsEndLong;

  CallRequest({
    this.clientVersion = "",
    this.clientId = "",
    required this.mbrCmSq,
    required this.paymKind,
    required this.carNumId,
    required this.drvReqNm,
    required this.drvReqSt,
    required this.reqRegDt,
    required this.drvReserveDt,
    required this.drvEndDt,
    required this.drvStartDt,
    required this.reqStartAddress,
    required this.reqStartPlaceNm,
    required this.reqEndAddress,
    required this.reqEndPlaceNm,
    required this.stopOverLst,
    required this.drvPaymPrice,
    required this.drvDistance,
    required this.reqAsk,
    required this.gpsStartLat,
    required this.gpsStartLong,
    required this.gpsEndLat,
    required this.gpsEndLong,
  });

  factory CallRequest.fromJson(Map<String, dynamic> json) => CallRequest(
        clientVersion: json["clientVersion"],
        clientId: json["clientId"],
        mbrCmSq: json["mbrCmSq"],
        paymKind: json["paymKind"],
        carNumId: json["carNumId"],
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
        drvPaymPrice: json["drvPaymPrice"],
        drvDistance: json["drvDistance"],
        reqAsk: json["reqAsk"],
        gpsStartLat: json["gpsStartLat"],
        gpsStartLong: json["gpsStartLong"],
        gpsEndLat: json["gpsEndLat"],
        gpsEndLong: json["gpsEndLong"],
      );

  Map<String, dynamic> toJson() => {
        "clientVersion": clientVersion,
        "clientId": clientId,
        "mbrCmSq": mbrCmSq,
        "paymKind": paymKind,
        "carNumId": carNumId,
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
        "drvPaymPrice": drvPaymPrice,
        "drvDistance": drvDistance,
        "reqAsk": reqAsk,
        "gpsStartLat": gpsStartLat,
        "gpsStartLong": gpsStartLong,
        "gpsEndLat": gpsEndLat,
        "gpsEndLong": gpsEndLong,
      };
}
