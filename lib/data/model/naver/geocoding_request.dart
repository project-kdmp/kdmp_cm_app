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

  /// coordinate 를 넣지 않으면 키를 아예 빼야 한다.
  /// null 인 채로 두면 "&coordinate" 로 값 없이 나가고, 네이버가
  /// {"error":{"errorCode":500,"message":"좌표검색 API 호출 실패"}} 를 400 으로 돌려준다
  /// (2026-10-15 실측).
  Map<String, dynamic> toJson() => {
        "query": query,
        "page": page,
        "count": count,
        if (coordinate != null) "coordinate": coordinate,
      };
}
