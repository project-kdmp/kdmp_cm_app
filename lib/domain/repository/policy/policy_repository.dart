import 'package:kdmp_cm_app/data/model/common/state.dart';
import 'package:kdmp_cm_app/data/model/policy/policy_request.dart';

abstract class PolicyRepository {
  Future<StateAPI> getPolicy({required PolicyRequest policyRequest});
}
