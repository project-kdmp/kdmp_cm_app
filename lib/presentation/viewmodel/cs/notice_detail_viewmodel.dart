import 'package:flutter/foundation.dart';
import 'package:kdmp_cm_app/data/model/common/state.dart';
import 'package:kdmp_cm_app/data/model/notice/notice_detail_request.dart';
import 'package:kdmp_cm_app/domain/usecase/notice/get_notice_detail_usecase.dart';

class NoticeDetailViewModel {
  NoticeDetailViewModel({
    required this.getNoticeDetailUseCase,
  });

  final GetNoticeDetailUseCase getNoticeDetailUseCase;

  /// 공지사항 제목
  final ValueNotifier<String> _noticeTitle = ValueNotifier<String>("");

  ValueNotifier<String> get noticeTitleNotifier => _noticeTitle;

  String get noticeTitle => _noticeTitle.value;

  set noticeTitle(String value) => _noticeTitle.value = value;

  /// 공지사항 날짜
  final ValueNotifier<String> _noticeDate = ValueNotifier<String>("");

  ValueNotifier<String> get noticeDateNotifier => _noticeDate;

  String get noticeDate => _noticeDate.value;

  set noticeDate(String value) => _noticeDate.value = value;

  /// 공지사항 내용
  final ValueNotifier<String> _noticeContent = ValueNotifier<String>("");

  ValueNotifier<String> get noticeContentNotifier => _noticeContent;

  String get noticeContent => _noticeContent.value;

  set noticeContent(String value) => _noticeContent.value = value;

  /// 공지사항 내용 조회 API
  Future<void> getNoticeDetail({required int notiSq}) async {
    state = Loading();

    final request = NoticeDetailRequest(notiSq: notiSq);
    final result = await getNoticeDetailUseCase.execute(noticeDetailRequest: request);
    state = result;

    if (result is Success) {
      noticeTitle = result.noticeDetailResponse.notiTitle ?? "";
      noticeDate = result.noticeDetailResponse.createDt ?? "";
      noticeContent = result.noticeDetailResponse.notiContentHtml ?? "";
    }
  }

  /// 상태
  StateAPI state = Loading();
}
