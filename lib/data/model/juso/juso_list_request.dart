class JusoListRequest {
  int countPerPage;
  int currentPage;
  String keyword;
  String confmKey;
  String resultType;

  JusoListRequest({
    required this.countPerPage,
    required this.currentPage,
    required this.keyword,
    required this.confmKey,
    this.resultType = "json",
  });

  factory JusoListRequest.fromJson(Map<String, dynamic> json) {
    return JusoListRequest(
      countPerPage: json["countPerPage"],
      currentPage: json["currentPage"],
      keyword: json["keyword"],
      confmKey: json["confmKey"],
      resultType: json["resultType"],
    );
  }

  Map<String, dynamic> toJson() => {
        "countPerPage": countPerPage,
        "currentPage": currentPage,
        "keyword": keyword,
        "confmKey": confmKey,
        "resultType": resultType,
      };
}
