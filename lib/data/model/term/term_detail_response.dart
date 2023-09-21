class TermDetailResponse {
  String serverVersion;
  String serverId;
  int trmSq;
  String? trmTitle;
  String? trmText;
  String? trmHtml;
  String? trmSvrSt;
  String? trmTp;
  String? trmSvrStartDt;
  String? trmSvrEndDt;
  String? createId;
  String? createDt;
  String? updateId;
  String? updateDt;

  TermDetailResponse({
    required this.serverVersion,
    required this.serverId,
    required this.trmSq,
    this.trmTitle,
    this.trmText,
    this.trmHtml,
    this.trmSvrSt,
    this.trmTp,
    this.trmSvrStartDt,
    this.trmSvrEndDt,
    this.createId,
    this.createDt,
    this.updateId,
    this.updateDt,
  });

  factory TermDetailResponse.fromJson(Map<String, dynamic> json) {
    return TermDetailResponse(
      serverVersion: json["serverVersion"],
      serverId: json["serverId"],
      trmSq: json["trmSq"],
      trmTitle: json["trmTitle"],
      trmText: json["trmText"],
      trmHtml: json["trmHtml"],
      trmSvrSt: json["trmSvrSt"],
      trmTp: json["trmTp"],
      trmSvrStartDt: json["trmSvrStartDt"],
      trmSvrEndDt: json["trmSvrEndDt"],
      createId: json["createId"],
      createDt: json["createDt"],
      updateId: json["updateId"],
      updateDt: json["updateDt"],
    );
  }

  Map<String, dynamic> toJson() => {
        "serverVersion": serverVersion,
        "serverId": serverId,
        "trmSq": trmSq,
        "trmTitle": trmTitle,
        "trmText": trmText,
        "trmHtml": trmHtml,
        "trmSvrSt": trmSvrSt,
        "trmTp": trmTp,
        "trmSvrStartDt": trmSvrStartDt,
        "trmSvrEndDt": trmSvrEndDt,
        "createId": createId,
        "createDt": createDt,
        "updateId": updateId,
        "updateDt": updateDt,
      };
}
