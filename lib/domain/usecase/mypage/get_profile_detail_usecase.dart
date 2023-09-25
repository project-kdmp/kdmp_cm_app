import 'package:kdmp_cm_app/data/model/common/default_request.dart';
import 'package:kdmp_cm_app/data/model/common/state.dart';
import 'package:kdmp_cm_app/domain/repository/mypage/mypage_repository.dart';

class GetProfileDetailUseCase {
  final MyPageRepository _myPageRepository;

  GetProfileDetailUseCase({required MyPageRepository myPageRepository}) : _myPageRepository = myPageRepository;

  Future<StateAPI> execute({required DefaultRequest getProfileRequest}) async {
    return await _myPageRepository.getProfileDetail(getProfileRequest: getProfileRequest);
  }
}
