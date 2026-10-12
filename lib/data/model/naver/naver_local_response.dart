/// 네이버 지역(장소) 검색 응답 — NCP API Hub `/search/v1/local`.
class NaverLocalResponse {
  int total;
  List<NaverPlace> items;

  NaverLocalResponse({
    required this.total,
    required this.items,
  });

  factory NaverLocalResponse.fromJson(Map<String, dynamic> json) => NaverLocalResponse(
        total: json["total"] ?? 0,
        items: ((json["items"] ?? []) as List)
            .map((e) => NaverPlace.fromJson(e))
            .toList(),
      );
}

class NaverPlace {
  /// 장소명. 검색어가 <b></b> 로 강조돼 오므로 태그를 떼어낸다.
  String title;
  String roadAddress;
  String address;

  NaverPlace({
    required this.title,
    required this.roadAddress,
    required this.address,
  });

  factory NaverPlace.fromJson(Map<String, dynamic> json) => NaverPlace(
        title: _stripTags(json["title"] ?? ""),
        roadAddress: json["roadAddress"] ?? "",
        address: json["address"] ?? "",
      );

  static String _stripTags(String s) => s.replaceAll(RegExp(r"<[^>]+>"), "");
}
