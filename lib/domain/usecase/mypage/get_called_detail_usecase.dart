import 'package:kdmp_cm_app/data/model/common/state.dart';
import 'package:kdmp_cm_app/data/model/mypage/called_detail_request.dart';
import 'package:kdmp_cm_app/domain/repository/mypage/mypage_repository.dart';

class GetCalledDetailUseCase {
  final MyPageRepository _myPageRepository;

  GetCalledDetailUseCase({required MyPageRepository myPageRepository}) : _myPageRepository = myPageRepository;

  Future<StateAPI> execute({required CalledDetailRequest calledDetailRequest}) async {
    return await _myPageRepository.getCalledDetail(calledDetailRequest: calledDetailRequest);
  }
}
