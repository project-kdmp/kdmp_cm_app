import 'package:kdmp_cm_app/data/model/common/state.dart';
import 'package:kdmp_cm_app/data/model/fcm/fcm_push_request.dart';
import 'package:kdmp_cm_app/domain/repository/fcm/fcm_repository.dart';

class SetFCMPushUseCase {
  final FCMRepository _fcmRepository;

  SetFCMPushUseCase({required FCMRepository fcmRepository}) : _fcmRepository = fcmRepository;

  Future<StateAPI> execute({required FCMPushRequest fcmPushRequest}) async {
    return await _fcmRepository.sendPush(fcmPushRequest: fcmPushRequest);
  }
}
