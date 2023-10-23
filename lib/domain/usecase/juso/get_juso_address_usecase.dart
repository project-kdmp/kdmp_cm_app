import 'package:kdmp_cm_app/data/model/common/state.dart';
import 'package:kdmp_cm_app/data/model/juso/juso_list_request.dart';
import 'package:kdmp_cm_app/domain/repository/juso/juso_repository.dart';

class GetJusoListUseCase {
  final JusoRepository _jusoRepository;

  GetJusoListUseCase({required JusoRepository jusoRepository}) : _jusoRepository = jusoRepository;

  Future<StateAPI> execute({required JusoListRequest jusoListRequest}) async {
    return await _jusoRepository.getJusoList(jusoListRequest: jusoListRequest);
  }
}
