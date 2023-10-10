import 'package:kdmp_cm_app/data/model/common/state.dart';
import 'package:kdmp_cm_app/data/model/notice/notice_detail_request.dart';
import 'package:kdmp_cm_app/data/model/notice/notice_list_request.dart';

abstract class NoticeRepository {
  Future<StateAPI> getNoticeList({required NoticeListRequest noticeListRequest});

  Future<StateAPI> getNoticeDetail({required NoticeDetailRequest noticeDetailRequest});
}
