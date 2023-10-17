import 'package:kdmp_cm_app/data/model/common/state.dart';
import 'package:kdmp_cm_app/domain/usecase/secure_storage/mbr/get_mbrci_usecase.dart';

class PhoneVerifyViewModel {
  PhoneVerifyViewModel({
    required this.getMbrCIUseCase,
  });

  final GetMbrCiUseCase getMbrCIUseCase;

  /// 상태
  StateAPI state = Loading();

  /// 본인확인
  Future<bool> verify({required String mbrCi}) async {
    final result = await getMbrCIUseCase.execute();
    return result == mbrCi;
  }
}
