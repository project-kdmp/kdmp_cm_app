import 'package:kdmp_cm_app/data/constant/client_info.dart';

/// 기사 목록 조회 요청. 탭(최근·단골·주변)과 이름·기사번호 검색이 같은 API 를 쓰고
/// searchTp 로만 갈린다. 주변 탭일 때만 좌표를 싣는다.
class DriverListRequest {
  String clientVersion = ClientInfo.clientVersion;
  String clientId = ClientInfo.clientId;
  int mbrSq;
  String searchTp;
  String? keyword;
  double? gpsLat;
  double? gpsLong;

  DriverListRequest({
    required this.mbrSq,
    required this.searchTp,
    this.keyword,
    this.gpsLat,
    this.gpsLong,
  });

  Map<String, dynamic> toJson() => {
        "clientVersion": clientVersion,
        "clientId": clientId,
        "mbrSq": mbrSq,
        "searchTp": searchTp,
        "keyword": keyword ?? "",
        "gpsLat": gpsLat,
        "gpsLong": gpsLong,
      };
}
