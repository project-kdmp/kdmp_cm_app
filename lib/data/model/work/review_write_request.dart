class ReviewWriteRequest {
  String clientVersion;
  String clientId;
  int mbrCmSq;
  int mbrDmSq;
  int drvReqSq;
  String reviewContent;
  int starPoint;

  ReviewWriteRequest({
    this.clientVersion = "",
    this.clientId = "",
    required this.mbrCmSq,
    required this.mbrDmSq,
    required this.drvReqSq,
    required this.reviewContent,
    required this.starPoint,
  });

  factory ReviewWriteRequest.fromJson(Map<String, dynamic> json) => ReviewWriteRequest(
        clientVersion: json["clientVersion"],
        clientId: json["clientId"],
        mbrCmSq: json["mbrCmSq"],
        mbrDmSq: json["mbrDmSq"],
        drvReqSq: json["drvReqSq"],
        reviewContent: json["reviewContent"],
        starPoint: json["starPoint"],
      );

  Map<String, dynamic> toJson() => {
        "clientVersion": clientVersion,
        "clientId": clientId,
        "mbrCmSq": mbrCmSq,
        "mbrDmSq": mbrDmSq,
        "drvReqSq": drvReqSq,
        "reviewContent": reviewContent,
        "starPoint": starPoint,
      };
}
