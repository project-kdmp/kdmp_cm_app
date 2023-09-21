class CMTermListResponse {
  String serverVersion;
  String serverId;
  List<Term> resultList;

  CMTermListResponse({
    required this.serverVersion,
    required this.serverId,
    required this.resultList,
  });

  factory CMTermListResponse.fromJson(Map<String, dynamic> json) {
    var resultList = <Term>[];
    json["resultList"].forEach((v) {
      resultList.add(Term.fromJson(v));
    });
    return CMTermListResponse(
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
  String? trmTp;
  String? trmMandatoryYn;
  String? agreeYn;

  Term({
    required this.trmSq,
    this.trmTitle,
    this.trmTp,
    this.trmMandatoryYn,
    this.agreeYn,
  });

  factory Term.fromJson(Map<String, dynamic> json) {
    return Term(
      trmSq: json["trmSq"],
      trmTitle: json["trmTitle"],
      trmTp: json["trmTp"],
      trmMandatoryYn: json["trmMandatoryYn"],
      agreeYn: json["agreeYn"],
    );
  }

  Map<String, dynamic> toJson() => {
        "trmSq": trmSq,
        "trmTitle": trmTitle,
        "trmTp": trmTp,
        "trmMandatoryYn": trmMandatoryYn,
        "agreeYn": agreeYn,
      };
}
