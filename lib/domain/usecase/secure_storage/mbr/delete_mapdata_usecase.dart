import 'package:kdmp_cm_app/data/model/common/map_data_model.dart';

import '../../../repository/secure_storage/secure_storage_repository.dart';

class DeleteMapDataUseCase {
  final SecureStorageRepository _secureStorageRepository;

  DeleteMapDataUseCase({required SecureStorageRepository secureStorageRepository}) : _secureStorageRepository = secureStorageRepository;

  Future<void> execute({required List<MapData> deleteMapDataList}) async {
    final mapDataList = await _secureStorageRepository.getMapDataList();
    for (int i = 0; i < deleteMapDataList.length; i++) {
      for (int j = 0; j < mapDataList.length; j++) {
        if (mapDataList[j].latLng == deleteMapDataList[i].latLng) {
          mapDataList.removeAt(j);
          break;
        }
      }
    }
    await _secureStorageRepository.setMapDataList(mapDataList: mapDataList);
  }
}
