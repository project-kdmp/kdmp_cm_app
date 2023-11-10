import 'package:kdmp_cm_app/data/model/common/state.dart';
import 'package:kdmp_cm_app/data/model/work/driving_price_request.dart';
import 'package:kdmp_cm_app/domain/repository/work/work_repository.dart';

class GetDrivingPriceUseCase {
  final WorkRepository _workRepository;

  GetDrivingPriceUseCase({required WorkRepository workRepository}) : _workRepository = workRepository;

  Future<StateAPI> execute({required DrivingPriceRequest drivingPriceRequest}) async {
    return await _workRepository.getDrivingPrice(drivingPriceRequest: drivingPriceRequest);
  }
}
