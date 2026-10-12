class NaverLocalRequest {
  String query;
  int display;

  NaverLocalRequest({
    required this.query,
    this.display = 5,
  });

  /// 네이버 지역검색은 display 최대 5건이다.
  Map<String, dynamic> toJson() => {
        "query": query,
        "display": display,
      };
}
