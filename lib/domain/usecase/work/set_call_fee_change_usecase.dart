import 'package:kdmp_cm_app/data/model/common/state.dart';
import 'package:kdmp_cm_app/data/model/work/call_fee_change_request.dart';
import 'package:kdmp_cm_app/domain/repository/work/work_repository.dart';

class SetCallFeeChangeUseCase {
  final WorkRepository _workRepository;

  SetCallFeeChangeUseCase({required WorkRepository workRepository}) : _workRepository = workRepository;

  Future<StateAPI> execute({required CallFeeChangeRequest callFeeChangeRequest}) async {
    return await _workRepository.changeCallFee(callFeeChangeRequest: callFeeChangeRequest);
  }
}
