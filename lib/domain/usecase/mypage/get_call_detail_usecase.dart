import 'package:kdmp_cm_app/data/model/common/state.dart';
import 'package:kdmp_cm_app/data/model/mypage/call_detail_request.dart';
import 'package:kdmp_cm_app/domain/repository/mypage/mypage_repository.dart';

class GetCallDetailUseCase {
  final MyPageRepository _myPageRepository;

  GetCallDetailUseCase({required MyPageRepository myPageRepository}) : _myPageRepository = myPageRepository;

  Future<StateAPI> execute({required CallDetailRequest callDetailRequest}) async {
    return await _myPageRepository.getCallDetail(callDetailRequest: callDetailRequest);
  }
}
