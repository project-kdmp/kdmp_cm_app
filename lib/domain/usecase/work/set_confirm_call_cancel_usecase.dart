import 'package:kdmp_cm_app/data/model/common/state.dart';
import 'package:kdmp_cm_app/data/model/work/confirm_call_cancel_request.dart';
import 'package:kdmp_cm_app/domain/repository/work/work_repository.dart';

class SetConfirmCallCancelUseCase {
  final WorkRepository _workRepository;

  SetConfirmCallCancelUseCase({required WorkRepository workRepository}) : _workRepository = workRepository;

  Future<StateAPI> execute({required ConfirmCallCancelRequest confirmCallCancelRequest}) async {
    return await _workRepository.cancelConfirmCall(confirmCallCancelRequest: confirmCallCancelRequest);
  }
}
