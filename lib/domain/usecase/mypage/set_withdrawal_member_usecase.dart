import 'package:kdmp_cm_app/data/model/common/default_request.dart';
import 'package:kdmp_cm_app/data/model/common/state.dart';
import 'package:kdmp_cm_app/domain/repository/mypage/mypage_repository.dart';

class SetWithdrawalMemberUseCase {
  final MyPageRepository _myPageRepository;

  SetWithdrawalMemberUseCase({required MyPageRepository myPageRepository}) : _myPageRepository = myPageRepository;

  Future<StateAPI> execute({required DefaultRequest withdrawalMemberRequest}) async {
    return await _myPageRepository.withdrawalMember(withdrawalMemberRequest: withdrawalMemberRequest);
  }
}
