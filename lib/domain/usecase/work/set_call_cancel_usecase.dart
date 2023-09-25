import 'package:kdmp_cm_app/data/model/common/state.dart';
import 'package:kdmp_cm_app/data/model/work/call_cancel_request.dart';
import 'package:kdmp_cm_app/domain/repository/work/work_repository.dart';

class SetCallCancelUseCase {
  final WorkRepository _workRepository;

  SetCallCancelUseCase({required WorkRepository workRepository}) : _workRepository = workRepository;

  Future<StateAPI> execute({required CallCancelRequest callCancelRequest}) async {
    return await _workRepository.cancelCall(callCancelRequest: callCancelRequest);
  }
}
