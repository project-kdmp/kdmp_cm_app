import 'package:flutter_naver_map/flutter_naver_map.dart';

import '../../../repository/secure_storage/secure_storage_repository.dart';

class DeleteMapDataUseCase {
  final SecureStorageRepository _secureStorageRepository;

  DeleteMapDataUseCase({required SecureStorageRepository secureStorageRepository}) : _secureStorageRepository = secureStorageRepository;

  Future<void> execute({required NLatLng latLng}) async {
    final mapDataList = await _secureStorageRepository.getMapDataList();
    for (int i = 0; i < mapDataList.length; i++) {
      if (mapDataList[i].latLng == latLng) {
        mapDataList.removeAt(i);
      }
    }
    await _secureStorageRepository.setMapDataList(mapDataList: mapDataList);
  }
}
