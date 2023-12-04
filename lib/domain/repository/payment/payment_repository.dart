import 'package:kdmp_cm_app/data/model/common/state.dart';
import 'package:kdmp_cm_app/data/model/payment/kgmobil_billingkey_request.dart';

abstract class PaymentRepository {
  Future<StateAPI> setKGMobilBillingKey({required KGMobilBillingKeyRequest kgMobilBillingKeyRequest});
}
