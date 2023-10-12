class InquiryDeleteRequest {
  String clientVersion;
  String clientId;
  int inqSq;

  InquiryDeleteRequest({
    this.clientVersion = "",
    this.clientId = "",
    required this.inqSq,
  });

  factory InquiryDeleteRequest.fromJson(Map<String, dynamic> json) => InquiryDeleteRequest(
        clientVersion: json["clientVersion"],
        clientId: json["clientId"],
        inqSq: json["inqSq"],
      );

  Map<String, dynamic> toJson() => {
        "clientVersion": clientVersion,
        "clientId": clientId,
        "inqSq": inqSq,
      };
}
