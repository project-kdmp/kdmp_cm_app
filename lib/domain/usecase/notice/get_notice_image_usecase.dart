import 'package:kdmp_cm_app/domain/repository/notice/notice_repository.dart';

class GetNoticeImageUseCase {
  final NoticeRepository _noticeRepository;

  GetNoticeImageUseCase({required NoticeRepository noticeRepository})
      : _noticeRepository = noticeRepository;

  Future<String?> execute({required String path}) async {
    return await _noticeRepository.getNoticeImageDataUri(path: path);
  }
}
