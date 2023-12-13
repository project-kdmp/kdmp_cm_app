import 'package:kdmp_cm_app/data/model/auth/verify_request.dart';
import 'package:kdmp_cm_app/data/model/common/state.dart';
import 'package:kdmp_cm_app/domain/usecase/auth/verify/get_verify_info_usecase.dart';
import 'package:kdmp_cm_app/domain/usecase/secure_storage/mbr/get_mbrci_usecase.dart';
import 'package:kdmp_cm_app/domain/usecase/secure_storage/mbr/get_mbrsq_usecase.dart';

class PhoneVerifyViewModel {
  PhoneVerifyViewModel({
    required this.getMbrSqUseCase,
    required this.getMbrCIUseCase,
    required this.getVerifyInfoUseCase,
  });

  final GetMbrSqUseCase getMbrSqUseCase;
  final GetMbrCiUseCase getMbrCIUseCase;
  final GetVerifyInfoUseCase getVerifyInfoUseCase;

  /// 상태
  StateAPI state = Loading();

  /// 본인확인
  Future<bool> verify({required String mbrCi}) async {
    final result = await getMbrCIUseCase.execute();
    return result == mbrCi;
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
