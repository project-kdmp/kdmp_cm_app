import 'package:flutter/foundation.dart';
import 'package:kdmp_cm_app/data/model/common/default_request.dart';
import 'package:kdmp_cm_app/data/model/common/map_data_model.dart';
import 'package:kdmp_cm_app/data/model/common/state.dart';
import 'package:kdmp_cm_app/data/model/juso/juso_list_request.dart';
import 'package:kdmp_cm_app/data/model/juso/juso_list_response.dart';
import 'package:kdmp_cm_app/data/model/mypage/place_list_response.dart';
import 'package:kdmp_cm_app/data/model/naver/geocoding_request.dart';
import 'package:kdmp_cm_app/domain/usecase/juso/get_juso_address_usecase.dart';
import 'package:kdmp_cm_app/domain/usecase/mypage/get_place_list_usecase.dart';
import 'package:kdmp_cm_app/domain/usecase/naver/get_naver_address_info_usecase.dart';
import 'package:kdmp_cm_app/domain/usecase/secure_storage/mbr/add_mapdata_usecase.dart';
import 'package:kdmp_cm_app/domain/usecase/secure_storage/mbr/get_mapdata_list_usecase.dart';
import 'package:kdmp_cm_app/domain/usecase/secure_storage/mbr/get_mbrsq_usecase.dart';

class EndSearchViewModel {
  EndSearchViewModel({
    required this.getMbrSqUseCase,
    required this.getNaverAddressInfoUseCase,
    required this.getJusoListUseCase,
    required this.getPlaceListUseCase,
    required this.getMapDataListUseCase,
    required this.addMapDataUseCase,
  });

  final GetMbrSqUseCase getMbrSqUseCase;
  final GetNaverAddressInfoUseCase getNaverAddressInfoUseCase;
  final GetJusoListUseCase getJusoListUseCase;
  final GetPlaceListUseCase getPlaceListUseCase;
  final GetMapDataListUseCase getMapDataListUseCase;
  final AddMapDataUseCase addMapDataUseCase;

  String clientId = "";
  String clientSecret = "";
  String jusoApiKey = "";

  /// 자주 가는 장소 리스트
  final ValueNotifier<List<Place>> _placeList = ValueNotifier<List<Place>>(List.empty());

  ValueNotifier<List<Place>> get placeListNotifier => _placeList;

  List<Place> get placeList => _placeList.value;

  set placeList(List<Place> value) => _placeList.value = value;

  /// 현재 페이지
  final ValueNotifier<int> _page = ValueNotifier<int>(1);

  ValueNotifier<int> get pageNotifier => _page;

  int get page => _page.value;

  set page(int value) => _page.value = value;

  /// 검색어
  final ValueNotifier<String> _keyword = ValueNotifier<String>("");

  ValueNotifier<String> get keywordNotifier => _keyword;

  String get keyword => _keyword.value;

  set keyword(String value) {
    _keyword.value = value;
    page = 1;
  }

  /// 검색 리스트
  final ValueNotifier<List<Juso>> _searchList = ValueNotifier<List<Juso>>(List.empty());

  ValueNotifier<List<Juso>> get searchListNotifier => _searchList;

  List<Juso> get searchList => _searchList.value;

  set searchList(List<Juso> value) {
    _searchList.value = value;
    _checkRecentListValid();
  }

  /// 최근 검색 리스트
  final ValueNotifier<List<MapData>> _recentList = ValueNotifier<List<MapData>>(List.empty());

  ValueNotifier<List<MapData>> get recentListNotifier => _recentList;

  List<MapData> get recentList => _recentList.value;

  set recentList(List<MapData> value) {
    _recentList.value = value;
    _checkRecentListValid();
  }

  /// 최근 검색 리스트 활성화 여부
  final ValueNotifier<bool> _isRecentListValid = ValueNotifier<bool>(false);

  ValueNotifier<bool> get isRecentListValidNotifier => _isRecentListValid;

  bool get isRecentListValid => _isRecentListValid.value;

  set isRecentListValid(bool value) => _isRecentListValid.value = value;

  _checkRecentListValid() {
    bool valid;
    if (searchList.isEmpty && keyword.isEmpty && recentList.isNotEmpty) {
      valid = true;
    } else {
      valid = false;
    }
    isRecentListValid = valid;
  }

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

  /// 검색한 장소 정보 조회 API
  Future<StateAPI> getAddressInfo({required String address}) async {
    state = Loading();

    final request = GeocodingRequest(
      query: address,
      page: 1,
      count: 1,
    );
    final result = await getNaverAddressInfoUseCase.execute(
      clientId: clientId,
      clientSecret: clientSecret,
      geocodingRequest: request,
    );
    state = result;

    if (result is Success && result.geocodingResponse.addresses != null && result.geocodingResponse.addresses!.isNotEmpty) {
      return result;
    }
    return Fail(errorMessage: "해당 장소 정보를 조회할 수 없습니다.");
  }

  /// 검색 리스트 조회 API
  Future<StateAPI> getSearchList() async {
    state = Loading();

    final request = JusoListRequest(
      countPerPage: 10,
      currentPage: page + 1,
      keyword: keyword,
      confmKey: jusoApiKey,
    );
    final result = await getJusoListUseCase.execute(jusoListRequest: request);
    state = result;

    if (result is Success) {
      final response = result.jusoListResponse;
      final jusoList = response.results.juso;
      if (jusoList.isNotEmpty) {
        page++;
      }
      List<Juso> copyList = List.from(searchList);
      copyList.addAll(jusoList);
      searchList = copyList;
    }

    return result;
  }

  /// 페이지 정보 초기화
  void clearPagination() {
    page = 0;
    searchList = List.empty();
  }

  /// 최근 검색 장소 리스트 조회
  Future<void> getRecentList() async {
    recentList = await getMapDataListUseCase.execute();
  }

  /// 최근 검색 장소 추가
  Future<void> addRecentMapData({required MapData mapData}) async {
    await addMapDataUseCase.execute(mapData: mapData);
  }
}
