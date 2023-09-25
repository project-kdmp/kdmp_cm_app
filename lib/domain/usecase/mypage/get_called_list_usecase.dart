import 'package:kdmp_cm_app/data/model/common/state.dart';
import 'package:kdmp_cm_app/data/model/mypage/called_list_request.dart';
import 'package:kdmp_cm_app/domain/repository/mypage/mypage_repository.dart';

class GetCalledListUseCase {
  final MyPageRepository _myPageRepository;

  GetCalledListUseCase({required MyPageRepository myPageRepository}) : _myPageRepository = myPageRepository;

  Future<StateAPI> execute({required CalledListRequest calledListRequest}) async {
    return await _myPageRepository.getCalledList(calledListRequest: calledListRequest);
  }
}
