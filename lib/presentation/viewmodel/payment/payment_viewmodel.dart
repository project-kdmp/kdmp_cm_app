import 'package:kdmp_cm_app/domain/usecase/secure_storage/mbr/get_payment_password_usecase.dart';

class PaymentViewModel {
  PaymentViewModel({
    required this.getPaymentPasswordUseCase,
  });

  final GetPaymentPasswordUseCase getPaymentPasswordUseCase;

  /// 결제 비밀번호 설정 여부
  Future<bool> isSetPaymentPassword() async {
    final password = await getPaymentPasswordUseCase.execute();
    return password.isNotEmpty;
  }
}
