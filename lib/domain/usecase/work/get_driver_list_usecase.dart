import 'package:kdmp_cm_app/data/model/common/state.dart';
import 'package:kdmp_cm_app/data/model/work/driver_list_request.dart';
import 'package:kdmp_cm_app/domain/repository/work/work_repository.dart';

class GetDriverListUseCase {
  final WorkRepository _workRepository;

  GetDriverListUseCase({required WorkRepository workRepository}) : _workRepository = workRepository;

  Future<StateAPI> execute({required DriverListRequest driverListRequest}) async {
    return await _workRepository.getDriverList(driverListRequest: driverListRequest);
  }
}
