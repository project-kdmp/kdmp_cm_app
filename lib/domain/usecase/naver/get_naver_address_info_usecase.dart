import 'package:kdmp_cm_app/data/model/common/state.dart';
import 'package:kdmp_cm_app/data/model/naver/geocoding_request.dart';
import 'package:kdmp_cm_app/domain/repository/naver/naver_repository.dart';

class GetNaverAddressInfoUseCase {
  final NaverRepository _naverRepository;

  GetNaverAddressInfoUseCase({required NaverRepository naverRepository}) : _naverRepository = naverRepository;

  Future<StateAPI> execute({required String clientId, required String clientSecret, required GeocodingRequest geocodingRequest}) async {
    return await _naverRepository.getAddressInfo(clientId: clientId, clientSecret: clientSecret, geocodingRequest: geocodingRequest);
  }
}
