import 'package:flutter_test/flutter_test.dart';

/// 공지 본문의 이미지 src 를 어떻게 알아보는지 고정한다.
///
/// 관리자 에디터는 `/image?q=<URL 인코딩된 경로>` 로 넣는다 — 관리자 프론트가 토큰을
/// 붙여 중계하는 라우트다. 앱에는 그 라우트가 없어서, 처음에 `/datafile/` 로만 찾다가
/// 한 건도 매치되지 않아 이미지가 통째로 비어 보였다(2026-10-13).
void main() {
  final imageSrc =
      RegExp(r'''(src\s*=\s*["'])(/image\?q=[^"']+|/datafile/[^"']+)(["'])''');

  String? toDataFilePath(String src) {
    if (src.startsWith('/datafile/')) {
      return src;
    }

    final decoded = Uri.tryParse(src)?.queryParameters['q'];

    return (decoded != null && decoded.startsWith('/datafile/')) ? decoded : null;
  }

  test('에디터가 넣는 중계 경로에서 파일 경로를 꺼낸다', () {
    const html = '<p>안내</p>'
        '<img src="/image?q=%2Fdatafile%2Fadmin%2FNTIE%2F123%2Fpng" width="500">';

    final matches = imageSrc.allMatches(html).toList();

    expect(matches, hasLength(1));
    expect(toDataFilePath(matches.first.group(2)!), '/datafile/admin/NTIE/123/png');
  });

  test('경로를 그대로 담은 옛 공지도 받는다', () {
    const html = '<img src="/datafile/admin/NTIE/9/jpg">';

    final matches = imageSrc.allMatches(html).toList();

    expect(matches, hasLength(1));
    expect(toDataFilePath(matches.first.group(2)!), '/datafile/admin/NTIE/9/jpg');
  });

  test('작은따옴표와 공백도 받는다', () {
    const html = "<img src = '/image?q=%2Fdatafile%2Fadmin%2FNTIE%2F7%2Fpng' />";

    final matches = imageSrc.allMatches(html).toList();

    expect(matches, hasLength(1));
    expect(toDataFilePath(matches.first.group(2)!), '/datafile/admin/NTIE/7/png');
  });

  test('바깥 이미지는 건드리지 않는다', () {
    const html = '<img src="https://example.com/a.png">';

    expect(imageSrc.allMatches(html), isEmpty);
  });

  test('q 가 파일 경로가 아니면 받지 않는다', () {
    expect(toDataFilePath('/image?q=%2Fetc%2Fpasswd'), isNull);
  });
}
