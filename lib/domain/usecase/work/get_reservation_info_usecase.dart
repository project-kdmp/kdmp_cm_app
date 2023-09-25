import 'package:kdmp_cm_app/data/model/common/drv_request.dart';
import 'package:kdmp_cm_app/data/model/common/state.dart';
import 'package:kdmp_cm_app/domain/repository/work/work_repository.dart';

class GetReservationInfoUseCase {
  final WorkRepository _workRepository;

  GetReservationInfoUseCase({required WorkRepository workRepository}) : _workRepository = workRepository;

  Future<StateAPI> execute({required DrvRequest getReservationInfoRequest}) async {
    return await _workRepository.getReservationInfo(getReservationInfoRequest: getReservationInfoRequest);
  }
}
