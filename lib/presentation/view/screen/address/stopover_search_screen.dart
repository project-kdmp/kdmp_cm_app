import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:kdmp_cm_app/data/model/common/map_data_model.dart';
import 'package:kdmp_cm_app/data/model/mypage/place_list_response.dart';
import 'package:kdmp_cm_app/data/model/naver/geocoding_response.dart';
import 'package:kdmp_cm_app/domain/usecase/mypage/get_place_list_usecase.dart';
import 'package:kdmp_cm_app/domain/usecase/naver/get_naver_address_info_usecase.dart';
import 'package:kdmp_cm_app/domain/usecase/secure_storage/mbr/get_mbrsq_usecase.dart';
import 'package:kdmp_cm_app/presentation/values/strings.dart';
import 'package:kdmp_cm_app/presentation/view/screen/address/stopover_map_screen.dart';
import 'package:kdmp_cm_app/presentation/view/widget/common/behavior/custom_scroll_behavior.dart';
import 'package:kdmp_cm_app/presentation/view/widget/common/button/custom_icon_text_button.dart';
import 'package:kdmp_cm_app/presentation/view/widget/common/button/custom_round_button.dart';
import 'package:kdmp_cm_app/presentation/view/widget/common/section/base_appbar.dart';
import 'package:kdmp_cm_app/presentation/view/widget/common/text/custom_search_field.dart';
import 'package:kdmp_cm_app/presentation/viewmodel/address/stopover_search_viewmodel.dart';
import 'package:provider/provider.dart';

/// 경유지 설정 검색 화면
class StopoverSearchScreen extends StatefulWidget {
  const StopoverSearchScreen({Key? key}) : super(key: key);

  static const String routeName = "stopover_search";

  @override
  State<StopoverSearchScreen> createState() => _StopoverSearchScreenState();
}

class _StopoverSearchScreenState extends State<StopoverSearchScreen> with SingleTickerProviderStateMixin {
  late final StopoverSearchViewModel _stopoverSearchViewModel;

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    initViewModel();
    initScrollController();
    initData();
  }

  /// Create
  void initViewModel() {
    _stopoverSearchViewModel = StopoverSearchViewModel(
      getMbrSqUseCase: GetIt.instance<GetMbrSqUseCase>(),
      getNaverAddressInfoUseCase: GetIt.instance<GetNaverAddressInfoUseCase>(),
      getPlaceListUseCase: GetIt.instance<GetPlaceListUseCase>(),
    );
  }

  void initScrollController() {
    _scrollController.addListener(() {
      if (_scrollController.position.maxScrollExtent == _scrollController.position.pixels) {
        initData();
      }
    });
  }

  void initData() async {
    /// 키 관리 파일 가져오기
    await dotenv.load(fileName: ".env");
    _stopoverSearchViewModel.clientId = dotenv.get("NAVER_MAP_CLIENT_ID");
    _stopoverSearchViewModel.clientSecret = dotenv.get("NAVER_MAP_CLIENT_SECRET");

    /// 현위치 좌표 가져오기
    _stopoverSearchViewModel.currentLatLng = await getCurrentLocation();

    /// 자주 가는 장소 리스트 가져오기
    _stopoverSearchViewModel.getPlaceList();

    /// 최근 검색 리스트 가져오기
    // _stopoverSearchViewModel.getRecentList();
  }

  @override
  Widget build(BuildContext context) {
    /// Provider
    return MultiProvider(
      providers: [
        Provider<StopoverSearchViewModel>(
          create: (context) => _stopoverSearchViewModel,
        ),
      ],
      child: Scaffold(
        /// 상단 앱바
        appBar: BaseAppBar(
          appBar: AppBar(),
          title: StringStopoverSetup.title,
        ),

        /// 화면
        body: SafeArea(
          child: ScrollConfiguration(
            behavior: CustomScrollBehavior(),
            child: SingleChildScrollView(
              controller: _scrollController,
              child: Column(
                children: [
                  /// 검색바
                  Padding(
                    padding: const EdgeInsets.only(top: 20, left: 20, right: 20, bottom: 4),
                    child: ValueListenableBuilder<String>(
                      valueListenable: _stopoverSearchViewModel.keywordNotifier,
                      builder: (context, value, _) {
                        return CustomSearchField(
                          hint: StringStopoverSetup.searchHint,
                          icon: Icon(
                            Icons.location_on,
                            size: 22,
                            color: Theme.of(context).disabledColor,
                          ),
                          onSearch: (value) {
                            _stopoverSearchViewModel.keyword = value;
                            _stopoverSearchViewModel.getSearchList();
                          },
                        );
                      },
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        /// 자주 가는 장소 리스트
                        ValueListenableBuilder<List<Place>>(
                          valueListenable: _stopoverSearchViewModel.placeListNotifier,
                          builder: (context, value, child) {
                            return Expanded(child: SizedBox(height: 40, child: getPlaceList(value)));
                          },
                        ),
                        const SizedBox(width: 8),

                        /// 지도에서 선택 버튼
                        CustomIconTextButton(
                          icon: Icons.map_outlined,
                          text: StringStopoverSetup.selectMap,
                          onPressed: () async {
                            final result = await context.pushNamed(StopoverMapScreen.routeName);
                            if (result != null && result is MapData) {
                              context.pop(result);
                            }
                          },
                        ),
                      ],
                    ),
                  ),

                  const Divider(thickness: 6),

                  /// 최근 검색 리스트 또는 검색 리스트
                  ValueListenableBuilder<bool>(
                    valueListenable: _stopoverSearchViewModel.isRecentListValidNotifier,
                    builder: (context, value, child) {
                      return value
                          ? Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(StringStopoverSetup.recentKeyword, style: Theme.of(context).textTheme.titleMedium),

                                      /// 편집 버튼
                                      GestureDetector(
                                        child: Text(StringStopoverSetup.edit, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).disabledColor)),
                                        onTap: () {
                                          // TODO: 도착지 검색 기록 편집 화면으로 이동
                                        },
                                      ),
                                    ],
                                  ),
                                ),

                                /// 최근 검색 리스트
                                ValueListenableBuilder<List<String>>(
                                  valueListenable: _stopoverSearchViewModel.recentListNotifier,
                                  builder: (context, value, _) {
                                    return getRecentListView(value);
                                  },
                                )
                              ],
                            )
                          :

                          /// 검색 리스트
                          ValueListenableBuilder<List<Address>>(
                              valueListenable: _stopoverSearchViewModel.searchListNotifier,
                              builder: (context, value, _) {
                                return getSearchListView(value);
                              },
                            );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// 자주 가는 장소 리스트
  Widget getPlaceList(List<Place> value) {
    return ListView.separated(
      itemCount: value.length,
      shrinkWrap: true,
      primary: false,
      scrollDirection: Axis.horizontal,
      itemBuilder: (context, index) {
        return CustomRoundButton(
          text: value[index].fplaceNicknm ?? "",
          backgroundColor: Theme.of(context).toggleButtonsTheme.fillColor,
          textColor: Theme.of(context).colorScheme.secondary,
          textSize: 16,
          // 텍스트 사이즈 고정
          onPressed: () async {
            // TODO: 해당 장소로 도착지 설정
          },
        );
      },
      separatorBuilder: (context, index) {
        return const SizedBox(width: 8);
      },
    );
  }

  /// 검색 리스트
  Widget getSearchListView(List<Address> value) {
    return ListView.separated(
      itemCount: value.length,
      shrinkWrap: true,
      primary: false,
      itemBuilder: (context, index) {
        final item = value[index];
        final address = item.roadAddress.isNotEmpty ? item.roadAddress : item.jibunAddress;
        String place = address;
        for (int i = 0; i < item.addressElements.length; i++) {
          if (item.addressElements[i].types.isNotEmpty && item.addressElements[i].types[0] == "BUILDING_NAME") {
            place = item.addressElements[i].longName;
          }
        }
        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () async {
            /// 검색 리스트 아이템 클릭
            context.pop(
              MapData(
                latLng: NLatLng(double.parse(item.y), double.parse(item.x)),
                address: address,
                place: place,
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// 장소명
                Text(place, style: Theme.of(context).textTheme.titleLarge),

                /// 주소
                const SizedBox(height: 10),
                Text(address, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).disabledColor)),
              ],
            ),
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

  /// 최근 검색 리스트
  Widget getRecentListView(List<String> value) {
    return ListView.separated(
      itemCount: value.length,
      shrinkWrap: true,
      primary: false,
      itemBuilder: (context, index) {
        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () async {
            /// 최근 검색 리스트 아이템 클릭
            // TODO: 값 전달
            context.pop();
          },
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Icon(Icons.access_time_outlined, color: Theme.of(context).disabledColor, size: 22),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text("우림라이온스밸리", style: Theme.of(context).textTheme.titleLarge),
                    const SizedBox(height: 10),
                    Text("우림라이온스밸리", style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).disabledColor)),
                  ],
                ),
              ],
            ),
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

  Future<NLatLng> getCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    debugPrint("location position: $position");
    return NLatLng(position.latitude, position.longitude);
  }
}
