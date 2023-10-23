import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:kdmp_cm_app/data/model/common/state.dart';
import 'package:kdmp_cm_app/data/model/mypage/car_list_response.dart';
import 'package:kdmp_cm_app/domain/usecase/mypage/get_car_list_usecase.dart';
import 'package:kdmp_cm_app/domain/usecase/mypage/set_car_add_usecase.dart';
import 'package:kdmp_cm_app/domain/usecase/mypage/set_car_delete_usecase.dart';
import 'package:kdmp_cm_app/domain/usecase/mypage/set_car_modify_usecase.dart';
import 'package:kdmp_cm_app/domain/usecase/secure_storage/mbr/get_mbrsq_usecase.dart';
import 'package:kdmp_cm_app/presentation/values/images.dart';
import 'package:kdmp_cm_app/presentation/values/strings.dart';
import 'package:kdmp_cm_app/presentation/view/bottomsheet/car_add_bottom_sheet.dart';
import 'package:kdmp_cm_app/presentation/view/dialog/custom_alert_dialog.dart';
import 'package:kdmp_cm_app/presentation/view/dialog/custom_confirm_dialog.dart';
import 'package:kdmp_cm_app/presentation/view/screen/term/driver_term_screen.dart';
import 'package:kdmp_cm_app/presentation/view/widget/common/behavior/custom_scroll_behavior.dart';
import 'package:kdmp_cm_app/presentation/view/widget/common/button/custom_radius_button.dart';
import 'package:kdmp_cm_app/presentation/view/widget/common/button/custom_round_button.dart';
import 'package:kdmp_cm_app/presentation/view/widget/common/section/base_appbar.dart';
import 'package:kdmp_cm_app/presentation/viewmodel/mypage/car_info_viewmodel.dart';
import 'package:provider/provider.dart';

/// 차량정보 화면
class CarInfoScreen extends StatefulWidget {
  const CarInfoScreen({Key? key}) : super(key: key);

  static const String routeName = "car";

  @override
  State<CarInfoScreen> createState() => _CarInfoScreenState();
}

class _CarInfoScreenState extends State<CarInfoScreen> {
  late final CarInfoViewModel _carInfoViewModel;

  @override
  void initState() {
    super.initState();
    initViewModel();
    initData();
  }

  /// Create
  void initViewModel() {
    _carInfoViewModel = CarInfoViewModel(
      getMbrSqUseCase: GetIt.instance<GetMbrSqUseCase>(),
      getCarListUseCase: GetIt.instance<GetCarListUseCase>(),
      setCarAddUseCase: GetIt.instance<SetCarAddUseCase>(),
      setCarModifyUseCase: GetIt.instance<SetCarModifyUseCase>(),
      setCarDeleteUseCase: GetIt.instance<SetCarDeleteUseCase>(),
    );
  }

  void initData() {
    /// 차량정보 리스트 가져오기
    _carInfoViewModel.getCarList();
  }

  @override
  Widget build(BuildContext context) {
    /// Provider
    return MultiProvider(
      providers: [
        Provider<CarInfoViewModel>(
          create: (context) => _carInfoViewModel,
        ),
      ],
      child: Scaffold(
        /// 상단 앱바
        appBar: BaseAppBar(
          appBar: AppBar(),
          title: StringCar.title,
        ),

        /// 화면
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: ScrollConfiguration(
                  behavior: CustomScrollBehavior(),
                  child: Column(
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            ValueListenableBuilder<List<Car>>(
                              valueListenable: _carInfoViewModel.carListNotifier,
                              builder: (context, value, _) {
                                return getListView(value);
                              },
                            ),
                            const SizedBox(height: 20),

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
                            const SizedBox(height: 16),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              /// 하단 버튼
              Padding(
                padding: const EdgeInsets.all(20),
                child: CustomRadiusButton(
                  text: StringCar.bottomButton,
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
                              child: CarAddBottomSheet(),
                            ),
                          ],
                        );
                      },
                    );
                    if (result != null) {
                      final String carNumber = result;

                      /// 차량정보 등록
                      final addResult = await _carInfoViewModel.addCarInfo(carNumber);
                      if (addResult is Success) {
                        await _showAlertDialog(content: StringCarAdd.carAddSuccess, isCanceled: false);
                        initData();
                      } else if (addResult is Bad) {
                        Fluttertoast.showToast(msg: addResult.badResponse.detailMessage);
                      } else if (addResult is Fail) {
                        Fluttertoast.showToast(msg: "${addResult.errorMessage}");
                      }
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 차량정보 리스트
  Widget getListView(List<Car> value) {
    return Expanded(
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
        itemCount: value.length,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return Container(
            padding: const EdgeInsets.only(top: 20, bottom: 20, left: 24, right: 16),
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).disabledColor.withOpacity(0.3),
                  spreadRadius: 0,
                  blurRadius: 17,
                  offset: const Offset(4, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Image.asset(ImageMenu.iconCar, width: 45, height: 40),
                    const SizedBox(width: 16),

                    /// 차량번호
                    Expanded(child: Text("${value[index].carNumId}", style: Theme.of(context).textTheme.titleLarge)),
                    const SizedBox(width: 8),

                    /// 차량정보 삭제 버튼
                    value.length > 1
                        ? CustomRoundButton(
                            text: StringCar.delete,
                            onPressed: () async {
                              /// 차량정보 삭제 팝업 띄움
                              await _showConfirmDialog(
                                content: StringCar.deleteAlert,
                                onConfirm: () async {
                                  Navigator.pop(context);

                                  /// 차량정보 삭제
                                  final result = await _carInfoViewModel.deleteCarInfo(value[index].carNumId!);
                                  if (result is Success) {
                                    await _showAlertDialog(content: StringCar.deleteSuccess, isCanceled: false);

                                    /// 차량정보 리스트 갱신
                                    initData();
                                  } else if (result is Bad) {
                                    Fluttertoast.showToast(msg: result.badResponse.detailMessage);
                                  } else if (result is Fail) {
                                    Fluttertoast.showToast(msg: "${result.errorMessage}");
                                  }
                                },
                              );
                            },
                          )
                        : const SizedBox(),
                    const SizedBox(width: 8),

                    /// 차량정보 수정 버튼
                    CustomRoundButton(
                      text: StringCar.modify,
                      onPressed: () async {
                        /// 차량번호 입력 팝업 띄움 (수정)
                        final result = await showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          builder: (context) {
                            return Wrap(
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                                  child: CarAddBottomSheet(initCarNumber: value[index].carNumId!),
                                ),
                              ],
                            );
                          },
                        );
                        if (result != null) {
                          final String carNumber = result;

                          /// 차량정보 수정
                          final modifyResult = await _carInfoViewModel.modifyCarInfo(
                            beforeCarNumId: value[index].carNumId!,
                            afterCarNumId: carNumber,
                          );
                          if (modifyResult is Success) {
                            await _showAlertDialog(content: StringCar.modifySuccess, isCanceled: false);

                            /// 차량정보 리스트 갱신
                            initData();
                          } else if (modifyResult is Bad) {
                            Fluttertoast.showToast(msg: modifyResult.badResponse.detailMessage);
                          } else if (modifyResult is Fail) {
                            Fluttertoast.showToast(msg: "${modifyResult.errorMessage}");
                          }
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),
          );
        },
        separatorBuilder: (context, index) {
          return const Column(
            children: [
              SizedBox(height: 12),
            ],
          );
        },
      ),
    );
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

  _showConfirmDialog({String? title, String? content, bool isWarning = false, required Function() onConfirm}) {
    return showDialog(
      context: context,
      barrierDismissible: true, // dialog 영역 외 터치 여부
      builder: (BuildContext context) {
        return CustomConfirmDialog(
          title: title,
          content: content,
          isWarning: isWarning,
          onConfirm: onConfirm,
        );
      },
    );
  }
}
