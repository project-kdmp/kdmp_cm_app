import 'package:kdmp_cm_app/data/model/common/state.dart';
import 'package:kdmp_cm_app/data/model/juso/juso_list_request.dart';

abstract class JusoRepository {
  Future<StateAPI> getJusoList({required JusoListRequest jusoListRequest});
}
