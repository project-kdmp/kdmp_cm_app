import 'package:kdmp_cm_app/data/model/common/state.dart';
import 'package:kdmp_cm_app/data/model/naver/reverse_geocoding_request.dart';
import 'package:kdmp_cm_app/domain/repository/naver/naver_repository.dart';

class GetNaverAddressUseCase {
  final NaverRepository _naverRepository;

  GetNaverAddressUseCase({required NaverRepository naverRepository}) : _naverRepository = naverRepository;

  Future<StateAPI> execute({required String clientId, required String clientSecret, required ReverseGeocodingRequest reverseGeocodingRequest}) async {
    return await _naverRepository.getAddress(clientId: clientId, clientSecret: clientSecret, reverseGeocodingRequest: reverseGeocodingRequest);
  }
}
