import 'package:flutter/cupertino.dart';
import 'package:kdmp_cm_app/data/constant/codes.dart';
import 'package:kdmp_cm_app/data/model/common/state.dart';
import 'package:kdmp_cm_app/data/model/work/driver_favorite_request.dart';
import 'package:kdmp_cm_app/data/model/work/driver_list_request.dart';
import 'package:kdmp_cm_app/data/model/work/driver_list_response.dart';
import 'package:kdmp_cm_app/domain/usecase/secure_storage/mbr/get_mbrsq_usecase.dart';
import 'package:kdmp_cm_app/domain/usecase/work/get_driver_list_usecase.dart';
import 'package:kdmp_cm_app/domain/usecase/work/set_driver_favorite_usecase.dart';

class DriverSelectViewModel {
  DriverSelectViewModel({
    required this.getMbrSqUseCase,
    required this.getDriverListUseCase,
    required this.setDriverFavoriteUseCase,
    required this.gpsLat,
    required this.gpsLong,
  });

  final GetMbrSqUseCase getMbrSqUseCase;
  final GetDriverListUseCase getDriverListUseCase;
  final SetDriverFavoriteUseCase setDriverFavoriteUseCase;

  /// 주변 탭에서 거리 계산 기준이 되는 출발지 좌표
  final double gpsLat;
  final double gpsLong;

  /// 조회 상태
  final ValueNotifier<StateAPI> _state = ValueNotifier<StateAPI>(Loading());

  ValueNotifier<StateAPI> get stateNotifier => _state;

  StateAPI get state => _state.value;

  set state(StateAPI value) => _state.value = value;

  /// 탭. 검색어를 치는 동안에는 탭과 무관하게 keyword 조회로 넘어간다
  final ValueNotifier<String> _tabTp = ValueNotifier<String>(DrvSearchTp.recent);

  ValueNotifier<String> get tabTpNotifier => _tabTp;

  String get tabTp => _tabTp.value;

  set tabTp(String value) {
    _tabTp.value = value;
    getDriverList();
  }

  String keyword = "";

  bool get hasSearchableKeyword => keyword.trim().isNotEmpty;

  /// 기사 목록
  final ValueNotifier<List<Driver>> _driverList = ValueNotifier<List<Driver>>(List.empty());

  ValueNotifier<List<Driver>> get driverListNotifier => _driverList;

  List<Driver> get driverList => _driverList.value;

  set driverList(List<Driver> value) => _driverList.value = value;

  /// 선택한 기사
  final ValueNotifier<Driver?> _selectedDriver = ValueNotifier<Driver?>(null);

  ValueNotifier<Driver?> get selectedDriverNotifier => _selectedDriver;

  Driver? get selectedDriver => _selectedDriver.value;

  set selectedDriver(Driver? value) => _selectedDriver.value = value;

  /// 기사 목록 조회. 검색어가 있으면 탭 대신 검색으로 조회한다
  Future<void> getDriverList() async {
    state = Loading();

    final mbrSq = await getMbrSqUseCase.execute();
    final searchTp = hasSearchableKeyword ? DrvSearchTp.keyword : tabTp;
    final isNearby = searchTp == DrvSearchTp.nearby;

    final request = DriverListRequest(
      mbrSq: mbrSq,
      searchTp: searchTp,
      keyword: hasSearchableKeyword ? keyword.trim() : null,
      gpsLat: isNearby ? gpsLat : null,
      gpsLong: isNearby ? gpsLong : null,
    );
    final result = await getDriverListUseCase.execute(driverListRequest: request);

    if (result is Success) {
      driverList = result.driverListResponse.resultList;
    } else {
      driverList = List.empty();
    }
    state = result;
  }

  /// 단골 등록·해제. 서버가 받아들인 뒤에만 목록의 표시를 바꾼다
  Future<void> toggleFavorite(Driver driver) async {
    final mbrSq = await getMbrSqUseCase.execute();
    final favorYn = driver.isFavorite ? "N" : "Y";

    final request = DriverFavoriteRequest(
      mbrSq: mbrSq,
      mbrDmSq: driver.mbrDmSq,
      favorYn: favorYn,
    );
    final result = await setDriverFavoriteUseCase.execute(driverFavoriteRequest: request);
    if (result is! Success) return;

    /// 단골 탭에서 해제하면 목록에서 빠져야 하므로 다시 조회한다
    if (tabTp == DrvSearchTp.favorite && !hasSearchableKeyword) {
      await getDriverList();
      return;
    }

    driver.favorYn = favorYn;
    driverList = List.from(driverList);
    if (selectedDriver?.mbrDmSq == driver.mbrDmSq) {
      selectedDriver = driver;
    }
  }

  /// 오프라인 기사는 지정해도 콜을 받을 수 없으므로 고르지 못하게 한다
  bool isSelectable(Driver driver) => driver.drvWorkSt != DrvWorkSt.off;
}
