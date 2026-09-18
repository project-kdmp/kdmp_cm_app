import 'package:kdmp_cm_app/data/model/auth/verify_request.dart';
import 'package:kdmp_cm_app/data/model/common/state.dart';
import 'package:kdmp_cm_app/domain/usecase/auth/verify/get_verify_info_usecase.dart';
import 'package:kdmp_cm_app/domain/usecase/secure_storage/mbr/get_mbrci_usecase.dart';
import 'package:kdmp_cm_app/domain/usecase/secure_storage/mbr/get_mbrsq_usecase.dart';
import 'package:kdmp_cm_app/domain/usecase/secure_storage/mbr/set_mbrci_usecase.dart';

class PhoneVerifyViewModel {
  PhoneVerifyViewModel({
    required this.getMbrSqUseCase,
    required this.getMbrCIUseCase,
    required this.setMbrCIUseCase,
    required this.getVerifyInfoUseCase,
  });

  final GetMbrSqUseCase getMbrSqUseCase;
  final GetMbrCiUseCase getMbrCIUseCase;
  final SetMbrCiUseCase setMbrCIUseCase;
  final GetVerifyInfoUseCase getVerifyInfoUseCase;

  /// 상태
  StateAPI state = Loading();

  /// 실제 발급받은 CI 인지 여부
  ///
  /// 가입은 SMS 소유 확인만 하고 CI 를 받지 못해 "ci_test_휴대폰뒷4자리" 임시값을 저장한다.
  /// (register_verify_screen.dart 참고)
  static bool isRealCi(String ci) => ci.isNotEmpty && !ci.startsWith("ci_test_");

  /// 본인확인
  ///
  /// 단말에 실제 CI 가 있으면 이번 인증 결과와 대조한다.
  /// 임시값뿐이라 대조할 기준이 없으면, 이번 인증에서 받은 실제 CI 를 기준값으로 저장하고 통과시킨다.
  /// 그 다음 등록부터는 대조가 동작한다.
  Future<bool> verify({required String mbrCi}) async {
    final savedCi = await getMbrCIUseCase.execute();

    if (!isRealCi(savedCi)) {
      if (isRealCi(mbrCi)) {
        await setMbrCIUseCase.execute(mbrCi: mbrCi);
      }
      return true;
    }

    return savedCi == mbrCi;
  }

  /// 회원번호 조회
  Future<int> getMbrSq() async {
    return await getMbrSqUseCase.execute();
  }

  /// 본인확인
  Future<StateAPI> getVerifyInfo({required String value}) async {
    state = Loading();

    final request = VerifyRequest(value: value);
    final result = await getVerifyInfoUseCase.execute(verifyRequest: request);
    state = result;

    return result;
  }
}
