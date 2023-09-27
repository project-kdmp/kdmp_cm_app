class GeocodingRequest {
  String query;
  int page;
  int count;
  String? coordinate; // 'lon,lat' 형식으로 입력

  GeocodingRequest({
    required this.query,
    required this.page,
    required this.count,
    this.coordinate,
  });

  factory GeocodingRequest.fromJson(Map<String, dynamic> json) => GeocodingRequest(
        query: json["query"],
        page: json["page"],
        count: json["count"],
        coordinate: json["coordinate"],
      );

  Map<String, dynamic> toJson() => {
        "query": query,
        "page": page,
        "count": count,
        "coordinate": coordinate,
      };
}
