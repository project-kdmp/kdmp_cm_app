class ReservationInfoResponse {
  String serverVersion;
  String serverId;
  int mbrSq;
  List<Reservation> resultList;

  ReservationInfoResponse({
    required this.serverVersion,
    required this.serverId,
    required this.mbrSq,
    required this.resultList,
  });

  factory ReservationInfoResponse.fromJson(Map<String, dynamic> json) => ReservationInfoResponse(
        serverVersion: json["serverVersion"],
        serverId: json["serverId"],
        mbrSq: json["mbrSq"],
        resultList: List<Reservation>.from(json["resultList"].map((x) => Reservation.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "serverVersion": serverVersion,
        "serverId": serverId,
        "mbrSq": mbrSq,
        "resultList": List<dynamic>.from(resultList.map((x) => x.toJson())),
      };
}

class Reservation {
  int drvReqSq;
  String? drvReqEndId;
  String? paymKind;
  String? carNumId;
  int? mbrCmSq;
  int? mbrDmSq;
  String? drvReqNm;
  String? drvReqSt;
  String? drvReserveDt;
  String? drvStartDt;
  String? drvEndDt;
  String? reqStartAddress;
  String? reqStartPlaceNm;
  String? reqEndAddress;
  String? reqEndPlaceNm;
  int? drvPaymPrice;
  int? drvDistance;
  int? gpsStartLat;
  int? gpsStartLong;
  int? gpsEndLat;
  int? gpsEndLong;

  Reservation({
    required this.drvReqSq,
    this.drvReqEndId,
    this.paymKind,
    this.carNumId,
    this.mbrCmSq,
    this.mbrDmSq,
    this.drvReqNm,
    this.drvReqSt,
    this.drvReserveDt,
    this.drvStartDt,
    this.drvEndDt,
    this.reqStartAddress,
    this.reqStartPlaceNm,
    this.reqEndAddress,
    this.reqEndPlaceNm,
    this.drvPaymPrice,
    this.drvDistance,
    this.gpsStartLat,
    this.gpsStartLong,
    this.gpsEndLat,
    this.gpsEndLong,
  });

  factory Reservation.fromJson(Map<String, dynamic> json) => Reservation(
        drvReqSq: json["drvReqSq"],
        drvReqEndId: json["drvReqEndId"],
        paymKind: json["paymKind"],
        carNumId: json["carNumId"],
        mbrCmSq: json["mbrCmSq"],
        mbrDmSq: json["mbrDmSq"],
        drvReqNm: json["drvReqNm"],
        drvReqSt: json["drvReqSt"],
        drvReserveDt: json["drvReserveDt"],
        drvStartDt: json["drvStartDt"],
        drvEndDt: json["drvEndDt"],
        reqStartAddress: json["reqStartAddress"],
        reqStartPlaceNm: json["reqStartPlaceNm"],
        reqEndAddress: json["reqEndAddress"],
        reqEndPlaceNm: json["reqEndPlaceNm"],
        drvPaymPrice: json["drvPaymPrice"],
        drvDistance: json["drvDistance"],
        gpsStartLat: json["gpsStartLat"],
        gpsStartLong: json["gpsStartLong"],
        gpsEndLat: json["gpsEndLat"],
        gpsEndLong: json["gpsEndLong"],
      );

  Map<String, dynamic> toJson() => {
        "drvReqSq": drvReqSq,
        "drvReqEndId": drvReqEndId,
        "paymKind": paymKind,
        "carNumId": carNumId,
        "mbrCmSq": mbrCmSq,
        "mbrDmSq": mbrDmSq,
        "drvReqNm": drvReqNm,
        "drvReqSt": drvReqSt,
        "drvReserveDt": drvReserveDt,
        "drvStartDt": drvStartDt,
        "drvEndDt": drvEndDt,
        "reqStartAddress": reqStartAddress,
        "reqStartPlaceNm": reqStartPlaceNm,
        "reqEndAddress": reqEndAddress,
        "reqEndPlaceNm": reqEndPlaceNm,
        "drvPaymPrice": drvPaymPrice,
        "drvDistance": drvDistance,
        "gpsStartLat": gpsStartLat,
        "gpsStartLong": gpsStartLong,
        "gpsEndLat": gpsEndLat,
        "gpsEndLong": gpsEndLong,
      };
}
