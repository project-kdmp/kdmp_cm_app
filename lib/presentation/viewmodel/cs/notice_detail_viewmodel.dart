import 'package:flutter/foundation.dart';
import 'package:kdmp_cm_app/data/model/common/state.dart';
import 'package:kdmp_cm_app/data/model/notice/notice_detail_request.dart';
import 'package:kdmp_cm_app/domain/usecase/notice/get_notice_detail_usecase.dart';
import 'package:kdmp_cm_app/domain/usecase/notice/get_notice_image_usecase.dart';

class NoticeDetailViewModel {
  NoticeDetailViewModel({
    required this.getNoticeDetailUseCase,
    required this.getNoticeImageUseCase,
  });

  final GetNoticeDetailUseCase getNoticeDetailUseCase;
  final GetNoticeImageUseCase getNoticeImageUseCase;

  /// 본문에 박힌 이미지. 관리자 에디터가 **관리자 프론트의 중계 경로**로 넣는다
  /// (`/image?q=%2Fdatafile%2Fadmin%2F...`). 그 라우트는 앱에 없으므로 q 를 풀어
  /// 실제 경로를 꺼낸다. 옛 공지가 경로를 그대로 담고 있을 수 있어 둘 다 받는다.
  static final RegExp _imageSrc =
      RegExp(r'''(src\s*=\s*["'])(/image\?q=[^"']+|/datafile/[^"']+)(["'])''');

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
      noticeContent = await _inlineImages(result.noticeDetailResponse.notiContentHtml ?? "");
    }
  }

  /// 본문의 이미지를 미리 받아 data URI 로 바꿔 넣는다.
  ///
  /// 이미지 경로(`/datafile/...`)는 **인증을 요구하는데 웹뷰는 앱의 토큰을 붙이지 않는다.**
  /// 그대로 두면 거절당해 빈 칸이 된다. 토큰이 붙는 Dio 로 받아 본문에 심는다.
  ///
  /// 받지 못한 이미지는 경로를 그대로 둔다 — 본문 전체를 못 보는 것보다 낫다.
  /// 공지 한 건의 이미지가 많지 않다고 보고 전부 먼저 받는다.
  Future<String> _inlineImages(String html) async {
    final matches = _imageSrc.allMatches(html).toList();

    if (matches.isEmpty) {
      return html;
    }

    /// 같은 이미지가 여러 번 쓰일 수 있다. src 별로 한 번만 받는다.
    final sources = matches.map((m) => m.group(2)!).toSet();
    final loaded = <String, String>{};

    for (final src in sources) {
      final path = _toDataFilePath(src);

      if (path == null) {
        continue;
      }

      final dataUri = await getNoticeImageUseCase.execute(path: path);

      if (dataUri != null) {
        loaded[src] = dataUri;
      }
    }

    if (loaded.isEmpty) {
      return html;
    }

    return html.replaceAllMapped(_imageSrc, (m) {
      final replaced = loaded[m.group(2)];

      return replaced == null ? m.group(0)! : '${m.group(1)}$replaced${m.group(3)}';
    });
  }

  /// src 에서 서버의 파일 경로(`/datafile/...`)를 꺼낸다. 알아보지 못하면 null.
  ///
  /// 관리자 에디터는 `/image?q=<URL 인코딩된 경로>` 로 넣는다 — 관리자 프론트가 토큰을
  /// 붙여 중계하는 라우트다. 앱에는 그 라우트가 없으므로 q 를 풀어 직접 받는다.
  String? _toDataFilePath(String src) {
    if (src.startsWith('/datafile/')) {
      return src;
    }

    final decoded = Uri.tryParse(src)?.queryParameters['q'];

    return (decoded != null && decoded.startsWith('/datafile/')) ? decoded : null;
  }

  /// 상태
  StateAPI state = Loading();
}
