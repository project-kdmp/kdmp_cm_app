import 'package:kdmp_cm_app/data/constant/client_info.dart';

class LostChildListRequest {
  String clientVersion = ClientInfo.clientVersion;
  String clientId = ClientInfo.clientId;
  String mbrAddressSido;
  String mbrAddressSigungu;

  LostChildListRequest({
    required this.mbrAddressSido,
    required this.mbrAddressSigungu,
  });

  Map<String, dynamic> toJson() => {
        "clientVersion": clientVersion,
        "clientId": clientId,
        "mbrAddressSido": mbrAddressSido,
        "mbrAddressSigungu": mbrAddressSigungu,
      };
}
