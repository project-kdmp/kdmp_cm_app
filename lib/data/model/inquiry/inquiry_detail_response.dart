class InquiryDetailResponse {
  String serverVersion;
  String serverId;
  int inqSq;
  String? inqRtnSt;
  String? inqAskTitle;
  String? inqAskContent;
  String? createDt;
  String? mbrAdmNm;
  String? inqRtnContent;
  String? updateDt;

  InquiryDetailResponse({
    this.serverVersion = "",
    this.serverId = "",
    required this.inqSq,
    this.inqRtnSt,
    this.inqAskTitle,
    this.inqAskContent,
    this.createDt,
    this.mbrAdmNm,
    this.inqRtnContent,
    this.updateDt,
  });

  factory InquiryDetailResponse.fromJson(Map<String, dynamic> json) => InquiryDetailResponse(
        serverVersion: json["serverVersion"],
        serverId: json["serverId"],
        inqSq: json["inqSq"],
        inqRtnSt: json["inqRtnSt"],
        inqAskTitle: json["inqAskTitle"],
        inqAskContent: json["inqAskContent"],
        createDt: json["createDt"],
        mbrAdmNm: json["mbrAdmNm"],
        inqRtnContent: json["inqRtnContent"],
        updateDt: json["updateDt"],
      );

  Map<String, dynamic> toJson() => {
        "serverVersion": serverVersion,
        "serverId": serverId,
        "inqSq": inqSq,
        "inqRtnSt": inqRtnSt,
        "inqAskTitle": inqAskTitle,
        "inqAskContent": inqAskContent,
        "createDt": createDt,
        "mbrAdmNm": mbrAdmNm,
        "inqRtnContent": inqRtnContent,
        "updateDt": updateDt,
      };
}
