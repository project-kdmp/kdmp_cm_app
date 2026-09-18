import 'package:kdmp_cm_app/data/model/common/favorite_address_model.dart';

import '../../../repository/secure_storage/secure_storage_repository.dart';

class GetFavoriteAddressListUseCase {
  final SecureStorageRepository _secureStorageRepository;

  GetFavoriteAddressListUseCase({required SecureStorageRepository secureStorageRepository}) : _secureStorageRepository = secureStorageRepository;

  Future<List<FavoriteAddress>> execute() async {
    return await _secureStorageRepository.getFavoriteAddressList();
  }
}
