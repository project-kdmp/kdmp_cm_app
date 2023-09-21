import 'package:kdmp_cm_app/domain/usecase/secure_storage/mbr/set_onboarding_check_usecase.dart';

class OnBoardingViewModel {
  OnBoardingViewModel({
    required this.setOnBoardingCheckUseCase,
  });

  final SetOnBoardingCheckUseCase setOnBoardingCheckUseCase;

  /// 온보딩 확인 여부 저장
  Future<void> setOnBoardingCheck() async {
    await setOnBoardingCheckUseCase.execute(isOnBoardingCheck: true);
  }
}
