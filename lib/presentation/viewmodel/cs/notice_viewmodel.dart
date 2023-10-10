import 'package:flutter/foundation.dart';
import 'package:kdmp_cm_app/data/model/common/state.dart';
import 'package:kdmp_cm_app/data/model/notice/notice_list_request.dart';
import 'package:kdmp_cm_app/data/model/notice/notice_list_response.dart';
import 'package:kdmp_cm_app/domain/usecase/notice/get_notice_list_usecase.dart';

class NoticeViewModel {
  NoticeViewModel({
    required this.getNoticeListUseCase,
  });

  final GetNoticeListUseCase getNoticeListUseCase;

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

  /// 공지사항 리스트
  final ValueNotifier<List<Notice>> _noticeList = ValueNotifier<List<Notice>>(List.empty());

  ValueNotifier<List<Notice>> get noticeListNotifier => _noticeList;

  List<Notice> get noticeList => _noticeList.value;

  set noticeList(List<Notice> value) => _noticeList.value = value;

  /// 상태
  StateAPI state = Loading();

  /// 공지사항 리스트 조회 API
  void getNoticeList() async {
    if (!isNextPage) {
      return;
    }

    state = Loading();

    final request = NoticeListRequest(page: page + 1, pageSize: 10);
    final result = await getNoticeListUseCase.execute(noticeListRequest: request);
    state = result;

    if (result is Success) {
      final response = result.noticeListResponse;

      List<Notice> copyList = List.from(noticeList);
      copyList.addAll(response.resultList);
      noticeList = copyList;

      page = response.pagination.page;
      isNextPage = response.pagination.existNextPage;
    }
  }
}
