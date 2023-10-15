import 'package:flutter/cupertino.dart';
import 'package:kdmp_cm_app/data/model/common/default_request.dart';
import 'package:kdmp_cm_app/data/model/common/state.dart';
import 'package:kdmp_cm_app/data/model/mypage/place_delete_request.dart';
import 'package:kdmp_cm_app/data/model/mypage/place_list_response.dart';
import 'package:kdmp_cm_app/domain/usecase/mypage/get_place_list_usecase.dart';
import 'package:kdmp_cm_app/domain/usecase/mypage/set_place_delete_usecase.dart';
import 'package:kdmp_cm_app/domain/usecase/secure_storage/mbr/get_mbrsq_usecase.dart';

class PlaceViewModel {
  PlaceViewModel({
    required this.getMbrSqUseCase,
    required this.getPlaceListUseCase,
    required this.setPlaceDeleteUseCase,
  });

  final GetMbrSqUseCase getMbrSqUseCase;
  final GetPlaceListUseCase getPlaceListUseCase;
  final SetPlaceDeleteUseCase setPlaceDeleteUseCase;

  /// 자주 가는 장소 리스트
  final ValueNotifier<List<Place>> _placeList = ValueNotifier<List<Place>>(List.empty());

  ValueNotifier<List<Place>> get placeListNotifier => _placeList;

  List<Place> get placeList => _placeList.value;

  set placeList(List<Place> value) => _placeList.value = value;

  /// 상태
  StateAPI state = Loading();

  /// 자주 가는 장소 리스트 조회 API
  Future<StateAPI> getPlaceList() async {
    state = Loading();

    final mbrSq = await getMbrSqUseCase.execute();

    final request = DefaultRequest(mbrSq: mbrSq);
    final result = await getPlaceListUseCase.execute(getPlaceListRequest: request);
    state = result;

    if (result is Success) {
      final response = result.placeListResponse;
      placeList = response.resultList;
    }

    return result;
  }

  /// 자주 가는 장소 삭제 API
  Future<StateAPI> deletePlace(int fplaceSq) async {
    state = Loading();

    final request = PlaceDeleteRequest(fplaceSq: fplaceSq);
    final result = await setPlaceDeleteUseCase.execute(placeDeleteRequest: request);
    state = result;

    return result;
  }
}
