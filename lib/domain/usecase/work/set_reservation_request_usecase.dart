import 'package:kdmp_cm_app/data/model/common/state.dart';
import 'package:kdmp_cm_app/data/model/work/call_request.dart';
import 'package:kdmp_cm_app/domain/repository/work/work_repository.dart';

class SetReservationRequestUseCase {
  final WorkRepository _workRepository;

  SetReservationRequestUseCase({required WorkRepository workRepository}) : _workRepository = workRepository;

  Future<StateAPI> execute({required CallRequest reservationRequest}) async {
    return await _workRepository.requestReservation(reservationRequest: reservationRequest);
  }
}
