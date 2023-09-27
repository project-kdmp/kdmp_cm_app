import 'package:kdmp_cm_app/data/model/common/state.dart';
import 'package:kdmp_cm_app/data/model/naver/directions_request.dart';
import 'package:kdmp_cm_app/domain/repository/naver/naver_repository.dart';

class GetNaverPriceUseCase {
  final NaverRepository _naverRepository;

  GetNaverPriceUseCase({required NaverRepository naverRepository}) : _naverRepository = naverRepository;

  Future<StateAPI> execute({required String clientId, required String clientSecret, required DirectionsRequest directionsRequest}) async {
    return await _naverRepository.getPrice(clientId: clientId, clientSecret: clientSecret, directionsRequest: directionsRequest);
  }
}
