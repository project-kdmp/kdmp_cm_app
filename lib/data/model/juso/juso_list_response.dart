class JusoListResponse {
  List<Juso> documents;
  Meta meta;

  JusoListResponse({
    required this.documents,
    required this.meta,
  });

  factory JusoListResponse.fromJson(Map<String, dynamic> json) => JusoListResponse(
        documents: List<Juso>.from(json["documents"].map((x) => Juso.fromJson(x))),
        meta: Meta.fromJson(json["meta"]),
      );

  Map<String, dynamic> toJson() => {
        "documents": List<dynamic>.from(documents.map((x) => x.toJson())),
        "meta": meta.toJson(),
      };
}

class Juso {
  String addressName;
  String categoryGroupCode;
  String categoryGroupName;
  String categoryName;
  String distance;
  String id;
  String phone;
  String placeName;
  String placeUrl;
  String roadAddressName;
  String x;
  String y;

  Juso({
    required this.addressName,
    required this.categoryGroupCode,
    required this.categoryGroupName,
    required this.categoryName,
    required this.distance,
    required this.id,
    required this.phone,
    required this.placeName,
    required this.placeUrl,
    required this.roadAddressName,
    required this.x,
    required this.y,
  });

  factory Juso.fromJson(Map<String, dynamic> json) => Juso(
        addressName: json["address_name"],
        categoryGroupCode: json["category_group_code"],
        categoryGroupName: json["category_group_name"],
        categoryName: json["category_name"],
        distance: json["distance"],
        id: json["id"],
        phone: json["phone"],
        placeName: json["place_name"],
        placeUrl: json["place_url"],
        roadAddressName: json["road_address_name"],
        x: json["x"],
        y: json["y"],
      );

  Map<String, dynamic> toJson() => {
        "address_name": addressName,
        "category_group_code": categoryGroupCode,
        "category_group_name": categoryGroupName,
        "category_name": categoryName,
        "distance": distance,
        "id": id,
        "phone": phone,
        "place_name": placeName,
        "place_url": placeUrl,
        "road_address_name": roadAddressName,
        "x": x,
        "y": y,
      };
}

class Meta {
  bool isEnd;
  int pageableCount;
  SameName sameName;
  int totalCount;

  Meta({
    required this.isEnd,
    required this.pageableCount,
    required this.sameName,
    required this.totalCount,
  });

  factory Meta.fromJson(Map<String, dynamic> json) => Meta(
        isEnd: json["is_end"],
        pageableCount: json["pageable_count"],
        sameName: SameName.fromJson(json["same_name"]),
        totalCount: json["total_count"],
      );

  Map<String, dynamic> toJson() => {
        "is_end": isEnd,
        "pageable_count": pageableCount,
        "same_name": sameName.toJson(),
        "total_count": totalCount,
      };
}

class SameName {
  String keyword;
  List<dynamic> region;
  String selectedRegion;

  SameName({
    required this.keyword,
    required this.region,
    required this.selectedRegion,
  });

  factory SameName.fromJson(Map<String, dynamic> json) => SameName(
        keyword: json["keyword"],
        region: List<dynamic>.from(json["region"].map((x) => x)),
        selectedRegion: json["selected_region"],
      );

  Map<String, dynamic> toJson() => {
        "keyword": keyword,
        "region": List<dynamic>.from(region.map((x) => x)),
        "selected_region": selectedRegion,
      };
}
