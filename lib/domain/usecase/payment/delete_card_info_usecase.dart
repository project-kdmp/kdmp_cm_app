import 'package:kdmp_cm_app/data/model/common/state.dart';
import 'package:kdmp_cm_app/data/model/payment/delete_card_info_request.dart';
import 'package:kdmp_cm_app/data/model/payment/kgmobil_billingkey_request.dart';
import 'package:kdmp_cm_app/domain/repository/payment/payment_repository.dart';

class DeleteCardInfoUseCase {
  final PaymentRepository _paymentRepository;

  DeleteCardInfoUseCase({required PaymentRepository paymentRepository}) : _paymentRepository = paymentRepository;

  Future<StateAPI> execute({required DeleteCardInfoRequest deleteCardInfoRequest}) async {
    return await _paymentRepository.deleteCardInfo(deleteCardInfoRequest: deleteCardInfoRequest);
  }
}
