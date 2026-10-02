import 'package:kdmp_cm_app/data/constant/client_info.dart';

/// 단골 기사 등록·해제 요청
class DriverFavoriteRequest {
  String clientVersion = ClientInfo.clientVersion;
  String clientId = ClientInfo.clientId;
  int mbrSq;
  int mbrDmSq;
  String favorYn;

  DriverFavoriteRequest({
    required this.mbrSq,
    required this.mbrDmSq,
    required this.favorYn,
  });

  Map<String, dynamic> toJson() => {
        "clientVersion": clientVersion,
        "clientId": clientId,
        "mbrSq": mbrSq,
        "mbrDmSq": mbrDmSq,
        "favorYn": favorYn,
      };
}
