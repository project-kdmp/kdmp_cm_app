class JusoListRequest {
  int size;
  int page;
  String query;
  String confmKey;

  JusoListRequest({
    this.size = 15,
    required this.page,
    required this.query,
    required this.confmKey,
  });

  factory JusoListRequest.fromJson(Map<String, dynamic> json) {
    return JusoListRequest(
      size: json["size"],
      page: json["page"],
      query: json["query"],
      confmKey: json["confmKey"],
    );
  }

  Map<String, dynamic> toJson() => {
        "size": size,
        "page": page,
        "query": query,
      };
}
