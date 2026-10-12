import 'package:kdmp_cm_app/data/model/common/state.dart';
import 'package:kdmp_cm_app/data/model/naver/naver_local_request.dart';
import 'package:kdmp_cm_app/domain/repository/naver/naver_repository.dart';

class SearchNaverLocalUseCase {
  final NaverRepository _naverRepository;

  SearchNaverLocalUseCase({required NaverRepository naverRepository}) : _naverRepository = naverRepository;

  Future<StateAPI> execute({required String clientId, required String clientSecret, required NaverLocalRequest naverLocalRequest}) async {
    return await _naverRepository.searchLocal(clientId: clientId, clientSecret: clientSecret, naverLocalRequest: naverLocalRequest);
  }
}
