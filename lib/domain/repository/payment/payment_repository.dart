import 'package:kdmp_cm_app/data/model/common/state.dart';
import 'package:kdmp_cm_app/data/model/payment/toss_billingkey_request.dart';

abstract class PaymentRepository {
  Future<StateAPI> setTossBillingKey({required TossBillingKeyRequest tossBillingKeyRequest});
}
