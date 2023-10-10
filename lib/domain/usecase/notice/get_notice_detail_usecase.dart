import 'package:kdmp_cm_app/data/model/common/state.dart';
import 'package:kdmp_cm_app/data/model/notice/notice_detail_request.dart';
import 'package:kdmp_cm_app/domain/repository/notice/notice_repository.dart';

class GetNoticeDetailUseCase {
  final NoticeRepository _noticeRepository;

  GetNoticeDetailUseCase({required NoticeRepository noticeRepository}) : _noticeRepository = noticeRepository;

  Future<StateAPI> execute({required NoticeDetailRequest noticeDetailRequest}) async {
    return await _noticeRepository.getNoticeDetail(noticeDetailRequest: noticeDetailRequest);
  }
}
