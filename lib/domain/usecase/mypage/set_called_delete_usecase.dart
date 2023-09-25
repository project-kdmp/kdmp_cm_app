import 'package:kdmp_cm_app/data/model/common/drv_request.dart';
import 'package:kdmp_cm_app/data/model/common/state.dart';
import 'package:kdmp_cm_app/domain/repository/mypage/mypage_repository.dart';

class SetCalledDeleteUseCase {
  final MyPageRepository _myPageRepository;

  SetCalledDeleteUseCase({required MyPageRepository myPageRepository}) : _myPageRepository = myPageRepository;

  Future<StateAPI> execute({required DrvRequest calledDeleteRequest}) async {
    return await _myPageRepository.deleteCalled(calledDeleteRequest: calledDeleteRequest);
  }
}
