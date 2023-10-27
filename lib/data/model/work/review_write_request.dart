import 'package:kdmp_cm_app/data/constant/client_info.dart';

class ReviewWriteRequest {
  String clientVersion = ClientInfo.clientVersion;
  String clientId = ClientInfo.clientId;
  int drvReqSq;
  String reviewContent;
  int starPoint;

  ReviewWriteRequest({
    required this.drvReqSq,
    required this.reviewContent,
    required this.starPoint,
  });

  factory ReviewWriteRequest.fromJson(Map<String, dynamic> json) => ReviewWriteRequest(
        drvReqSq: json["drvReqSq"],
        reviewContent: json["reviewContent"],
        starPoint: json["starPoint"],
      );

  Map<String, dynamic> toJson() => {
        "clientVersion": clientVersion,
        "clientId": clientId,
        "drvReqSq": drvReqSq,
        "reviewContent": reviewContent,
        "starPoint": starPoint,
      };
}
