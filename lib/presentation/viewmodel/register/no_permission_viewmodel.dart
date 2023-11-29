import 'package:flutter/foundation.dart';
import 'package:kdmp_cm_app/data/model/common/state.dart';
import 'package:kdmp_cm_app/data/model/register/service_stop_request.dart';
import 'package:kdmp_cm_app/domain/usecase/register/get_service_stop_usecase.dart';
import 'package:kdmp_cm_app/domain/usecase/secure_storage/mbr/get_mbrsq_usecase.dart';

class NoPermissionViewModel {
  final GetMbrSqUseCase getMbrSqUseCase;
  final GetServiceStopUseCase getServiceStopUseCase;

  NoPermissionViewModel({
    required this.getMbrSqUseCase,
    required this.getServiceStopUseCase,
  });

  /// 정지 사유
  final ValueNotifier<String> _serviceStop = ValueNotifier<String>("");

  ValueNotifier<String> get serviceStopNotifier => _serviceStop;

  String get serviceStop => _serviceStop.value;

  set serviceStop(String value) => _serviceStop.value = value;

  /// 상태
  StateAPI state = Loading();

  Future<StateAPI> getServiceStop() async {
    state = Loading();

    final mbrSq = await getMbrSqUseCase.execute();

    final request = ServiceStopRequest(cmMbrSq: mbrSq);
    final result = await getServiceStopUseCase.execute(serviceStopRequest: request);
    state = result;

    if (result is Success) {
      serviceStop = result.serviceStopResponse.stopSvrContent;
    }

    return result;
  }
}
