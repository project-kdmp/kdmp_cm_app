import 'package:flutter/foundation.dart';
import 'package:kdmp_cm_app/data/model/common/map_data_model.dart';
import 'package:kdmp_cm_app/data/model/common/state.dart';
import 'package:kdmp_cm_app/data/model/juso/juso_list_request.dart';
import 'package:kdmp_cm_app/data/model/juso/juso_list_response.dart';
import 'package:kdmp_cm_app/data/model/naver/geocoding_request.dart';
import 'package:kdmp_cm_app/data/model/naver/naver_local_request.dart';
import 'package:kdmp_cm_app/domain/usecase/juso/get_juso_address_usecase.dart';
import 'package:kdmp_cm_app/domain/usecase/naver/get_naver_address_info_usecase.dart';
import 'package:kdmp_cm_app/domain/usecase/naver/search_naver_local_usecase.dart';
import 'package:kdmp_cm_app/domain/usecase/secure_storage/mbr/add_mapdata_usecase.dart';
import 'package:kdmp_cm_app/domain/usecase/secure_storage/mbr/get_mapdata_list_usecase.dart';
import 'package:kdmp_cm_app/domain/usecase/secure_storage/mbr/get_mbrsq_usecase.dart';

class EndSearchViewModel {
  EndSearchViewModel({
    required this.getMbrSqUseCase,
    required this.getNaverAddressInfoUseCase,
    required this.getJusoListUseCase,
    required this.getMapDataListUseCase,
    required this.addMapDataUseCase,
    required this.searchNaverLocalUseCase,
  });

  final GetMbrSqUseCase getMbrSqUseCase;
  final GetNaverAddressInfoUseCase getNaverAddressInfoUseCase;
  final GetJusoListUseCase getJusoListUseCase;
  final GetMapDataListUseCase getMapDataListUseCase;
  final AddMapDataUseCase addMapDataUseCase;
  final SearchNaverLocalUseCase searchNaverLocalUseCase;

  /// 자동 검색을 시작하는 최소 글자 수
  static const int minKeywordLength = 2;

  String clientId = "";
  String clientSecret = "";
  String jusoApiKey = "";

  /// 네이버 지역(장소) 검색용 키 (NCP API Hub) — 지도 키와 별개다.
  String searchClientId = "";
  String searchClientSecret = "";

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

  /// 검색을 시작했다고 볼 만한 길이인가. 한 글자로는 주소를 좁힐 수 없다
  bool get hasSearchableKeyword => keyword.trim().length >= minKeywordLength;

  _checkRecentListValid() {
    /// 첫 글자를 치는 동안에는 최근 검색 기록을 남겨둔다. 안 그러면 한 글자
    /// 쳤을 때 기록이 사라지고 결과도 없어 화면이 통째로 빈다
    bool valid;
    if (searchList.isEmpty && !hasSearchableKeyword && recentList.isNotEmpty) {
      valid = true;
    } else {
      valid = false;
    }
    isRecentListValid = valid;
  }

  /// 상태
  StateAPI state = Loading();

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

    /// 어떤 검색어로 부른 요청인지 기억해 둔다
    final requested = keyword;

    /// 첫 페이지에서만 네이버 장소(POI) 검색을 함께 한다. 도로명주소 API 가
    /// 못 찾는 공항·역·상호 같은 통칭을 찾아 결과 맨 앞에 보여준다.
    final bool isFirstPage = page == 0;
    List<Juso> placeList = [];
    if (isFirstPage) {
      placeList = await _searchPlaces(requested);
      if (requested != keyword) return state;
    }

    final request = JusoListRequest(
      countPerPage: 10,
      currentPage: page + 1,
      keyword: keyword,
      confmKey: jusoApiKey,
    );
    final result = await getJusoListUseCase.execute(jusoListRequest: request);
    state = result;

    /// 치는 사이에 검색어가 바뀌었으면 이 응답은 버린다. 자동 검색은 요청이
    /// 겹치기 쉬운데, 늦게 온 응답이 새 검색어의 목록에 섞이면 엉뚱한 주소가 남는다
    if (requested != keyword) return result;

    List<Juso> copyList = List.from(searchList);
    if (isFirstPage) copyList.addAll(placeList);
    if (result is Success) {
      final response = result.jusoListResponse;
      final jusoList = response.results.juso;
      if (jusoList.isNotEmpty) {
        page++;
      }
      copyList.addAll(jusoList);
    }
    searchList = copyList;

    return result;
  }

  /// 네이버 지역검색으로 장소(POI)를 찾아 도로명주소 목록 형태로 변환한다.
  /// 실패하면 빈 목록을 돌려 도로명주소 검색만 보여준다.
  Future<List<Juso>> _searchPlaces(String keyword) async {
    if (searchClientId.isEmpty) return [];
    final result = await searchNaverLocalUseCase.execute(
      clientId: searchClientId,
      clientSecret: searchClientSecret,
      naverLocalRequest: NaverLocalRequest(query: keyword),
    );
    if (result is Success) {
      return result.naverLocalResponse.items
          .map((p) => Juso.place(
                bdNm: p.title,
                roadAddr: p.roadAddress,
                jibunAddr: p.address,
              ))
          .toList();
    }
    return [];
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
