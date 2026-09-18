import 'package:flutter/material.dart';
import 'package:kdmp_cm_app/data/model/common/favorite_address_model.dart';
import 'package:kdmp_cm_app/data/model/common/map_data_model.dart';
import 'package:kdmp_cm_app/domain/usecase/secure_storage/mbr/get_favorite_address_list_usecase.dart';
import 'package:kdmp_cm_app/domain/usecase/secure_storage/mbr/set_favorite_address_list_usecase.dart';

class FavoriteAddressViewModel {
  final GetFavoriteAddressListUseCase getFavoriteAddressListUseCase;
  final SetFavoriteAddressListUseCase setFavoriteAddressListUseCase;

  FavoriteAddressViewModel({
    required this.getFavoriteAddressListUseCase,
    required this.setFavoriteAddressListUseCase,
  });

  /// 자주 가는 주소 리스트
  final ValueNotifier<List<FavoriteAddress>> _favoriteAddressList = ValueNotifier<List<FavoriteAddress>>(List.empty());

  ValueNotifier<List<FavoriteAddress>> get favoriteAddressListNotifier => _favoriteAddressList;

  List<FavoriteAddress> get favoriteAddressList => _favoriteAddressList.value;

  /// 로컬에 저장된 리스트 조회
  Future<void> getFavoriteAddressList() async {
    _favoriteAddressList.value = await getFavoriteAddressListUseCase.execute();
  }

  /// 이름으로 조회 (미등록이면 null)
  MapData? getMapData({required String name}) {
    for (final favorite in favoriteAddressList) {
      if (favorite.name == name) return favorite.mapData;
    }
    return null;
  }

  /// 등록 및 변경 (같은 이름이 있으면 덮어쓴다)
  Future<void> setFavoriteAddress({required String name, required MapData mapData}) async {
    final list = List<FavoriteAddress>.from(favoriteAddressList);
    list.removeWhere((favorite) => favorite.name == name);
    list.add(FavoriteAddress(name: name, mapData: mapData));

    await setFavoriteAddressListUseCase.execute(favoriteAddressList: list);
    _favoriteAddressList.value = list;
  }

  /// 등록 삭제
  Future<void> deleteFavoriteAddress({required String name}) async {
    final list = List<FavoriteAddress>.from(favoriteAddressList);
    list.removeWhere((favorite) => favorite.name == name);

    await setFavoriteAddressListUseCase.execute(favoriteAddressList: list);
    _favoriteAddressList.value = list;
  }
}
