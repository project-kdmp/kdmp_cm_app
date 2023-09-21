class TermListResponse {
  String serverVersion;
  String serverId;
  List<Term> resultList;

  TermListResponse({
    required this.serverVersion,
    required this.serverId,
    required this.resultList,
  });

  factory TermListResponse.fromJson(Map<String, dynamic> json) {
    var resultList = <Term>[];
    json["resultList"].forEach((v) {
      resultList.add(Term.fromJson(v));
    });
    return TermListResponse(
      serverVersion: json["serverVersion"],
      serverId: json["serverId"],
      resultList: resultList,
    );
  }

  Map<String, dynamic> toJson() => {
        "serverVersion": serverVersion,
        "serverId": serverId,
        "resultList": resultList.map((v) => v.toJson()).toList(),
      };
}

class Term {
  int trmSq;
  String? trmTitle;
  String? trmText;
  String? trmHtml;
  String? trmSvrSt;
  String? trmTp;
  String? trmMandatoryYn;
  String? trmSvrStartDt;
  String? trmSvrEndDt;
  String? createId;
  String? createDt;
  String? updateId;
  String? updateDt;

  Term({
    required this.trmSq,
    this.trmTitle,
    this.trmText,
    this.trmHtml,
    this.trmSvrSt,
    this.trmTp,
    this.trmMandatoryYn,
    this.trmSvrStartDt,
    this.trmSvrEndDt,
    this.createId,
    this.createDt,
    this.updateId,
    this.updateDt,
  });

  factory Term.fromJson(Map<String, dynamic> json) {
    return Term(
      trmSq: json["trmSq"],
      trmTitle: json["trmTitle"],
      trmText: json["trmText"],
      trmHtml: json["trmHtml"],
      trmSvrSt: json["trmSvrSt"],
      trmTp: json["trmTp"],
      trmMandatoryYn: json["trmMandatoryYn"],
      trmSvrStartDt: json["trmSvrStartDt"],
      trmSvrEndDt: json["trmSvrEndDt"],
      createId: json["createId"],
      createDt: json["createDt"],
      updateId: json["updateId"],
      updateDt: json["updateDt"],
    );
  }

  Map<String, dynamic> toJson() => {
        "trmSq": trmSq,
        "trmTitle": trmTitle,
        "trmText": trmText,
        "trmHtml": trmHtml,
        "trmSvrSt": trmSvrSt,
        "trmTp": trmTp,
        "trmMandatoryYn": trmMandatoryYn,
        "trmSvrStartDt": trmSvrStartDt,
        "trmSvrEndDt": trmSvrEndDt,
        "createId": createId,
        "createDt": createDt,
        "updateId": updateId,
        "updateDt": updateDt,
      };
}
