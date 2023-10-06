import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kdmp_cm_app/data/model/common/map_data_model.dart';
import 'package:kdmp_cm_app/data/model/common/stopover_model.dart';
import 'package:kdmp_cm_app/presentation/values/strings.dart';
import 'package:kdmp_cm_app/presentation/view/screen/address/stopover_search_screen.dart';
import 'package:kdmp_cm_app/presentation/view/widget/common/behavior/custom_scroll_behavior.dart';
import 'package:kdmp_cm_app/presentation/view/widget/common/button/custom_elevated_button.dart';
import 'package:kdmp_cm_app/presentation/view/widget/common/button/custom_radius_button.dart';
import 'package:kdmp_cm_app/presentation/view/widget/common/section/base_appbar.dart';
import 'package:kdmp_cm_app/presentation/viewmodel/address/stopover_viewmodel.dart';
import 'package:provider/provider.dart';

/// 경유지 설정 화면
class StopOverScreen extends StatefulWidget {
  const StopOverScreen({
    Key? key,
    required this.stopOverList,
  }) : super(key: key);

  static const String routeName = "stopover";

  final List<StopOver> stopOverList;

  @override
  State<StopOverScreen> createState() => _StopOverScreenState();
}

class _StopOverScreenState extends State<StopOverScreen> {
  late final StopOverViewModel _stopOverViewModel;

  @override
  void initState() {
    super.initState();
    initViewModel();
    initData();
  }

  /// Create
  void initViewModel() {
    _stopOverViewModel = StopOverViewModel();
  }

  void initData() {
    _stopOverViewModel.stopOverList = widget.stopOverList;
  }

  @override
  Widget build(BuildContext context) {
    /// Provider
    return MultiProvider(
      providers: [
        Provider<StopOverViewModel>(
          create: (context) => _stopOverViewModel,
        ),
      ],
      child: Scaffold(
        /// 상단 앱바
        appBar: BaseAppBar(
          appBar: AppBar(),
          title: StringStopOverSetup.title,
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
                      const SizedBox(height: 16),
                      ValueListenableBuilder<List<StopOver>>(
                        valueListenable: _stopOverViewModel.stopOverListNotifier,
                        builder: (context, value, _) {
                          return value.isNotEmpty
                              ? getListView(value)
                              : Expanded(
                                  child: Container(
                                    alignment: Alignment.center,
                                    height: 120,
                                    child: Text(
                                      "경유지를 추가해주세요.",
                                      style: Theme.of(context).textTheme.titleLarge,
                                    ),
                                  ),
                                );
                        },
                      ),
                      const SizedBox(height: 20),

                      /// 경유지 추가 버튼
                      CustomRadiusButton(
                        minimumSize: const Size(double.minPositive, double.minPositive),
                        text: StringStopOverSetup.addButton,
                        onPressed: () async {
                          /// 경유지 설정 검색 화면으로 이동
                          final result = await context.pushNamed(StopOverSearchScreen.routeName);
                          if (result != null && result is MapData) {
                            _stopOverViewModel.addStopOverList(
                              StopOver(
                                address: result.address,
                                placeName: result.place,
                                stopDistance: 0,
                                lat: result.latLng.latitude,
                                long: result.latLng.longitude,
                              ),
                            );
                          }
                        },
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),

              /// 하단 버튼
              Padding(
                padding: const EdgeInsets.all(20),
                child: CustomElevatedButton(
                  text: StringStopOverSetup.bottomButton,
                  onPressed: () {
                    /// 홈 화면에 경유지 리스트 전달
                    context.pop(_stopOverViewModel.stopOverList);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 경유지 리스트
  Widget getListView(List<StopOver> value) {
    return Expanded(
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
        itemCount: value.length,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return Row(
            children: [
              SizedBox(
                width: 120,
                child: Text(
                  "${index + 1}번 경유지",
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).disabledColor,
                      ),
                ),
              ),
              const Icon(Icons.circle, size: 7),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  value[index].placeName.isNotEmpty ? value[index].placeName : value[index].address,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              const SizedBox(width: 16),
              GestureDetector(
                child: Icon(Icons.close, size: 16, color: Theme.of(context).disabledColor),
                onTap: () {
                  /// 경유지 삭제
                  _stopOverViewModel.removeStopOverList(index);
                },
              ),
            ],
          );
        },
        separatorBuilder: (context, index) {
          return const Row(
            children: [
              SizedBox(width: 120),
              SizedBox(height: 40, child: VerticalDivider(thickness: 1, width: 7)),
            ],
          );
        },
      ),
    );
  }
}
