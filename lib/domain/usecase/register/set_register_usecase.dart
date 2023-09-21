import 'package:kdmp_cm_app/data/model/register/register_request.dart';
import 'package:kdmp_cm_app/data/model/common/state.dart';
import 'package:kdmp_cm_app/domain/repository/register/register_repository.dart';

class SetRegisterUseCase {
  final RegisterRepository _registerRepository;

  SetRegisterUseCase({required RegisterRepository registerRepository}) : _registerRepository = registerRepository;

  Future<StateAPI> execute({required RegisterRequest registerRequest}) async {
    return await _registerRepository.register(registerRequest: registerRequest);
  }
}
