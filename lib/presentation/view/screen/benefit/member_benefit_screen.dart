import 'package:flutter/material.dart';
import 'package:kdmp_cm_app/data/constant/constants.dart';
import 'package:kdmp_cm_app/presentation/values/strings.dart';
import 'package:kdmp_cm_app/presentation/view/widget/common/section/base_appbar.dart';
import 'package:webview_flutter/webview_flutter.dart';

/// 회원 혜택 화면.
///
/// 협회(k-pma.or.kr)가 운영하는 혜택 안내 페이지를 그대로 띄운다. 내용은 협회가
/// 웹에서 관리하므로 바뀔 때마다 앱을 올리지 않아도 된다.
///
/// **외부 사이트라 앱이 내용을 보장하지 않는다.** 페이지가 열리지 않을 때
/// 빈 화면만 남으면 고객이 앱 탓으로 여기므로, 오류를 글로 적어 둔다.
///
/// 주소는 환경별로 갈린다(AppConstants.BENEFIT_URL). stage 는 http 라
/// AndroidManifest 의 usesCleartextTraffic=true 가 있어야 열린다.
///
/// 기사앱(kdmp_dm_app)의 '기사혜택' 화면과 같은 페이지를 본다.
class MemberBenefitScreen extends StatefulWidget {
  const MemberBenefitScreen({Key? key}) : super(key: key);

  static const String routeName = "member_benefit";

  @override
  State<MemberBenefitScreen> createState() => _MemberBenefitScreenState();
}

class _MemberBenefitScreenState extends State<MemberBenefitScreen> {
  late final WebViewController _controller;

  /// 페이지를 받아오는 중인지. 다 받을 때까지 흰 화면만 보이면 멈춘 것처럼 보인다.
  bool _loading = true;

  /// 열지 못한 까닭. null 이면 정상이다.
  String? _error;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    initWebViewController();
  }

  void initWebViewController() {
    _controller = WebViewController()
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            if (!mounted) return;
            setState(() {
              _loading = true;
              _error = null;
            });
          },
          onPageFinished: (String url) {
            if (!mounted) return;
            setState(() => _loading = false);
          },
          onWebResourceError: (WebResourceError error) {
            if (!mounted) return;

            /// 페이지 안의 이미지 하나가 실패해도 이 콜백이 불린다. 본문까지
            /// 못 받은 경우만 오류로 다룬다 — 아니면 멀쩡한 화면을 덮어 버린다.
            ///
            /// null 은 '모른다' 는 뜻이라 오류로 보지 않는다. 강제로 꺼내면
            /// 그 자리에서 터진다.
            if (error.isForMainFrame != true) return;

            setState(() {
              _loading = false;
              _error = error.description;
            });
          },
          onNavigationRequest: (NavigationRequest request) {
            return NavigationDecision.navigate;
          },
        ),
      )
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse(AppConstants.BENEFIT_URL));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /// 상단 앱바
      appBar: BaseAppBar(
        appBar: AppBar(),
        title: StringMemberBenefit.title,
      ),

      /// 화면
      body: SafeArea(
        child: _error != null
            ? _errorView()
            : Stack(
                children: [
                  WebViewWidget(controller: _controller),
                  if (_loading) const Center(child: CircularProgressIndicator()),
                ],
              ),
      ),
    );
  }

  Widget _errorView() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              StringMemberBenefit.errorTitle,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              StringMemberBenefit.errorBody,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 20),
            TextButton(
              onPressed: () {
                _controller.loadRequest(Uri.parse(AppConstants.BENEFIT_URL));
              },
              child: const Text(StringMemberBenefit.retry),
            ),
          ],
        ),
      ),
    );
  }
}
