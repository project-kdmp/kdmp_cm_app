import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:kdmp_cm_app/data/model/common/map_data_model.dart';
import 'package:kdmp_cm_app/data/model/common/state.dart';
import 'package:kdmp_cm_app/domain/usecase/mypage/set_place_add_usecase.dart';
import 'package:kdmp_cm_app/domain/usecase/mypage/set_place_modify_usecase.dart';
import 'package:kdmp_cm_app/domain/usecase/secure_storage/mbr/get_mbrsq_usecase.dart';
import 'package:kdmp_cm_app/presentation/values/strings.dart';
import 'package:kdmp_cm_app/presentation/view/dialog/custom_alert_dialog.dart';
import 'package:kdmp_cm_app/presentation/view/screen/address/place_search_screen.dart';
import 'package:kdmp_cm_app/presentation/view/widget/common/behavior/custom_scroll_behavior.dart';
import 'package:kdmp_cm_app/presentation/view/widget/common/button/custom_elevated_button.dart';
import 'package:kdmp_cm_app/presentation/view/widget/common/button/custom_text_button.dart';
import 'package:kdmp_cm_app/presentation/view/widget/common/section/base_appbar.dart';
import 'package:kdmp_cm_app/presentation/view/widget/common/text/custom_text_field.dart';
import 'package:kdmp_cm_app/presentation/viewmodel/mypage/modify_place_viewmodel.dart';
import 'package:provider/provider.dart';

/// 자주 가는 장소 수정/등록 화면
class ModifyPlaceScreen extends StatefulWidget {
  const ModifyPlaceScreen({
    Key? key,
    this.fplaceSq = 0,
    this.placeMapData,
  }) : super(key: key);

  static const String routeName = "modify_place";
  static const String routeURL = "/modify_place";

  final int fplaceSq;
  final MapData? placeMapData;

  @override
  State<ModifyPlaceScreen> createState() => _ModifyPlaceScreenState();
}

class _ModifyPlaceScreenState extends State<ModifyPlaceScreen> {
  late final ModifyPlaceViewModel _modifyPlaceViewModel;

  @override
  void initState() {
    super.initState();
    initViewModel();
    initData();
  }

  /// Create
  void initViewModel() {
    _modifyPlaceViewModel = ModifyPlaceViewModel(
      getMbrSqUseCase: GetIt.instance<GetMbrSqUseCase>(),
      setPlaceAddUseCase: GetIt.instance<SetPlaceAddUseCase>(),
      setPlaceModifyUseCase: GetIt.instance<SetPlaceModifyUseCase>(),
    );
  }

  void initData() async {
    _modifyPlaceViewModel.placeNm = widget.placeMapData != null ? widget.placeMapData!.place : "";
    _modifyPlaceViewModel.placeAddress = widget.placeMapData != null ? widget.placeMapData!.address : "";
  }

  @override
  Widget build(BuildContext context) {
    /// Provider
    return MultiProvider(
      providers: [
        Provider<ModifyPlaceViewModel>(
          create: (context) => _modifyPlaceViewModel,
        ),
      ],
      child: Scaffold(
        /// 상단 앱바
        appBar: BaseAppBar(
          appBar: AppBar(),
          title: widget.fplaceSq == 0 ? StringPlace.addTitle : StringPlace.modifyTitle,
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

                              /// 장소 별명 입력
                              Container(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  StringPlace.placeNm,
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              ),
                              const SizedBox(height: 6),
                              CustomTextField(
                                text: _modifyPlaceViewModel.placeNm,
                                hint: StringPlace.placeNmHint,
                                onChanged: (value) {
                                  _modifyPlaceViewModel.placeNm = value;
                                },
                              ),
                              const SizedBox(height: 24),

                              /// 장소 지정
                              Container(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  StringPlace.placeAddress,
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              ),
                              const SizedBox(height: 6),
                              ValueListenableBuilder<String>(
                                valueListenable: _modifyPlaceViewModel.placeAddressNotifier,
                                builder: (context, value, child) {
                                  return CustomTextButton(
                                    text: value,
                                    hint: StringPlace.placeAddressHint,
                                    onPressed: () async {
                                      /// 장소 설정 검색 화면으로 이동
                                      final result = await context.pushNamed(PlaceSearchScreen.routeName);
                                      if (result != null && result is MapData) {
                                        _modifyPlaceViewModel.placeMapData = result;
                                      }
                                    },
                                  );
                                },
                              ),
                              const SizedBox(height: 24),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              /// 하단 버튼
              Padding(
                padding: const EdgeInsets.all(20),
                child: ValueListenableBuilder<bool>(
                  valueListenable: _modifyPlaceViewModel.isValidNotifier,
                  builder: (context, value, _) {
                    return CustomElevatedButton(
                      text: widget.placeMapData == null ? StringCommon.confirm : StringPlace.modify,
                      isEnabled: value,
                      onPressed: () async {
                        if (widget.placeMapData == null) {
                          /// 자주 가는 장소 등록
                          final result = await _modifyPlaceViewModel.addPlace();
                          if (result is Success) {
                            await _showAlertDialog(content: StringPlace.addSuccess, isCanceled: false);

                            /// 화면 닫기, 이전 화면 갱신
                            context.pop(true);
                          } else if (result is Bad) {
                            Fluttertoast.showToast(msg: StringCommon.httpBad);
                          } else if (result is Fail) {
                            Fluttertoast.showToast(msg: "${result.errorMessage}");
                          }
                        } else {
                          /// 자주 가는 장소 수정
                          final result = await _modifyPlaceViewModel.modifyPlace(fplaceSq: widget.fplaceSq);
                          if (result is Success) {
                            await _showAlertDialog(content: StringPlace.modifySuccess, isCanceled: false);

                            /// 화면 닫기, 이전 화면 갱신
                            context.pop(true);
                          } else if (result is Bad) {
                            Fluttertoast.showToast(msg: StringCommon.httpBad);
                          } else if (result is Fail) {
                            Fluttertoast.showToast(msg: "${result.errorMessage}");
                          }
                        }
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
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
}
