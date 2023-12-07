import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:kdmp_cm_app/domain/usecase/secure_storage/mbr/delete_mapdata_usecase.dart';
import 'package:kdmp_cm_app/domain/usecase/secure_storage/mbr/get_mapdata_list_usecase.dart';
import 'package:kdmp_cm_app/presentation/values/images.dart';
import 'package:kdmp_cm_app/presentation/values/strings.dart';
import 'package:kdmp_cm_app/presentation/view/widget/common/behavior/custom_scroll_behavior.dart';
import 'package:kdmp_cm_app/presentation/view/widget/common/button/custom_elevated_button.dart';
import 'package:kdmp_cm_app/presentation/view/widget/common/checkbox/custom_checkbox.dart';
import 'package:kdmp_cm_app/presentation/view/widget/common/section/base_appbar.dart';
import 'package:kdmp_cm_app/presentation/view/widget/common/text/custom_tag.dart';
import 'package:kdmp_cm_app/presentation/viewmodel/address/recent_search_viewmodel.dart';
import 'package:provider/provider.dart';

/// 최근 검색 기록 편집 화면
class RecentSearchScreen extends StatefulWidget {
  const RecentSearchScreen({Key? key}) : super(key: key);

  static const String routeName = "recent_search";
  static const String routeURL = "/recent_search";

  @override
  State<RecentSearchScreen> createState() => _RecentSearchScreenState();
}

class _RecentSearchScreenState extends State<RecentSearchScreen> with SingleTickerProviderStateMixin {
  late final RecentSearchViewModel _recentSearchViewModel;

  @override
  void initState() {
    super.initState();
    initViewModel();
    initData();
  }

  /// Create
  void initViewModel() {
    _recentSearchViewModel = RecentSearchViewModel(
      getMapDataListUseCase: GetIt.instance<GetMapDataListUseCase>(),
      deleteMapDataUseCase: GetIt.instance<DeleteMapDataUseCase>(),
    );
  }

  void initData() async {
    /// 최근 검색 리스트 가져오기
    _recentSearchViewModel.getRecentList();
  }

  @override
  Widget build(BuildContext context) {
    /// Provider
    return MultiProvider(
      providers: [
        Provider<RecentSearchViewModel>(
          create: (context) => _recentSearchViewModel,
        ),
      ],
      child: Scaffold(
        /// 상단 앱바
        appBar: BaseAppBar(
          appBar: AppBar(),
          title: StringRecentSearch.title,
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
                        /// 최근 검색 리스트
                        ValueListenableBuilder<List<bool>>(
                          valueListenable: _recentSearchViewModel.checkListNotifier,
                          builder: (context, value, child) {
                            return value.isEmpty
                                ?

                                /// 최근 검색 리스트 없음
                                SizedBox(
                                    height: 600,
                                    width: double.maxFinite,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Image.asset(ImageCommon.imgWarning, width: 72, height: 72),
                                        const SizedBox(height: 20),
                                        Text(
                                          StringRecentSearch.noList,
                                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                                color: Theme.of(context).disabledColor,
                                              ),
                                        )
                                      ],
                                    ),
                                  )
                                : Column(
                                    children: [
                                      /// 전체 선택
                                      ValueListenableBuilder<bool>(
                                        valueListenable: _recentSearchViewModel.isAllCheckNotifier,
                                        builder: (context, value, _) {
                                          return Padding(
                                            padding: const EdgeInsets.all(20),
                                            child: CustomCheckBox(
                                              isChecked: value,
                                              isBold: true,
                                              message: StringRecentSearch.allSelect,
                                              onPressed: (isChecked) {
                                                _recentSearchViewModel.setCheckToAll(isCheck: isChecked);
                                              },
                                            ),
                                          );
                                        },
                                      ),

                                      /// 최근 검색 리스트
                                      getRecentListView(value),
                                    ],
                                  );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              /// 삭제 버튼
              ValueListenableBuilder<bool>(
                valueListenable: _recentSearchViewModel.isValidNotifier,
                builder: (context, value, child) {
                  return Padding(
                    padding: const EdgeInsets.all(20),
                    child: CustomElevatedButton(
                      isEnabled: value,
                      text: StringRecentSearch.delete,
                      onPressed: () async {
                        /// 최근 검색 기록 삭제
                        await _recentSearchViewModel.deleteRecentMapData();
                      },
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 최근 검색 리스트
  Widget getRecentListView(List<bool> checkValue) {
    return ListView.separated(
      itemCount: checkValue.length,
      shrinkWrap: true,
      primary: false,
      itemBuilder: (context, index) {
        final item = _recentSearchViewModel.recentList[index];
        final addressRoad = item.addressRoad;
        final addressJibun = item.addressJibun;
        final place = item.place;
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Transform.scale(
                scale: 1.6,
                child: Checkbox(
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  value: checkValue[index],
                  onChanged: (isChecked) {
                    debugPrint("$isChecked");
                    _recentSearchViewModel.setCheckToIndex(index: index, isChecked: isChecked ?? false);
                  },
                  checkColor: Colors.white,
                  side: BorderSide(color: Theme.of(context).dividerColor, width: 9),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                  activeColor: Theme.of(context).colorScheme.primary,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// 장소명
                    place.isNotEmpty ? Text(place, style: Theme.of(context).textTheme.titleLarge) : const SizedBox(),
                    place.isNotEmpty ? const SizedBox(height: 10) : const SizedBox(),

                    /// 주소
                    addressRoad.isNotEmpty
                        ? Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomTag(text: "도로명", color: Theme.of(context).textTheme.bodyLarge?.color),
                              const SizedBox(width: 6),
                              Expanded(child: Text(addressRoad, style: Theme.of(context).textTheme.bodyMedium)),
                            ],
                          )
                        : const SizedBox(),
                    addressJibun.isNotEmpty ? const SizedBox(height: 10) : const SizedBox(),
                    addressJibun.isNotEmpty
                        ? Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomTag(text: "지번", color: Theme.of(context).textTheme.bodyLarge?.color),
                              const SizedBox(width: 6),
                              Expanded(child: Text(addressJibun, style: Theme.of(context).textTheme.bodyMedium)),
                            ],
                          )
                        : const SizedBox(),
                  ],
                ),
              ),
            ],
          ),
        );
      },
      separatorBuilder: (context, index) {
        return const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Divider(thickness: 1),
        );
      },
    );
  }
}
