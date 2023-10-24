import 'package:kdmp_cm_app/data/model/common/state.dart';
import 'package:kdmp_cm_app/data/model/work/driving_request.dart';
import 'package:kdmp_cm_app/domain/repository/work/work_repository.dart';

class GetDrivingUseCase {
  final WorkRepository _workRepository;

  GetDrivingUseCase({required WorkRepository workRepository}) : _workRepository = workRepository;

  Future<StateAPI> execute({required DrivingRequest drivingRequest}) async {
    return await _workRepository.getDriving(drivingRequest: drivingRequest);
  }
}
