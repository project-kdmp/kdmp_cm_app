import 'package:kdmp_cm_app/data/model/common/map_data_model.dart';

/// 자주 가는 주소 (집, 회사 등 이름을 붙여 단말에 저장한다)
///
/// 서버에 보관 API 가 없어 secure storage 에만 둔다. 기기를 바꾸면 사라진다.
class FavoriteAddress {
  String name;
  MapData mapData;

  FavoriteAddress({
    required this.name,
    required this.mapData,
  });

  factory FavoriteAddress.fromJson(Map<String, dynamic> json) => FavoriteAddress(
        name: json["name"],
        mapData: MapData.fromJson(json["mapData"]),
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "mapData": mapData,
      };
}
