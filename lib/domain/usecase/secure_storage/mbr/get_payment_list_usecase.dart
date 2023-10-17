import 'package:kdmp_cm_app/data/model/payment/payment_model.dart';

import '../../../repository/secure_storage/secure_storage_repository.dart';

class GetPaymentListUseCase {
  final SecureStorageRepository _secureStorageRepository;

  GetPaymentListUseCase({required SecureStorageRepository secureStorageRepository}) : _secureStorageRepository = secureStorageRepository;

  Future<List<Payment>> execute() async {
    return await _secureStorageRepository.getPaymentList();
  }
}
