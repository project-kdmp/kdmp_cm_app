import 'package:flutter/foundation.dart';
import 'package:kdmp_cm_app/data/model/common/state.dart';
import 'package:kdmp_cm_app/domain/usecase/secure_storage/mbr/get_mbrsq_usecase.dart';

class StartSearchViewModel {
  StartSearchViewModel({
    required this.getMbrSqUseCase,
  });

  final GetMbrSqUseCase getMbrSqUseCase;

  /// 현재 페이지
  final ValueNotifier<int> _page = ValueNotifier<int>(0);

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

  set keyword(String value) => _keyword.value = value;

  /// 검색 리스트
  final ValueNotifier<List<String>> _searchList = ValueNotifier<List<String>>(List.empty());

  ValueNotifier<List<String>> get searchListNotifier => _searchList;

  List<String> get searchList => _searchList.value;

  set searchList(List<String> value) => _searchList.value = value;

  /// 최근 검색 리스트
  final ValueNotifier<List<String>> _recentList = ValueNotifier<List<String>>(List.empty());

  ValueNotifier<List<String>> get recentListNotifier => _recentList;

  List<String> get recentList => _recentList.value;

  set recentList(List<String> value) => _recentList.value = value;

  /// 최근 검색 리스트 활성화 여부
  final ValueNotifier<bool> _isRecentListValid = ValueNotifier<bool>(true);

  ValueNotifier<bool> get isRecentListValidNotifier => _isRecentListValid;

  bool get isRecentListValid => _isRecentListValid.value;

  set isRecentListValid(bool value) => _isRecentListValid.value = value;

  _checkRecentListValid() {
    bool valid;
    if (searchList.isEmpty && keyword.isEmpty) {
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
    if (!isNextPage) {
      return;
    }

    state = Loading();

    // final mbrSq = await getMbrSqUseCase.execute();
    //
    // final request = CalledListRequest(
    //   page: page + 1,
    //   pageSize: 10,
    //   mbrDmSq: mbrSq,
    //   keyword: keyword.trim(),
    // );
    // final result = await getCalledListUseCase.execute(searchListRequest: request);
    // state = result;
    //
    // if (result is Success) {
    //   final response = result.searchListResponse;
    //   searchList = response.resultList;
    _checkRecentListValid();
    // }
  }

  // TODO: 최근 검색 리스트 조회
  Future<void> getRecentList() async {}
}
