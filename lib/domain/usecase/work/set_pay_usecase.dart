import 'package:kdmp_cm_app/data/model/common/state.dart';
import 'package:kdmp_cm_app/data/model/work/pay_request.dart';
import 'package:kdmp_cm_app/domain/repository/work/work_repository.dart';

class SetPayUseCase {
  final WorkRepository _workRepository;

  SetPayUseCase({required WorkRepository workRepository}) : _workRepository = workRepository;

  Future<StateAPI> execute({required PayRequest payRequest}) async {
    return await _workRepository.setPay(payRequest: payRequest);
  }
}
