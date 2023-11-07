import 'package:kdmp_cm_app/data/model/common/state.dart';
import 'package:kdmp_cm_app/data/model/policy/policy_request.dart';
import 'package:kdmp_cm_app/domain/repository/policy/policy_repository.dart';

class GetPolicyUseCase {
  final PolicyRepository _policyRepository;

  GetPolicyUseCase({required PolicyRepository policyRepository}) : _policyRepository = policyRepository;

  Future<StateAPI> execute({required PolicyRequest policyRequest}) async {
    return await _policyRepository.getPolicy(policyRequest: policyRequest);
  }
}
