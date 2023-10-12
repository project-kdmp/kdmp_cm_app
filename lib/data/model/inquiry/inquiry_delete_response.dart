class InquiryWriteResponse {
  String serverVersion;
  String serverId;
  int inqSq;

  InquiryWriteResponse({
    required this.serverVersion,
    required this.serverId,
    required this.inqSq,
  });

  factory InquiryWriteResponse.fromJson(Map<String, dynamic> json) => InquiryWriteResponse(
        serverVersion: json["serverVersion"],
        serverId: json["serverId"],
        inqSq: json["inqSq"],
      );

  Map<String, dynamic> toJson() => {
        "serverVersion": serverVersion,
        "serverId": serverId,
        "inqSq": inqSq,
      };
}
