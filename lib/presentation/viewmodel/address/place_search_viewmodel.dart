import 'package:flutter/foundation.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:kdmp_cm_app/data/model/common/state.dart';
import 'package:kdmp_cm_app/data/model/naver/geocoding_request.dart';
import 'package:kdmp_cm_app/data/model/naver/geocoding_response.dart';
import 'package:kdmp_cm_app/domain/usecase/mypage/get_place_list_usecase.dart';
import 'package:kdmp_cm_app/domain/usecase/naver/get_naver_address_info_usecase.dart';
import 'package:kdmp_cm_app/domain/usecase/secure_storage/mbr/get_mbrsq_usecase.dart';

class PlaceSearchViewModel {
  PlaceSearchViewModel({
    required this.getMbrSqUseCase,
    required this.getNaverAddressInfoUseCase,
    required this.getPlaceListUseCase,
  });

  final GetMbrSqUseCase getMbrSqUseCase;
  final GetNaverAddressInfoUseCase getNaverAddressInfoUseCase;
  final GetPlaceListUseCase getPlaceListUseCase;

  String clientId = "";
  String clientSecret = "";

  /// 현위치 좌표
  NLatLng? currentLatLng;

  /// 현재 페이지
  final ValueNotifier<int> _page = ValueNotifier<int>(1);

  ValueNotifier<int> get pageNotifier => _page;

  int get page => _page.value;

  set page(int value) => _page.value = value;

  /// 다음 페이지 유무
  final ValueNotifier<bool> _isNextPage = ValueNotifier<bool>(true);

  ValueNotifier<bool> get isNextPageNotifier => _isNextPage;

  bool get isNextPage => _isNextPage.value;

  set isNextPage(bool value) => _isNextPage.value = value;

  /// 검색어
  final ValueNotifier<String> _keyword = ValueNotifier<String>("");

  ValueNotifier<String> get keywordNotifier => _keyword;

  String get keyword => _keyword.value;

  set keyword(String value) {
    _keyword.value = value;
    page = 1;
  }

  /// 검색 리스트
  final ValueNotifier<List<Address>> _searchList = ValueNotifier<List<Address>>(List.empty());

  ValueNotifier<List<Address>> get searchListNotifier => _searchList;

  List<Address> get searchList => _searchList.value;

  set searchList(List<Address> value) => _searchList.value = value;

  /// 최근 검색 리스트
  final ValueNotifier<List<String>> _recentList = ValueNotifier<List<String>>(List.empty());

  ValueNotifier<List<String>> get recentListNotifier => _recentList;

  List<String> get recentList => _recentList.value;

  set recentList(List<String> value) => _recentList.value = value;

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

  /// 검색 리스트 조회 API
  Future<void> getSearchList() async {
    state = Loading();

    String coordinate = "";
    if (currentLatLng != null) {
      coordinate = "${currentLatLng!.longitude},${currentLatLng!.latitude}";
    }

    final request = GeocodingRequest(
      query: keyword,
      page: page,
      count: 20,
      coordinate: coordinate,
    );
    final result = await getNaverAddressInfoUseCase.execute(
      clientId: clientId,
      clientSecret: clientSecret,
      geocodingRequest: request,
    );
    state = result;

    if (result is Success) {
      final response = result.geocodingResponse;

      if (response.addresses != null && response.addresses!.isNotEmpty) {
        page++;
      }

      searchList = response.addresses ?? List.empty();
      _checkRecentListValid();
    }
  }

  // TODO: 최근 검색 리스트 조회
  Future<void> getRecentList() async {}
}
