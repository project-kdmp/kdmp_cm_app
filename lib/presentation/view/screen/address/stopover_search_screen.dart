import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:kdmp_cm_app/data/model/common/map_data_model.dart';
import 'package:kdmp_cm_app/data/model/common/state.dart';
import 'package:kdmp_cm_app/data/model/juso/juso_list_response.dart';
import 'package:kdmp_cm_app/data/model/mypage/place_list_response.dart';
import 'package:kdmp_cm_app/domain/usecase/juso/get_juso_address_usecase.dart';
import 'package:kdmp_cm_app/domain/usecase/mypage/get_place_list_usecase.dart';
import 'package:kdmp_cm_app/domain/usecase/naver/get_naver_address_info_usecase.dart';
import 'package:kdmp_cm_app/domain/usecase/secure_storage/mbr/add_mapdata_usecase.dart';
import 'package:kdmp_cm_app/domain/usecase/secure_storage/mbr/get_mapdata_list_usecase.dart';
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
class StopOverSearchScreen extends StatefulWidget {
  const StopOverSearchScreen({Key? key}) : super(key: key);

  static const String routeName = "stopover_search";

  @override
  State<StopOverSearchScreen> createState() => _StopOverSearchScreenState();
}

class _StopOverSearchScreenState extends State<StopOverSearchScreen> with SingleTickerProviderStateMixin {
  late final StopOverSearchViewModel _stopOverSearchViewModel;

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
    _stopOverSearchViewModel = StopOverSearchViewModel(
      getMbrSqUseCase: GetIt.instance<GetMbrSqUseCase>(),
      getNaverAddressInfoUseCase: GetIt.instance<GetNaverAddressInfoUseCase>(),
      getJusoListUseCase: GetIt.instance<GetJusoListUseCase>(),
      getPlaceListUseCase: GetIt.instance<GetPlaceListUseCase>(),
      getMapDataListUseCase: GetIt.instance<GetMapDataListUseCase>(),
      addMapDataUseCase: GetIt.instance<AddMapDataUseCase>(),
    );
  }

  void initScrollController() {
    _scrollController.addListener(() {
      if (_scrollController.position.maxScrollExtent == _scrollController.position.pixels) {
        /// 검색 리스트 조회
        _stopOverSearchViewModel.getSearchList();
      }
    });
  }

  void initData() async {
    /// 키 관리 파일 가져오기
    await dotenv.load(fileName: ".env");
    _stopOverSearchViewModel.clientId = dotenv.get("NAVER_MAP_CLIENT_ID");
    _stopOverSearchViewModel.clientSecret = dotenv.get("NAVER_MAP_CLIENT_SECRET");
    _stopOverSearchViewModel.jusoApiKey = dotenv.get("JUSO_API_KEY");

    /// 자주 가는 장소 리스트 가져오기
    _stopOverSearchViewModel.getPlaceList();

    /// 최근 검색 리스트 가져오기
    _stopOverSearchViewModel.getRecentList();
  }

  @override
  Widget build(BuildContext context) {
    /// Provider
    return MultiProvider(
      providers: [
        Provider<StopOverSearchViewModel>(
          create: (context) => _stopOverSearchViewModel,
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
                      valueListenable: _stopOverSearchViewModel.keywordNotifier,
                      builder: (context, value, _) {
                        return CustomSearchField(
                          hint: StringStopOverSetup.searchHint,
                          icon: Icon(
                            Icons.location_on,
                            size: 22,
                            color: Theme.of(context).disabledColor,
                          ),
                          onSearch: (value) async {
                            _stopOverSearchViewModel.keyword = value;

                            /// 페이지 정보 초기화
                            _stopOverSearchViewModel.clearPagination();

                            /// 검색 리스트 조회
                            final result = await _stopOverSearchViewModel.getSearchList();
                            if (result is Success) {
                            } else if (result is Bad) {
                              Fluttertoast.showToast(msg: result.badResponse.detailMessage);
                            } else if (result is Fail) {
                              Fluttertoast.showToast(msg: "${result.errorMessage}");
                            }
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
                          valueListenable: _stopOverSearchViewModel.placeListNotifier,
                          builder: (context, value, child) {
                            return Expanded(child: SizedBox(height: 40, child: getPlaceList(value)));
                          },
                        ),
                        const SizedBox(width: 8),

                        /// 지도에서 선택 버튼
                        CustomIconTextButton(
                          icon: Icons.map_outlined,
                          text: StringStopOverSetup.selectMap,
                          onPressed: () async {
                            final result = await context.pushNamed(StopOverMapScreen.routeName);
                            if (result != null && result is MapData) {
                              /// 선택 장소 정보 최근 검색 기록에 저장 후, 이전 화면에 장소 정보 전달
                              _stopOverSearchViewModel.addRecentMapData(mapData: result);
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
                    valueListenable: _stopOverSearchViewModel.isRecentListValidNotifier,
                    builder: (context, value, child) {
                      return value
                          ? Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(StringStopOverSetup.recentKeyword, style: Theme.of(context).textTheme.titleMedium),

                                      /// 편집 버튼
                                      GestureDetector(
                                        child: Text(StringStopOverSetup.edit, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).disabledColor)),
                                        onTap: () {
                                          // TODO: 도착지 검색 기록 편집 화면으로 이동
                                        },
                                      ),
                                    ],
                                  ),
                                ),

                                /// 최근 검색 리스트
                                ValueListenableBuilder<List<MapData>>(
                                  valueListenable: _stopOverSearchViewModel.recentListNotifier,
                                  builder: (context, value, _) {
                                    return getRecentListView(value);
                                  },
                                )
                              ],
                            )
                          :

                          /// 검색 리스트
                          ValueListenableBuilder<List<Juso>>(
                              valueListenable: _stopOverSearchViewModel.searchListNotifier,
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
            /// 해당 장소로 경유지 설정
            final mapData = MapData(
              place: value[index].fplacePlaceNm,
              address: value[index].fplaceAddress,
              latLng: NLatLng(value[index].gpsLat, value[index].gpsLong),
            );

            /// 선택 장소 정보 최근 검색 기록에 저장 후, 이전 화면에 장소 정보 전달
            _stopOverSearchViewModel.addRecentMapData(mapData: mapData);
            context.pop(mapData);
          },
        );
      },
      separatorBuilder: (context, index) {
        return const SizedBox(width: 8);
      },
    );
  }

  /// 검색 리스트
  Widget getSearchListView(List<Juso> value) {
    return ListView.separated(
      itemCount: value.length,
      shrinkWrap: true,
      primary: false,
      itemBuilder: (context, index) {
        final item = value[index];
        final address = item.roadAddrPart1;
        final place = item.bdNm;
        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () async {
            /// 검색 리스트 아이템 클릭
            /// 검색된 주소로 장소 정보 검색
            final result = await _stopOverSearchViewModel.getAddressInfo(address: item.roadAddrPart1);
            if (result is Success) {
              final addressInfo = result.geocodingResponse.addresses![0];

              /// 선택 장소 정보 최근 검색 기록에 저장 후, 이전 화면에 장소 정보 전달
              final mapData = MapData(
                latLng: NLatLng(double.parse(addressInfo.y), double.parse(addressInfo.x)),
                address: address,
                place: place,
              );
              await _stopOverSearchViewModel.addRecentMapData(mapData: mapData);
              context.pop(mapData);
            } else if (result is Bad) {
              Fluttertoast.showToast(msg: result.badResponse.detailMessage);
            } else if (result is Fail) {
              Fluttertoast.showToast(msg: "${result.errorMessage}");
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// 장소명
                Text(place.isNotEmpty ? place : "장소명 없음", style: Theme.of(context).textTheme.titleLarge),

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
  Widget getRecentListView(List<MapData> value) {
    return ListView.separated(
      itemCount: value.length,
      shrinkWrap: true,
      primary: false,
      itemBuilder: (context, index) {
        final item = value[index];
        final address = item.address;
        final place = item.place;
        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () async {
            /// 최근 검색 리스트 아이템 클릭

            /// 선택 장소 정보 최근 검색 기록에 저장 후, 이전 화면에 장소 정보 전달
            await _stopOverSearchViewModel.addRecentMapData(mapData: value[index]);
            context.pop(value[index]);
          },
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.access_time_outlined, color: Theme.of(context).disabledColor, size: 22),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(place.isNotEmpty ? place : "장소명 없음", style: Theme.of(context).textTheme.titleLarge),
                    const SizedBox(height: 10),
                    Text(address, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).disabledColor)),
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
