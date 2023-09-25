import 'package:kdmp_cm_app/data/model/common/drv_request.dart';
import 'package:kdmp_cm_app/data/model/common/state.dart';
import 'package:kdmp_cm_app/domain/repository/work/work_repository.dart';

class GetCallInfoUseCase {
  final WorkRepository _workRepository;

  GetCallInfoUseCase({required WorkRepository workRepository}) : _workRepository = workRepository;

  Future<StateAPI> execute({required DrvRequest getCallInfoRequest}) async {
    return await _workRepository.getCallInfo(getCallInfoRequest: getCallInfoRequest);
  }
}
