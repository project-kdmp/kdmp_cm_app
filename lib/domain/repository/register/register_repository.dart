import 'package:kdmp_cm_app/data/model/common/state.dart';
import 'package:kdmp_cm_app/data/model/register/register_request.dart';
import 'package:kdmp_cm_app/data/model/register/service_stop_request.dart';

abstract class RegisterRepository {
  Future<StateAPI> register({required RegisterRequest registerRequest});

  Future<StateAPI> getServiceStop({required ServiceStopRequest serviceStopRequest});
}
