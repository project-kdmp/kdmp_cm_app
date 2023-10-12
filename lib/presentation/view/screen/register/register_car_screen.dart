import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:kdmp_cm_app/data/model/common/state.dart';
import 'package:kdmp_cm_app/domain/usecase/mypage/set_car_add_usecase.dart';
import 'package:kdmp_cm_app/domain/usecase/secure_storage/mbr/get_mbrsq_usecase.dart';
import 'package:kdmp_cm_app/presentation/values/images.dart';
import 'package:kdmp_cm_app/presentation/values/strings.dart';
import 'package:kdmp_cm_app/presentation/view/bottomsheet/car_add_bottom_sheet.dart';
import 'package:kdmp_cm_app/presentation/view/dialog/custom_alert_dialog.dart';
import 'package:kdmp_cm_app/presentation/view/screen/term/driver_term_screen.dart';
import 'package:kdmp_cm_app/presentation/view/widget/common/behavior/custom_scroll_behavior.dart';
import 'package:kdmp_cm_app/presentation/view/widget/common/button/custom_radius_button.dart';
import 'package:kdmp_cm_app/presentation/view/widget/common/section/base_appbar.dart';
import 'package:kdmp_cm_app/presentation/viewmodel/register/register_car_viewmodel.dart';
import 'package:provider/provider.dart';

/// 초기 차량정보 등록 화면
class RegisterCarScreen extends StatefulWidget {
  const RegisterCarScreen({Key? key}) : super(key: key);

  static const String routeName = "register_car";
  static const String routeURL = "/register_car";

  @override
  State<RegisterCarScreen> createState() => _RegisterCarScreenState();
}

class _RegisterCarScreenState extends State<RegisterCarScreen> {
  late final RegisterCarViewModel _registerCarViewModel;

  @override
  void initState() {
    super.initState();
    initViewModel();
  }

  /// Create
  void initViewModel() {
    _registerCarViewModel = RegisterCarViewModel(
      getMbrSqUseCase: GetIt.instance<GetMbrSqUseCase>(),
      setCarAddUseCase: GetIt.instance<SetCarAddUseCase>(),
    );
  }

  @override
  Widget build(BuildContext context) {
    /// Provider
    return MultiProvider(
      providers: [
        Provider<RegisterCarViewModel>(
          create: (context) => _registerCarViewModel,
        ),
      ],
      child: Scaffold(
        /// 상단 앱바
        appBar: BaseAppBar(
          appBar: AppBar(),
          title: StringRegister.registerCarTitle,
          backButtonVisible: false,
        ),

        /// 화면
        body: WillPopScope(
          onWillPop: _onBackPressed,
          child: SafeArea(
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
                              StringRegister.registerCarContent1,
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Container(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              StringRegister.registerCarContent2,
                              style: Theme.of(context).textTheme.displaySmall,
                              textAlign: TextAlign.left,
                            ),
                          ),
                          const SizedBox(height: 30),
                        ],
                      ),
                    ),

                    /// 상태 이미지
                    Padding(
                      padding: const EdgeInsets.only(top: 48, bottom: 40),
                      child: Image.asset(ImageCommon.appLogo, width: 208, height: 208),
                    ),

                    /// 차량정보 입력 버튼
                    CustomRadiusButton(
                      text: StringRegister.registerBottomButton,
                      margin: const EdgeInsets.all(20),
                      onPressed: () async {
                        /// 차량번호 입력 팝업 띄움
                        final result = await showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          builder: (context) {
                            return Wrap(
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                                  child: const CarAddBottomSheet(),
                                ),
                              ],
                            );
                          },
                        );
                        if (result != null) {
                          final String carNumber = result;

                          /// 차량정보 등록
                          final addCarInfoResult = await _registerCarViewModel.addCarInfo(carNumber);
                          if (addCarInfoResult is Success) {
                            await _showAlertDialog(content: StringCarAdd.carAddSuccess, isCanceled: false);

                            /// 화면 닫기
                            context.pop();
                          } else if (addCarInfoResult is Bad) {
                            Fluttertoast.showToast(msg: StringCommon.httpBad);
                          } else if (addCarInfoResult is Fail) {
                            Fluttertoast.showToast(msg: "${result.errorMessage}");
                          }
                        }
                      },
                    ),
                    const SizedBox(height: 12),

                    /// 운행불가 차종안내
                    GestureDetector(
                      child: Text(
                        StringRegister.driverTerm,
                        style: TextStyle(
                          color: Theme.of(context).iconTheme.color,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                      onTap: () {
                        /// 운행불가 차종안내 화면으로 이동
                        context.pushNamed(DriverTermScreen.routeName);
                      },
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// 앱 뒤로가기
  Future<bool> _onBackPressed() async {
    /// 앱종료
    SystemNavigator.pop();
    return true;
  }

  _showAlertDialog({String? title, String? content, bool isWarning = false, bool isCanceled = true}) {
    return showDialog(
      context: context,
      barrierDismissible: isCanceled, // dialog 영역 외 터치 여부
      builder: (BuildContext context) {
        return CustomAlertDialog(
          title: title,
          content: content,
          isCanceled: isCanceled,
          isWarning: isWarning,
          onConfirm: () {
            Navigator.pop(context);
          },
        );
      },
    );
  }
}
