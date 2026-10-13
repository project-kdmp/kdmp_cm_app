import 'package:kdmp_cm_app/data/model/common/state.dart';
import 'package:kdmp_cm_app/data/model/notice/notice_detail_request.dart';
import 'package:kdmp_cm_app/data/model/notice/notice_list_request.dart';

abstract class NoticeRepository {
  Future<StateAPI> getNoticeList({required NoticeListRequest noticeListRequest});

  Future<StateAPI> getNoticeDetail({required NoticeDetailRequest noticeDetailRequest});

  /// 공지 본문에 박힌 이미지를 받아 data URI 로 돌려준다. 실패하면 null.
  Future<String?> getNoticeImageDataUri({required String path});
}
