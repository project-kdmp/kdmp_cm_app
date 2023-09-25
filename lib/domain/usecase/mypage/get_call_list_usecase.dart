import 'package:kdmp_cm_app/data/model/common/state.dart';
import 'package:kdmp_cm_app/data/model/mypage/call_list_request.dart';
import 'package:kdmp_cm_app/domain/repository/mypage/mypage_repository.dart';

class GetCallListUseCase {
  final MyPageRepository _myPageRepository;

  GetCallListUseCase({required MyPageRepository myPageRepository}) : _myPageRepository = myPageRepository;

  Future<StateAPI> execute({required CallListRequest callListRequest}) async {
    return await _myPageRepository.getCallList(callListRequest: callListRequest);
  }
}
