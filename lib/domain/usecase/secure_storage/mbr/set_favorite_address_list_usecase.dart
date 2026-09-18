import 'package:kdmp_cm_app/data/model/common/favorite_address_model.dart';

import '../../../repository/secure_storage/secure_storage_repository.dart';

class SetFavoriteAddressListUseCase {
  final SecureStorageRepository _secureStorageRepository;

  SetFavoriteAddressListUseCase({required SecureStorageRepository secureStorageRepository}) : _secureStorageRepository = secureStorageRepository;

  Future<void> execute({required List<FavoriteAddress> favoriteAddressList}) async {
    await _secureStorageRepository.setFavoriteAddressList(favoriteAddressList: favoriteAddressList);
  }
}
