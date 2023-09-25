class CallListResponse {
  String serverVersion;
  String serverId;
  List<Call> resultList;

  CallListResponse({
    required this.serverVersion,
    required this.serverId,
    required this.resultList,
  });

  factory CallListResponse.fromJson(Map<String, dynamic> json) => CallListResponse(
        serverVersion: json["serverVersion"],
        serverId: json["serverId"],
        resultList: List<Call>.from(json["resultList"].map((x) => Call.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "serverVersion": serverVersion,
        "serverId": serverId,
        "resultList": List<dynamic>.from(resultList.map((x) => x.toJson())),
      };
}

class Call {
  int drvReqSq;
  String? drvStartDt;
  String? drvEndDt;
  String? drvReqSt;
  String? reqStartAddress;
  String? stopOverLst;
  String? reqEndAddress;
  int? drvPaymPrice;
  String? paymKind;

  Call({
    required this.drvReqSq,
    this.drvStartDt,
    this.drvEndDt,
    this.drvReqSt,
    this.reqStartAddress,
    this.stopOverLst,
    this.reqEndAddress,
    this.drvPaymPrice,
    this.paymKind,
  });

  factory Call.fromJson(Map<String, dynamic> json) => Call(
        drvReqSq: json["drvReqSq"],
        drvStartDt: json["drvStartDt"],
        drvEndDt: json["drvEndDt"],
        drvReqSt: json["drvReqSt"],
        reqStartAddress: json["reqStartAddress"],
        stopOverLst: json["stopOverLst"],
        reqEndAddress: json["reqEndAddress"],
        drvPaymPrice: json["drvPaymPrice"],
        paymKind: json["paymKind"],
      );

  Map<String, dynamic> toJson() => {
        "drvReqSq": drvReqSq,
        "drvStartDt": drvStartDt,
        "drvEndDt": drvEndDt,
        "drvReqSt": drvReqSt,
        "reqStartAddress": reqStartAddress,
        "stopOverLst": stopOverLst,
        "reqEndAddress": reqEndAddress,
        "drvPaymPrice": drvPaymPrice,
        "paymKind": paymKind,
      };
}
