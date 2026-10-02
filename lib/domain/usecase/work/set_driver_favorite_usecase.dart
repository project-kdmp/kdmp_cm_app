import 'package:kdmp_cm_app/data/model/common/state.dart';
import 'package:kdmp_cm_app/data/model/work/driver_favorite_request.dart';
import 'package:kdmp_cm_app/domain/repository/work/work_repository.dart';

class SetDriverFavoriteUseCase {
  final WorkRepository _workRepository;

  SetDriverFavoriteUseCase({required WorkRepository workRepository}) : _workRepository = workRepository;

  Future<StateAPI> execute({required DriverFavoriteRequest driverFavoriteRequest}) async {
    return await _workRepository.setDriverFavorite(driverFavoriteRequest: driverFavoriteRequest);
  }
}
