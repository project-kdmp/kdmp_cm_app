import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:kdmp_cm_app/data/model/common/state.dart';
import 'package:kdmp_cm_app/data/model/mypage/place_list_response.dart';
import 'package:kdmp_cm_app/domain/usecase/mypage/get_place_list_usecase.dart';
import 'package:kdmp_cm_app/domain/usecase/mypage/set_place_delete_usecase.dart';
import 'package:kdmp_cm_app/domain/usecase/secure_storage/mbr/get_mbrsq_usecase.dart';
import 'package:kdmp_cm_app/presentation/values/images.dart';
import 'package:kdmp_cm_app/presentation/values/strings.dart';
import 'package:kdmp_cm_app/presentation/view/dialog/custom_alert_dialog.dart';
import 'package:kdmp_cm_app/presentation/view/dialog/custom_confirm_dialog.dart';
import 'package:kdmp_cm_app/presentation/view/screen/mypage/modify_place_screen.dart';
import 'package:kdmp_cm_app/presentation/view/widget/common/behavior/custom_scroll_behavior.dart';
import 'package:kdmp_cm_app/presentation/view/widget/common/button/custom_radius_button.dart';
import 'package:kdmp_cm_app/presentation/view/widget/common/section/base_appbar.dart';
import 'package:kdmp_cm_app/presentation/viewmodel/mypage/place_viewmodel.dart';
import 'package:provider/provider.dart';

/// 자주 가는 장소 화면
class PlaceScreen extends StatefulWidget {
  const PlaceScreen({Key? key}) : super(key: key);

  static const String routeName = "place";

  @override
  State<PlaceScreen> createState() => _PlaceScreenState();
}

class _PlaceScreenState extends State<PlaceScreen> {
  late final PlaceViewModel _placeViewModel;

  @override
  void initState() {
    super.initState();
    initViewModel();
    initData();
  }

  /// Create
  void initViewModel() {
    _placeViewModel = PlaceViewModel(
      getMbrSqUseCase: GetIt.instance<GetMbrSqUseCase>(),
      getPlaceListUseCase: GetIt.instance<GetPlaceListUseCase>(),
      setPlaceDeleteUseCase: GetIt.instance<SetPlaceDeleteUseCase>(),
    );
  }

  void initData() {
    /// 자주 가는 장소 리스트 가져오기
    _placeViewModel.getPlaceList();
  }

  @override
  Widget build(BuildContext context) {
    /// Provider
    return MultiProvider(
      providers: [
        Provider<PlaceViewModel>(
          create: (context) => _placeViewModel,
        ),
      ],
      child: Scaffold(
        /// 상단 앱바
        appBar: BaseAppBar(
          appBar: AppBar(),
          title: StringPlace.title,
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
                      ValueListenableBuilder<List<Place>>(
                        valueListenable: _placeViewModel.placeListNotifier,
                        builder: (cntext, value, _) {
                          /// 자주 가는 장소 리스트 없음
                          return value.isEmpty
                              ? SizedBox(
                                  height: 500,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image.asset(ImageCommon.imgWarning, width: 72, height: 72),
                                      const SizedBox(height: 20),
                                      Text(
                                        StringPlace.noList,
                                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                              color: Theme.of(context).disabledColor,
                                            ),
                                      )
                                    ],
                                  ),
                                )
                              : getListView(value);
                        },
                      ),
                    ],
                  ),
                ),
              ),

              /// 하단 버튼
              Padding(
                padding: const EdgeInsets.all(20),
                child: CustomRadiusButton(
                  text: StringPlace.bottomButton,
                  onPressed: () async {
                    /// 자주 가는 장소 등록 화면으로 이동
                    final result = await context.pushNamed(ModifyPlaceScreen.routeName);
                    if (result == true) {
                      initData();
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

  /// 자주 가는 장소 리스트
  Widget getListView(List<Place> value) {
    return Expanded(
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
        itemCount: value.length,
        shrinkWrap: true,
        primary: false,
        itemBuilder: (context, index) {
          return Column(
            children: [
              Row(
                children: [
                  /// 장소 별명
                  Expanded(
                    child: Text(
                      "${value[index].fplaceNicknm}",
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Theme.of(context).colorScheme.secondary),
                    ),
                  ),
                  const SizedBox(width: 8),

                  /// 자주 가는 장소 삭제 버튼
                  GestureDetector(
                    child: Text(StringPlace.delete, style: Theme.of(context).textTheme.titleLarge),
                    onTap: () async {
                      /// 자주 가는 장소 삭제 팝업 띄움
                      await _showConfirmDialog(
                        content: StringPlace.deleteAlert,
                        onConfirm: () async {
                          Navigator.pop(context);

                          /// 자주 가는 장소 삭제
                          final result = await _placeViewModel.deletePlace(value[index].fplaceSq);
                          if (result is Success) {
                            await _showAlertDialog(content: StringPlace.deleteSuccess, isCanceled: false);

                            /// 자주 가는 장소 리스트 갱신
                            initData();
                          }
                        },
                      );
                    },
                  ),
                  const SizedBox(width: 8),

                  /// 자주 가는 장소 수정 버튼
                  GestureDetector(
                    child: Text(StringPlace.modify, style: Theme.of(context).textTheme.titleMedium),
                    onTap: () async {
                      /// 자주 가는 장소 등록 화면으로 이동
                      final result = await context.pushNamed(
                        ModifyPlaceScreen.routeName,
                        extra: value[index],
                      );
                      if (result == true) {
                        initData();
                      }
                    },
                  ),
                  const SizedBox(width: 8),
                ],
              ),
              const SizedBox(height: 12),

              /// 장소 주소
              SizedBox(width: double.maxFinite, child: Text("${value[index].fplaceAddress}", style: Theme.of(context).textTheme.bodyMedium)),
            ],
          );
        },
        separatorBuilder: (context, index) {
          return const Column(
            children: [
              Divider(thickness: 1, height: 40),
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
