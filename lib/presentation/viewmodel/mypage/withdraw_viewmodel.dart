import 'package:flutter/cupertino.dart';
import 'package:kdmp_cm_app/data/constant/client_info.dart';
import 'package:kdmp_cm_app/data/model/common/default_request.dart';
import 'package:kdmp_cm_app/data/model/common/policy_model.dart';
import 'package:kdmp_cm_app/data/model/common/state.dart';
import 'package:kdmp_cm_app/data/model/policy/policy_request.dart';
import 'package:kdmp_cm_app/domain/usecase/mypage/set_withdrawal_member_usecase.dart';
import 'package:kdmp_cm_app/domain/usecase/policy/get_policy_usecase.dart';
import 'package:kdmp_cm_app/domain/usecase/secure_storage/mbr/delete_user_data_usecase.dart';
import 'package:kdmp_cm_app/domain/usecase/secure_storage/mbr/get_mbrsq_usecase.dart';

class WithdrawViewModel {
  WithdrawViewModel({
    required this.getMbrSqUseCase,
    required this.setWithdrawalMemberUseCase,
    required this.deleteUserDataUseCase,
    required this.getPolicyUseCase,
  });

  final GetMbrSqUseCase getMbrSqUseCase;
  final SetWithdrawalMemberUseCase setWithdrawalMemberUseCase;
  final DeleteUserDataUseCase deleteUserDataUseCase;
  final GetPolicyUseCase getPolicyUseCase;

  /// 탈퇴 정책
  final ValueNotifier<Policy> _policy = ValueNotifier<Policy>(Policy(title: "", content: ""));

  ValueNotifier<Policy> get policyNotifier => _policy;

  Policy get policy => _policy.value;

  set policy(Policy value) => _policy.value = value;

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
      ClientInfo.setClientId = "";
      await deleteUserDataUseCase.withdrawal();
    }

    return result;
  }

  /// 정책 조회 API
  Future<void> getPolicy({required String policyTp}) async {
    final request = PolicyRequest(policyTp: policyTp);
    final result = await getPolicyUseCase.execute(policyRequest: request);

    if (result is Success) {
      final response = result.policyResponse;
      policy = Policy(title: response.policyTitle, content: response.policyContent);
    }
  }
}
