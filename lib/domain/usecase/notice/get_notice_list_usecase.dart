import 'package:kdmp_cm_app/data/model/common/state.dart';
import 'package:kdmp_cm_app/data/model/notice/notice_list_request.dart';
import 'package:kdmp_cm_app/domain/repository/notice/notice_repository.dart';

class GetNoticeListUseCase {
  final NoticeRepository _noticeRepository;

  GetNoticeListUseCase({required NoticeRepository noticeRepository}) : _noticeRepository = noticeRepository;

  Future<StateAPI> execute({required NoticeListRequest noticeListRequest}) async {
    return await _noticeRepository.getNoticeList(noticeListRequest: noticeListRequest);
  }
}
