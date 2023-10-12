class InquiryWriteRequest {
  String clientVersion;
  String clientId;
  int cmMbrSq;
  String inqAskTitle;
  String inqAskContent;
  String inqRegIp;

  InquiryWriteRequest({
    this.clientVersion = "",
    this.clientId = "",
    required this.cmMbrSq,
    required this.inqAskTitle,
    required this.inqAskContent,
    required this.inqRegIp,
  });

  factory InquiryWriteRequest.fromJson(Map<String, dynamic> json) => InquiryWriteRequest(
        clientVersion: json["clientVersion"],
        clientId: json["clientId"],
        cmMbrSq: json["cmMbrSq"],
        inqAskTitle: json["inqAskTitle"],
        inqAskContent: json["inqAskContent"],
        inqRegIp: json["inqRegIp"],
      );

  Map<String, dynamic> toJson() => {
        "clientVersion": clientVersion,
        "clientId": clientId,
        "cmMbrSq": cmMbrSq,
        "inqAskTitle": inqAskTitle,
        "inqAskContent": inqAskContent,
        "inqRegIp": inqRegIp,
      };
}
