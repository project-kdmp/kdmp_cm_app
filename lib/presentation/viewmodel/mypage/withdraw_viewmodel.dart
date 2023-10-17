import 'package:kdmp_cm_app/data/model/common/default_request.dart';
import 'package:kdmp_cm_app/data/model/common/state.dart';
import 'package:kdmp_cm_app/domain/usecase/mypage/set_withdrawal_member_usecase.dart';
import 'package:kdmp_cm_app/domain/usecase/secure_storage/mbr/delete_user_data_usecase.dart';
import 'package:kdmp_cm_app/domain/usecase/secure_storage/mbr/get_mbrsq_usecase.dart';

class WithdrawViewModel {
  WithdrawViewModel({
    required this.getMbrSqUseCase,
    required this.setWithdrawalMemberUseCase,
    required this.deleteUserDataUseCase,
  });

  final GetMbrSqUseCase getMbrSqUseCase;
  final SetWithdrawalMemberUseCase setWithdrawalMemberUseCase;
  final DeleteUserDataUseCase deleteUserDataUseCase;

  /// 상태
  StateAPI state = Loading();

  /// 탈퇴하기 API
  Future<StateAPI> withdraw() async {
    state = Loading();

    final mbrSq = await getMbrSqUseCase.execute();

    final request = DefaultRequest(mbrSq: mbrSq);
    final result = await setWithdrawalMemberUseCase.execute(withdrawalMemberRequest: request);
    state = result;

    if (result is Success) {
      await deleteUserDataUseCase.withdrawal();
    }

    return result;
  }
}
