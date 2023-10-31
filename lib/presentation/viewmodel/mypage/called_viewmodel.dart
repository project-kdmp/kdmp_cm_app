import 'package:flutter/foundation.dart';
import 'package:kdmp_cm_app/data/model/common/drv_request.dart';
import 'package:kdmp_cm_app/data/model/common/state.dart';
import 'package:kdmp_cm_app/data/model/mypage/call_list_request.dart';
import 'package:kdmp_cm_app/data/model/mypage/call_list_response.dart';
import 'package:kdmp_cm_app/data/model/mypage/called_list_request.dart';
import 'package:kdmp_cm_app/data/model/mypage/called_list_response.dart';
import 'package:kdmp_cm_app/domain/usecase/mypage/get_call_list_usecase.dart';
import 'package:kdmp_cm_app/domain/usecase/mypage/get_called_list_usecase.dart';
import 'package:kdmp_cm_app/domain/usecase/mypage/set_called_delete_usecase.dart';
import 'package:kdmp_cm_app/domain/usecase/secure_storage/mbr/get_mbrsq_usecase.dart';

class CalledViewModel {
  CalledViewModel({
    required this.getMbrSqUseCase,
    required this.getCallListUseCase,
    required this.getCalledListUseCase,
    required this.setCalledDeleteUseCase,
  });

  final GetMbrSqUseCase getMbrSqUseCase;
  final GetCallListUseCase getCallListUseCase;
  final GetCalledListUseCase getCalledListUseCase;
  final SetCalledDeleteUseCase setCalledDeleteUseCase;

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

  /// 미완료 이용내역 리스트
  final ValueNotifier<List<Call>> _callList = ValueNotifier<List<Call>>(List.empty());

  ValueNotifier<List<Call>> get callListNotifier => _callList;

  List<Call> get callList => _callList.value;

  set callList(List<Call> value) => _callList.value = value;

  /// 이용내역 리스트
  final ValueNotifier<List<Called>> _calledList = ValueNotifier<List<Called>>(List.empty());

  ValueNotifier<List<Called>> get calledListNotifier => _calledList;

  List<Called> get calledList => _calledList.value;

  set calledList(List<Called> value) => _calledList.value = value;

  /// 하단 버튼 활성화 여부
  final ValueNotifier<bool> _isValid = ValueNotifier<bool>(true);

  ValueNotifier<bool> get isValidNotifier => _isValid;

  bool get isValid => _isValid.value;

  _setIsValid({required bool value}) {
    _isValid.value = value;
  }

  /// 상태
  StateAPI state = Loading();

  /// 미완료 이용내역 리스트 조회 API
  Future<void> getCallList() async {
    if (!isNextPage) {
      return;
    }

    state = Loading();

    final mbrSq = await getMbrSqUseCase.execute();

    final request = CallListRequest(mbrCmSq: mbrSq);
    final result = await getCallListUseCase.execute(callListRequest: request);
    state = result;

    if (result is Success) {
      final response = result.callListResponse;
      callList = response.resultList;
    }
  }

  /// 이용내역 리스트 조회 API
  Future<void> getCalledList() async {
    if (!isNextPage) {
      return;
    }

    state = Loading();

    final mbrSq = await getMbrSqUseCase.execute();

    final request = CalledListRequest(
      page: page + 1,
      pageSize: 10,
      mbrCmSq: mbrSq,
    );
    final result = await getCalledListUseCase.execute(calledListRequest: request);
    state = result;

    if (result is Success) {
      final response = result.calledListResponse;

      List<Called> copyList = List.from(calledList);
      copyList.addAll(response.resultList);
      calledList = copyList;

      page = response.pagination.page;
      isNextPage = response.pagination.existNextPage;
    }
  }

  /// 페이지 정보 초기화
  void clearPagination() {
    page = 0;
    isNextPage = true;
    callList = List.empty();
    calledList = List.empty();
  }

  /// 이용내역 삭제 API
  Future<StateAPI> deleteCalled({required int drvReqSq}) async {
    state = Loading();

    final request = DrvRequest(drvReqSq: drvReqSq);
    final result = await setCalledDeleteUseCase.execute(calledDeleteRequest: request);
    state = result;

    return result;
  }
}
