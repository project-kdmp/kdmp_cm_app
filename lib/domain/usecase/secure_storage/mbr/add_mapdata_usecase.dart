import 'package:kdmp_cm_app/data/model/common/map_data_model.dart';

import '../../../repository/secure_storage/secure_storage_repository.dart';

class AddMapDataUseCase {
  final SecureStorageRepository _secureStorageRepository;

  AddMapDataUseCase({required SecureStorageRepository secureStorageRepository}) : _secureStorageRepository = secureStorageRepository;

  Future<void> execute({required MapData mapData}) async {
    final mapDataList = await _secureStorageRepository.getMapDataList();
    for (int i = 0; i < mapDataList.length; i++) {
      if (mapDataList[i].address == mapData.address) {
        mapDataList.removeAt(i);
      }
    }
    mapDataList.insert(0, mapData);
    final maxLength = mapDataList.length > 20 ? 20 : mapDataList.length;
    await _secureStorageRepository.setMapDataList(mapDataList: mapDataList.sublist(0, maxLength));
  }
}
