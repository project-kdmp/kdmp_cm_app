import "package:flutter_naver_map/flutter_naver_map.dart";
import "package:kdmp_cm_app/data/model/common/map_data_model.dart";
import "package:kdmp_cm_app/data/model/common/state.dart";
import "package:kdmp_cm_app/data/model/naver/reverse_geocoding_request.dart";
import "package:kdmp_cm_app/domain/usecase/naver/get_naver_address_usecase.dart";
import "package:kdmp_cm_app/presentation/util/string_util.dart";

class NaverMapViewModel {
  NaverMapViewModel({
    required this.clientId,
    required this.clientSecret,
    required this.getNaverAddressUseCase,
  });

  final String clientId;
  final String clientSecret;
  final GetNaverAddressUseCase getNaverAddressUseCase;

  /// 상태
  StateAPI state = Loading();

  /// 좌표로 장소 조회 API
  Future<MapData> getAddress({required NLatLng nLatLng}) async {
    state = Loading();

    String coordinate = "";
    coordinate = "${nLatLng.longitude},${nLatLng.latitude}";

    final request = ReverseGeocodingRequest(coords: coordinate);
    final result = await getNaverAddressUseCase.execute(
      clientId: clientId,
      clientSecret: clientSecret,
      reverseGeocodingRequest: request,
    );
    state = result;

    String newAddress = "";
    String newPlace = "";

    if (result is Success) {
      final response = result.reverseGeocodingResponse;
      newAddress = makeAddress(response.results);
      newPlace = makePlace(response.results);
    }

    return MapData(
      address: newAddress,
      place: newPlace,
      latLng: nLatLng,
      drivingAddress: DrivingAddress(sido: "", sigungu: "", legalDong: ""),
    );
  }
}
