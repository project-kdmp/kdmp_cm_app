class InquiryDetailRequest {
  String clientVersion;
  String clientId;
  int inqSq;

  InquiryDetailRequest({
    this.clientVersion = "",
    this.clientId = "",
    required this.inqSq,
  });

  factory InquiryDetailRequest.fromJson(Map<String, dynamic> json) {
    return InquiryDetailRequest(
      clientVersion: json["clientVersion"] as String,
      clientId: json["clientId"] as String,
      inqSq: json["inqSq"] as int,
    );
  }

  Map<String, dynamic> toJson() => {
        "clientVersion": clientVersion,
        "clientId": clientId,
        "inqSq": inqSq,
      };
}
