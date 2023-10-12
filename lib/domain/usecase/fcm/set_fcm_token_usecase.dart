import 'package:kdmp_cm_app/data/model/common/state.dart';
import 'package:kdmp_cm_app/data/model/fcm/fcm_token_request.dart';
import 'package:kdmp_cm_app/domain/repository/fcm/fcm_repository.dart';

class SetFCMTokenUseCase {
  final FCMRepository _fcmRepository;

  SetFCMTokenUseCase({required FCMRepository fcmRepository}) : _fcmRepository = fcmRepository;

  Future<StateAPI> execute({required FCMTokenRequest fcmTokenRequest}) async {
    return await _fcmRepository.setToken(fcmTokenRequest: fcmTokenRequest);
  }
}
