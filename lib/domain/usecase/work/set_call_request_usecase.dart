import 'package:kdmp_cm_app/data/model/common/state.dart';
import 'package:kdmp_cm_app/data/model/work/call_request.dart';
import 'package:kdmp_cm_app/domain/repository/work/work_repository.dart';

class SetCallRequestUseCase {
  final WorkRepository _workRepository;

  SetCallRequestUseCase({required WorkRepository workRepository}) : _workRepository = workRepository;

  Future<StateAPI> execute({required CallRequest callRequest}) async {
    return await _workRepository.requestCall(callRequest: callRequest);
  }
}
