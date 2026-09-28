import 'package:flutter/cupertino.dart';
import 'package:kdmp_cm_app/data/model/common/default_request.dart';
import 'package:kdmp_cm_app/data/model/common/state.dart';
import 'package:kdmp_cm_app/data/model/mypage/car_add_request.dart';
import 'package:kdmp_cm_app/data/model/mypage/car_delete_request.dart';
import 'package:kdmp_cm_app/data/model/mypage/car_list_response.dart';
import 'package:kdmp_cm_app/data/model/mypage/car_modify_request.dart';
import 'package:kdmp_cm_app/domain/usecase/mypage/get_car_list_usecase.dart';
import 'package:kdmp_cm_app/domain/usecase/mypage/set_car_add_usecase.dart';
import 'package:kdmp_cm_app/domain/usecase/mypage/set_car_delete_usecase.dart';
import 'package:kdmp_cm_app/domain/usecase/mypage/set_car_modify_usecase.dart';
import 'package:kdmp_cm_app/domain/usecase/secure_storage/mbr/get_mbrsq_usecase.dart';

class CarInfoViewModel {
  CarInfoViewModel({
    required this.getMbrSqUseCase,
    required this.getCarListUseCase,
    required this.setCarAddUseCase,
    required this.setCarModifyUseCase,
    required this.setCarDeleteUseCase,
  });

  final GetMbrSqUseCase getMbrSqUseCase;
  final GetCarListUseCase getCarListUseCase;
  final SetCarAddUseCase setCarAddUseCase;
  final SetCarModifyUseCase setCarModifyUseCase;
  final SetCarDeleteUseCase setCarDeleteUseCase;

  /// 차량정보 리스트
  final ValueNotifier<List<Car>> _carList = ValueNotifier<List<Car>>(List.empty());

  ValueNotifier<List<Car>> get carListNotifier => _carList;

  List<Car> get carList => _carList.value;

  set carList(List<Car> value) => _carList.value = value;

  /// 상태
  /// 조회 상태.
  ///
  /// 평범한 필드면 값을 바꿔도 화면이 다시 그려지지 않는다. 그래서 화면은 목록이
  /// 비었을 때 불러오는 중인지 없는 것인지 실패인지 구분하지 못했다
  final ValueNotifier<StateAPI> _state = ValueNotifier<StateAPI>(Loading());

  ValueNotifier<StateAPI> get stateNotifier => _state;

  StateAPI get state => _state.value;

  set state(StateAPI value) => _state.value = value;

  /// 차량정보 리스트 조회 API
  Future<StateAPI> getCarList() async {
    state = Loading();

    final mbrSq = await getMbrSqUseCase.execute();

    final request = DefaultRequest(mbrSq: mbrSq);
    final result = await getCarListUseCase.execute(getCarListRequest: request);
    state = result;

    if (result is Success) {
      final response = result.carListResponse;
      carList = response.resultList;
    }

    return result;
  }

  /// 차량정보 수정 API
  Future<StateAPI> modifyCarInfo({required String beforeCarNumId, required String afterCarNumId}) async {
    state = Loading();

    final mbrSq = await getMbrSqUseCase.execute();

    final request = CarModifyRequest(
      mbrSq: mbrSq,
      beforeCarNumId: beforeCarNumId,
      afterCarNumId: afterCarNumId,
    );
    final result = await setCarModifyUseCase.execute(carModifyRequest: request);
    state = result;

    return result;
  }

  /// 차량정보 등록 API
  Future<StateAPI> addCarInfo(String carNumId) async {
    state = Loading();

    final mbrSq = await getMbrSqUseCase.execute();

    final request = CarAddRequest(
      mbrSq: mbrSq,
      carNumId: carNumId,
    );
    final result = await setCarAddUseCase.execute(carAddRequest: request);
    state = result;

    return result;
  }

  /// 차량정보 삭제 API
  Future<StateAPI> deleteCarInfo(String carNumId) async {
    state = Loading();

    final mbrSq = await getMbrSqUseCase.execute();

    final request = CarDeleteRequest(
      mbrSq: mbrSq,
      carNumId: carNumId,
    );
    final result = await setCarDeleteUseCase.execute(carDeleteRequest: request);
    state = result;

    return result;
  }
}
