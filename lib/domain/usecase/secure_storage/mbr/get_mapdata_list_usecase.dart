import 'package:kdmp_cm_app/data/model/common/map_data_model.dart';

import '../../../repository/secure_storage/secure_storage_repository.dart';

class GetMapDataListUseCase {
  final SecureStorageRepository _secureStorageRepository;

  GetMapDataListUseCase({required SecureStorageRepository secureStorageRepository}) : _secureStorageRepository = secureStorageRepository;

  Future<List<MapData>> execute() async {
    return await _secureStorageRepository.getMapDataList();
  }
}
