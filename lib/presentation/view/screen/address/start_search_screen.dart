import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:kdmp_cm_app/data/constant/constants.dart';
import 'package:kdmp_cm_app/data/model/common/map_data_model.dart';
import 'package:kdmp_cm_app/data/model/common/state.dart';
import 'package:kdmp_cm_app/data/model/juso/juso_list_response.dart';
import 'package:kdmp_cm_app/domain/usecase/juso/get_juso_address_usecase.dart';
import 'package:kdmp_cm_app/domain/usecase/naver/get_naver_address_info_usecase.dart';
import 'package:kdmp_cm_app/domain/usecase/secure_storage/mbr/add_mapdata_usecase.dart';
import 'package:kdmp_cm_app/domain/usecase/secure_storage/mbr/get_mapdata_list_usecase.dart';
import 'package:kdmp_cm_app/domain/usecase/secure_storage/mbr/get_mbrsq_usecase.dart';
import 'package:kdmp_cm_app/presentation/values/strings.dart';
import 'package:kdmp_cm_app/presentation/view/screen/address/recent_search_screen.dart';
import 'package:kdmp_cm_app/presentation/view/screen/address/start_map_screen.dart';
import 'package:kdmp_cm_app/presentation/view/widget/common/behavior/custom_scroll_behavior.dart';
import 'package:kdmp_cm_app/presentation/view/widget/common/button/custom_icon_text_button.dart';
import 'package:kdmp_cm_app/presentation/view/widget/common/section/base_appbar.dart';
import 'package:kdmp_cm_app/presentation/view/widget/common/text/custom_search_field.dart';
import 'package:kdmp_cm_app/presentation/viewmodel/address/start_search_viewmodel.dart';
import 'package:provider/provider.dart';

/// 출발지 설정 검색 화면
class StartSearchScreen extends StatefulWidget {
  const StartSearchScreen({Key? key}) : super(key: key);

  static const String routeName = "start_search";

  @override
  State<StartSearchScreen> createState() => _StartSearchScreenState();
}

class _StartSearchScreenState extends State<StartSearchScreen> with SingleTickerProviderStateMixin {
  late final StartSearchViewModel _startSearchViewModel;

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
    _startSearchViewModel = StartSearchViewModel(
      getMbrSqUseCase: GetIt.instance<GetMbrSqUseCase>(),
      getNaverAddressInfoUseCase: GetIt.instance<GetNaverAddressInfoUseCase>(),
      getJusoListUseCase: GetIt.instance<GetJusoListUseCase>(),
      getMapDataListUseCase: GetIt.instance<GetMapDataListUseCase>(),
      addMapDataUseCase: GetIt.instance<AddMapDataUseCase>(),
    );
  }

  void initScrollController() {
    _scrollController.addListener(() {
      if (_scrollController.position.maxScrollExtent == _scrollController.position.pixels) {
        /// 검색 리스트 조회
        _startSearchViewModel.getSearchList();
      }
    });
  }

  void initData() async {
    /// 키 관리 파일 가져오기
    await dotenv.load(fileName: ".env");
    _startSearchViewModel.clientId = dotenv.get(AppConstants.NAVER_CLIENT_ID);
    _startSearchViewModel.clientSecret = dotenv.get(AppConstants.NAVER_CLIENT_SECRET);
    _startSearchViewModel.jusoApiKey = dotenv.get(AppConstants.JUSO_API_KEY);

    /// 최근 검색 리스트 가져오기
    _startSearchViewModel.getRecentList();
  }

  @override
  Widget build(BuildContext context) {
    /// Provider
    return MultiProvider(
      providers: [
        Provider<StartSearchViewModel>(
          create: (context) => _startSearchViewModel,
        ),
      ],
      child: Scaffold(
        /// 상단 앱바
        appBar: BaseAppBar(
          appBar: AppBar(),
          title: StringStartSetup.title,
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
                      valueListenable: _startSearchViewModel.keywordNotifier,
                      builder: (context, value, _) {
                        return CustomSearchField(
                          hint: StringStartSetup.searchHint,
                          icon: Icon(
                            Icons.location_on,
                            size: 22,
                            color: Theme.of(context).disabledColor,
                          ),
                          onSearch: (value) async {
                            _startSearchViewModel.keyword = value;

                            /// 페이지 정보 초기화
                            _startSearchViewModel.clearPagination();

                            /// 검색 리스트 조회
                            await _startSearchViewModel.getSearchList();
                          },
                        );
                      },
                    ),
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      /// 현위치 버튼
                      CustomIconTextButton(
                        icon: Icons.location_searching_outlined,
                        text: StringStartSetup.nowLocation,
                        onPressed: () async {
                          final result = await context.pushNamed(StartMapScreen.routeName);
                          if (result != null && result is MapData) {
                            await setMapData(address: result.address, place: result.place);
                          }
                        },
                      ),
                      const SizedBox(height: 10, child: VerticalDivider(width: 20, thickness: 1)),

                      /// 지도에서 선택 버튼
                      CustomIconTextButton(
                        icon: Icons.map_outlined,
                        text: StringStartSetup.selectMap,
                        onPressed: () async {
                          final result = await context.pushNamed(StartMapScreen.routeName);
                          if (result != null && result is MapData) {
                            await setMapData(address: result.address, place: result.place);
                          }
                        },
                      ),
                      const SizedBox(width: 20),
                    ],
                  ),

                  const Divider(thickness: 6),

                  /// 최근 검색 리스트 또는 검색 리스트
                  ValueListenableBuilder<bool>(
                    valueListenable: _startSearchViewModel.isRecentListValidNotifier,
                    builder: (context, value, child) {
                      return value
                          ? Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(StringStartSetup.recentKeyword, style: Theme.of(context).textTheme.titleMedium),

                                      /// 편집 버튼
                                      GestureDetector(
                                        child: Text(StringStartSetup.edit, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).disabledColor)),
                                        onTap: () async {
                                          /// 최근 검색 기록 편집 화면으로 이동
                                          await context.pushNamed(RecentSearchScreen.routeName);

                                          /// 최근 검색 리스트 가져오기
                                          _startSearchViewModel.getRecentList();
                                        },
                                      ),
                                    ],
                                  ),
                                ),

                                /// 최근 검색 리스트
                                ValueListenableBuilder<List<MapData>>(
                                  valueListenable: _startSearchViewModel.recentListNotifier,
                                  builder: (context, value, _) {
                                    return getRecentListView(value);
                                  },
                                )
                              ],
                            )
                          :

                          /// 검색 리스트
                          ValueListenableBuilder<List<Juso>>(
                              valueListenable: _startSearchViewModel.searchListNotifier,
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

  /// 검색 리스트
  Widget getSearchListView(List<Juso> value) {
    return ListView.separated(
      itemCount: value.length,
      shrinkWrap: true,
      primary: false,
      itemBuilder: (context, index) {
        final item = value[index];
        final address = item.jibunAddr;
        final place = item.bdNm;
        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () async {
            /// 검색 리스트 아이템 클릭
            await setMapData(address: address, place: place);
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
            await setMapData(address: address, place: place);
          },
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.access_time_outlined, color: Theme.of(context).disabledColor, size: 22),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(place.isNotEmpty ? place : "장소명 없음", style: Theme.of(context).textTheme.titleLarge),
                      const SizedBox(height: 10),
                      Text(address, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).disabledColor)),
                    ],
                  ),
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

  /// 장소 정보 검색 후 전 화면으로 값 전달
  Future<void> setMapData({required String address, required String place}) async {
    /// 검색된 주소로 장소 정보 검색
    final result = await _startSearchViewModel.getAddressInfo(address: address);
    if (result is Success) {
      final addressInfo = result.geocodingResponse.addresses![0];
      String sido = "";
      String sigugun = "";
      String dongmyun = "";
      for (int i = 0; i < addressInfo.addressElements.length; i++) {
        final types = addressInfo.addressElements[i].types[0];
        if (types == "SIDO") {
          sido = addressInfo.addressElements[i].longName;
        } else if (types == "SIGUGUN") {
          sigugun = addressInfo.addressElements[i].longName;
        } else if (types == "DONGMYUN") {
          dongmyun = addressInfo.addressElements[i].longName;
        }
      }
      final drivingAddress = DrivingAddress(
        sido: sido,
        sigungu: sigugun,
        legalDong: dongmyun,
      );

      /// 선택 장소 정보 최근 검색 기록에 저장 후, 이전 화면에 장소 정보 전달
      final mapData = MapData(
        latLng: NLatLng(double.parse(addressInfo.y), double.parse(addressInfo.x)),
        address: address,
        place: place,
        drivingAddress: drivingAddress,
      );
      await _startSearchViewModel.addRecentMapData(mapData: mapData);
      context.pop(mapData);
    } else {
      Fluttertoast.showToast(msg: "해당 지역을 검색할 수 없습니다.");
    }
  }
}
