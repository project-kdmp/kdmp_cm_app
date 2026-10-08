import 'package:kdmp_cm_app/data/model/common/state.dart';
import 'package:kdmp_cm_app/data/model/work/driving_request.dart';
import 'package:kdmp_cm_app/domain/repository/work/work_repository.dart';

class GetNowDrivingListUseCase {
  final WorkRepository _workRepository;

  GetNowDrivingListUseCase({required WorkRepository workRepository}) : _workRepository = workRepository;

  Future<StateAPI> execute({required DrivingRequest drivingRequest}) async {
    return await _workRepository.getNowDrivingList(drivingRequest: drivingRequest);
  }
}
