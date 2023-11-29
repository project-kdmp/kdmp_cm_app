import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:kdmp_cm_app/domain/usecase/register/get_service_stop_usecase.dart';
import 'package:kdmp_cm_app/domain/usecase/secure_storage/mbr/get_mbrsq_usecase.dart';
import 'package:kdmp_cm_app/presentation/values/images.dart';
import 'package:kdmp_cm_app/presentation/values/strings.dart';
import 'package:kdmp_cm_app/presentation/view/widget/common/behavior/custom_scroll_behavior.dart';
import 'package:kdmp_cm_app/presentation/view/widget/common/button/custom_elevated_button.dart';
import 'package:kdmp_cm_app/presentation/view/widget/common/section/base_appbar.dart';
import 'package:kdmp_cm_app/presentation/viewmodel/register/no_permission_viewmodel.dart';

/// 정지 회원 안내 화면
class NoPermissionScreen extends StatefulWidget {
  const NoPermissionScreen({Key? key}) : super(key: key);

  static const String routeName = "no_permission";
  static const String routeURL = "/no_permission";

  @override
  State<NoPermissionScreen> createState() => _NoPermissionScreenState();
}

class _NoPermissionScreenState extends State<NoPermissionScreen> {
  late final NoPermissionViewModel _noPermissionViewModel;

  @override
  void initState() {
    super.initState();
    initViewModel();
    initData();
  }

  /// Create
  void initViewModel() {
    _noPermissionViewModel = NoPermissionViewModel(
      getMbrSqUseCase: GetIt.instance<GetMbrSqUseCase>(),
      getServiceStopUseCase: GetIt.instance<GetServiceStopUseCase>(),
    );
  }

  void initData() {
    /// 정지 사유 조회
    _noPermissionViewModel.getServiceStop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /// 상단 앱바
      appBar: BaseAppBar(
        appBar: AppBar(),
        title: StringRegister.noPermission,
        backButtonVisible: false,
      ),

      /// 화면
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ScrollConfiguration(
                behavior: CustomScrollBehavior(),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      /// 내용
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          children: [
                            const SizedBox(height: 32),
                            Container(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                StringRegister.noPermissionContent,
                                style: Theme.of(context).textTheme.displaySmall,
                              ),
                            ),
                            const SizedBox(height: 10),

                            /// 정지 사유
                            ValueListenableBuilder<String>(
                              valueListenable: _noPermissionViewModel.serviceStopNotifier,
                              builder: (context, value, child) {
                                return Container(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    value,
                                    style: Theme.of(context).textTheme.bodyLarge,
                                    textAlign: TextAlign.left,
                                  ),
                                );
                              },
                            ),
                            const SizedBox(height: 30),
                          ],
                        ),
                      ),

                      /// 상태 이미지
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 72),
                        child: Image.asset(ImageRegister.imgNoPermission, width: 200, height: 180),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            /// 하단 버튼
            Padding(
              padding: const EdgeInsets.all(20),
              child: CustomElevatedButton(
                text: StringCommon.confirm,
                onPressed: () {
                  /// 앱종료
                  SystemNavigator.pop();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
