import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:kdmp_cm_app/data/constant/codes.dart';
import 'package:kdmp_cm_app/data/model/common/state.dart';
import 'package:kdmp_cm_app/data/model/work/driver_list_response.dart';
import 'package:kdmp_cm_app/domain/usecase/secure_storage/mbr/get_mbrsq_usecase.dart';
import 'package:kdmp_cm_app/domain/usecase/work/get_driver_list_usecase.dart';
import 'package:kdmp_cm_app/domain/usecase/work/set_driver_favorite_usecase.dart';
import 'package:kdmp_cm_app/presentation/values/strings.dart';
import 'package:kdmp_cm_app/presentation/view/bottomsheet/driver_detail_bottom_sheet.dart';
import 'package:kdmp_cm_app/presentation/view/widget/common/behavior/custom_scroll_behavior.dart';
import 'package:kdmp_cm_app/presentation/view/widget/common/button/custom_radius_button.dart';
import 'package:kdmp_cm_app/presentation/view/widget/common/section/base_appbar.dart';
import 'package:kdmp_cm_app/presentation/view/widget/common/text/custom_search_field.dart';
import 'package:kdmp_cm_app/presentation/viewmodel/work/driver_select_viewmodel.dart';
import 'package:provider/provider.dart';

/// 기사 지정 화면.
/// 고른 기사를 [Driver] 로 돌려주고, 지정을 지우면 false 를 돌려준다.
class DriverSelectScreen extends StatefulWidget {
  const DriverSelectScreen({
    Key? key,
    required this.gpsLat,
    required this.gpsLong,
    this.selectedDriver,
  }) : super(key: key);

  /// 주변 탭의 거리 기준이 되는 출발지 좌표
  final double gpsLat;
  final double gpsLong;

  /// 이미 지정해 둔 기사. 다시 들어왔을 때 선택 상태를 보여준다
  final Driver? selectedDriver;

  static const String routeName = "driver_select";

  @override
  State<DriverSelectScreen> createState() => _DriverSelectScreenState();
}

class _DriverSelectScreenState extends State<DriverSelectScreen> {
  late final DriverSelectViewModel _driverSelectViewModel;

  /// 치는 동안 자동으로 검색한다. 손이 멈춘 뒤에 한 번만 부른다
  static const Duration _debounceDuration = Duration(milliseconds: 400);

  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    initViewModel();
    _driverSelectViewModel.getDriverList();
  }

  /// Create
  void initViewModel() {
    _driverSelectViewModel = DriverSelectViewModel(
      getMbrSqUseCase: GetIt.instance<GetMbrSqUseCase>(),
      getDriverListUseCase: GetIt.instance<GetDriverListUseCase>(),
      setDriverFavoriteUseCase: GetIt.instance<SetDriverFavoriteUseCase>(),
      gpsLat: widget.gpsLat,
      gpsLong: widget.gpsLong,
    );
    _driverSelectViewModel.selectedDriver = widget.selectedDriver;
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  /// 검색어가 바뀔 때마다 불린다
  void _onKeywordChanged(String value) {
    _debounce?.cancel();

    _driverSelectViewModel.keyword = value;

    /// 검색어를 지우면 보고 있던 탭으로 돌아간다
    _debounce = Timer(_debounceDuration, () => _driverSelectViewModel.getDriverList());
  }

  /// 키보드의 검색 키는 기다리지 않고 바로 찾는다
  Future<void> _onSearch(String value) async {
    _debounce?.cancel();

    _driverSelectViewModel.keyword = value;
    await _driverSelectViewModel.getDriverList();
  }

  /// 기사 상세 팝업
  Future<void> _showDetail(Driver driver) async {
    final result = await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Wrap(children: [
          Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom + MediaQuery.of(context).padding.bottom,
            ),
            child: DriverDetailBottomSheet(
              driver: driver,
              onFavoritePressed: () async {
                await _driverSelectViewModel.toggleFavorite(driver);
                if (!context.mounted) return;
                context.pop();
              },
            ),
          )
        ]);
      },
    );

    if (result is Driver && mounted) {
      context.pop(result);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<DriverSelectViewModel>(create: (_) => _driverSelectViewModel),
      ],
      child: Scaffold(
        appBar: BaseAppBar(
          appBar: AppBar(),
          title: StringDriverSelect.title,
        ),
        body: Column(
          children: [
            /// 검색
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
              child: CustomSearchField(
                hint: StringDriverSelect.searchHint,
                icon: const Icon(Icons.search),
                onChanged: _onKeywordChanged,
                onSearch: _onSearch,
              ),
            ),

            /// 탭
            ValueListenableBuilder<String>(
              valueListenable: _driverSelectViewModel.tabTpNotifier,
              builder: (context, value, child) {
                return Row(
                  children: [
                    _buildTab(DrvSearchTp.recent, StringDriverSelect.tabRecent, value),
                    _buildTab(DrvSearchTp.favorite, StringDriverSelect.tabFavorite, value),
                    _buildTab(DrvSearchTp.nearby, StringDriverSelect.tabNearby, value),
                  ],
                );
              },
            ),
            const Divider(thickness: 1, height: 1),

            /// 목록
            Expanded(
              child: ValueListenableBuilder<StateAPI>(
                valueListenable: _driverSelectViewModel.stateNotifier,
                builder: (context, state, child) {
                  if (state is Loading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  return ValueListenableBuilder<List<Driver>>(
                    valueListenable: _driverSelectViewModel.driverListNotifier,
                    builder: (context, driverList, child) {
                      if (driverList.isEmpty) return _buildEmpty();
                      return _buildListView(driverList);
                    },
                  );
                },
              ),
            ),

            /// 우선 배차 안내
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                StringDriverSelect.notice,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).disabledColor,
                    ),
              ),
            ),

            /// 지정 없이 호출 / 지정하고 호출
            Padding(
              padding: EdgeInsets.fromLTRB(20, 12, 20, 20 + MediaQuery.of(context).padding.bottom),
              child: ValueListenableBuilder<Driver?>(
                valueListenable: _driverSelectViewModel.selectedDriverNotifier,
                builder: (context, selected, child) {
                  /// 위아래로 쌓는다. 나란히 놓으면 한 칸이 화면 폭의 절반뿐이라
                  /// 글자가 두 줄로 내려간다.
                  ///
                  /// 이 앱은 텍스트 크기를 16·19·22 세 단계로 바꿀 수 있다(CustomTextMode).
                  /// 22 에서는 두 문구가 각각 패딩까지 156dp 가량을 요구하는데, 폭 360dp
                  /// 기기의 가용 폭이 312dp 다 — 곁에 두는 배치로는 들어갈 자리가 없다.
                  /// 전체 폭을 쓰면 가장 큰 글자에도 여유가 남는다.
                  return Column(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        child: CustomRadiusButton(
                          text: StringDriverSelect.skipButton,
                          onPressed: () => context.pop(false),
                        ),
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        width: double.infinity,
                        child: CustomRadiusButton(
                          isEnabled: selected != null,
                          text: StringDriverSelect.confirmButton,
                          onPressed: () => context.pop(selected),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 탭 하나
  Widget _buildTab(String tabTp, String label, String currentTp) {
    final isSelected = tabTp == currentTp;
    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => _driverSelectViewModel.tabTp = tabTp,
        child: Container(
          padding: const EdgeInsets.only(top: 8, bottom: 10),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: isSelected ? Theme.of(context).colorScheme.primary : Colors.transparent,
                width: 2,
              ),
            ),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: isSelected ? Theme.of(context).colorScheme.primary : Theme.of(context).disabledColor,
                ),
          ),
        ),
      ),
    );
  }

  /// 결과가 없을 때. 탭마다 비어 있는 이유가 달라 문구를 나눈다
  Widget _buildEmpty() {
    final String message;
    if (_driverSelectViewModel.hasSearchableKeyword) {
      message = StringDriverSelect.emptyKeyword;
    } else if (_driverSelectViewModel.tabTp == DrvSearchTp.favorite) {
      message = StringDriverSelect.emptyFavorite;
    } else if (_driverSelectViewModel.tabTp == DrvSearchTp.nearby) {
      message = StringDriverSelect.emptyNearby;
    } else {
      message = StringDriverSelect.emptyRecent;
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(message, style: Theme.of(context).textTheme.bodyLarge),
          const SizedBox(height: 6),
          Text(
            StringDriverSelect.emptyGuide,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).disabledColor,
                ),
          ),
        ],
      ),
    );
  }

  /// 기사 목록
  Widget _buildListView(List<Driver> driverList) {
    return ScrollConfiguration(
      behavior: CustomScrollBehavior(),
      child: ValueListenableBuilder<Driver?>(
        valueListenable: _driverSelectViewModel.selectedDriverNotifier,
        builder: (context, selected, child) {
          return ListView.separated(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
            itemCount: driverList.length,
            itemBuilder: (context, index) {
              final driver = driverList[index];
              return _buildDriverItem(driver, selected?.mbrDmSq == driver.mbrDmSq);
            },
            separatorBuilder: (context, index) => const SizedBox(height: 12),
          );
        },
      ),
    );
  }

  /// 기사 한 줄
  Widget _buildDriverItem(Driver driver, bool isSelected) {
    final isSelectable = _driverSelectViewModel.isSelectable(driver);

    return GestureDetector(
      onTap: isSelectable
          ? () {
              _driverSelectViewModel.selectedDriver = driver;
              _showDetail(driver);
            }
          : null,
      child: Opacity(
        opacity: isSelectable ? 1 : 0.5,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          decoration: BoxDecoration(
            color: Theme.of(context).dividerColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? Theme.of(context).colorScheme.primary : Colors.transparent,
              width: 1.5,
            ),
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 22,
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                child: Icon(Icons.person, color: Theme.of(context).disabledColor),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(driver.drvNm, style: Theme.of(context).textTheme.titleLarge),
                        const SizedBox(width: 6),
                        if (driver.isFavorite) _buildTag(StringDriverSelect.favoriteTag),
                        if (driver.isFavorite) const SizedBox(width: 4),
                        _buildTag(_workStLabel(driver.drvWorkSt)),
                      ],
                    ),
                    const SizedBox(height: 3),
                    Text(
                      _buildSubtitle(driver),
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context).disabledColor,
                          ),
                    ),
                  ],
                ),
              ),

              /// 단골 등록·해제
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => _driverSelectViewModel.toggleFavorite(driver),
                child: Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: Icon(
                    driver.isFavorite ? Icons.star : Icons.star_border,
                    color: driver.isFavorite ? Theme.of(context).colorScheme.primary : Theme.of(context).disabledColor,
                    size: 24,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 기사번호와 평점 뒤에 탭마다 다른 값을 붙인다
  String _buildSubtitle(Driver driver) {
    final buffer = StringBuffer("${StringDriverSelect.driverNo} ${driver.drvNo}");
    if (driver.drvGradeCnt > 0) {
      buffer.write(" · ★ ${driver.drvGrade} (${driver.drvGradeCnt})");
    }
    if (driver.distance != null) {
      buffer.write(" · ${(driver.distance! / 1000).toStringAsFixed(1)}km");
    } else if (driver.lastDrvDt != null && driver.lastDrvDt!.isNotEmpty) {
      buffer.write(" · ${StringDriverSelect.lastUse} ${driver.lastDrvDt}");
    }
    return buffer.toString();
  }

  String _workStLabel(String drvWorkSt) {
    switch (drvWorkSt) {
      case DrvWorkSt.wait:
        return StringDriverSelect.workWait;
      case DrvWorkSt.work:
        return StringDriverSelect.workWorking;
      default:
        return StringDriverSelect.workOff;
    }
  }

  Widget _buildTag(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).disabledColor,
            ),
      ),
    );
  }
}
