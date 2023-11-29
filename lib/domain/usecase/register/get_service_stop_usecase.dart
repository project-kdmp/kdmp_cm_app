import 'package:kdmp_cm_app/data/model/common/state.dart';
import 'package:kdmp_cm_app/data/model/register/service_stop_request.dart';
import 'package:kdmp_cm_app/domain/repository/register/register_repository.dart';

class GetServiceStopUseCase {
  final RegisterRepository _registerRepository;

  GetServiceStopUseCase({required RegisterRepository registerRepository}) : _registerRepository = registerRepository;

  Future<StateAPI> execute({required ServiceStopRequest serviceStopRequest}) async {
    return await _registerRepository.getServiceStop(serviceStopRequest: serviceStopRequest);
  }
}
