import 'package:kdmp_cm_app/data/model/common/state.dart';
import 'package:kdmp_cm_app/data/model/work/call_info_change_request.dart';
import 'package:kdmp_cm_app/domain/repository/work/work_repository.dart';

class SetCallInfoChangeUseCase {
  final WorkRepository _workRepository;

  SetCallInfoChangeUseCase({required WorkRepository workRepository}) : _workRepository = workRepository;

  Future<StateAPI> execute({required CallInfoChangeRequest callInfoChangeRequest}) async {
    return await _workRepository.changeCallInfo(callInfoChangeRequest: callInfoChangeRequest);
  }
}
