import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:kdmp_cm_app/data/constant/codes.dart';
import 'package:kdmp_cm_app/data/constant/constants.dart';
import 'package:kdmp_cm_app/data/model/common/map_data_model.dart';
import 'package:kdmp_cm_app/data/model/common/policy_model.dart';
import 'package:kdmp_cm_app/data/model/common/state.dart';
import 'package:kdmp_cm_app/data/model/common/stopover_model.dart';
import 'package:kdmp_cm_app/data/model/mypage/car_list_response.dart';
import 'package:kdmp_cm_app/data/model/payment/payment_model.dart';
import 'package:kdmp_cm_app/domain/usecase/lost_child/get_lost_child_list_usecase.dart';
import 'package:kdmp_cm_app/domain/usecase/mypage/get_car_list_usecase.dart';
import 'package:kdmp_cm_app/domain/usecase/naver/get_naver_address_usecase.dart';
import 'package:kdmp_cm_app/domain/usecase/naver/get_naver_driving_usecase.dart';
import 'package:kdmp_cm_app/domain/usecase/policy/get_policy_usecase.dart';
import 'package:kdmp_cm_app/domain/usecase/secure_storage/mbr/get_mbrsq_usecase.dart';
import 'package:kdmp_cm_app/domain/usecase/secure_storage/mbr/get_payment_list_usecase.dart';
import 'package:kdmp_cm_app/domain/usecase/secure_storage/setup/setup_usecase.dart';
import 'package:kdmp_cm_app/domain/usecase/work/get_driving_price_usecase.dart';
import 'package:kdmp_cm_app/domain/usecase/work/get_driving_usecase.dart';
import 'package:kdmp_cm_app/domain/usecase/work/set_call_request_usecase.dart';
import 'package:kdmp_cm_app/domain/usecase/work/set_reservation_request_usecase.dart';
import 'package:kdmp_cm_app/presentation/theme/custom_theme_mode.dart';
import 'package:kdmp_cm_app/presentation/util/string_util.dart';
import 'package:kdmp_cm_app/presentation/values/strings.dart';
import 'package:kdmp_cm_app/presentation/view/bottomsheet/call_price_bottom_sheet.dart';
import 'package:kdmp_cm_app/presentation/view/bottomsheet/car_select_bottom_sheet.dart';
import 'package:kdmp_cm_app/presentation/view/bottomsheet/reservation_bottom_sheet.dart';
import 'package:kdmp_cm_app/presentation/view/bottomsheet/reservation_confirm_bottom_sheet.dart';
import 'package:kdmp_cm_app/presentation/view/dialog/call_confirm_dialog.dart';
import 'package:kdmp_cm_app/presentation/view/dialog/custom_alert_dialog.dart';
import 'package:kdmp_cm_app/presentation/view/dialog/custom_confirm_dialog.dart';
import 'package:kdmp_cm_app/presentation/view/dialog/lost_child_dialog.dart';
import 'package:kdmp_cm_app/presentation/view/screen/address/end_search_screen.dart';
import 'package:kdmp_cm_app/presentation/view/screen/address/start_search_screen.dart';
import 'package:kdmp_cm_app/presentation/view/screen/menu/menu_screen.dart';
import 'package:kdmp_cm_app/presentation/view/screen/mypage/call_detail_screen.dart';
import 'package:kdmp_cm_app/presentation/view/screen/payment/payment_management_screen.dart';
import 'package:kdmp_cm_app/presentation/view/screen/work/work_screen.dart';
import 'package:kdmp_cm_app/presentation/view/widget/common/button/custom_radius_button.dart';
import 'package:kdmp_cm_app/presentation/view/widget/common/button/custom_round_button.dart';
import 'package:kdmp_cm_app/presentation/view/widget/common/button/custom_text_button.dart';
import 'package:kdmp_cm_app/presentation/view/widget/common/divider/vertical_dashed_divider.dart';
import 'package:kdmp_cm_app/presentation/viewmodel/address/naver_map_viewmodel.dart';
import 'package:kdmp_cm_app/presentation/viewmodel/home/home_viewmodel.dart';
import 'package:kdmp_cm_app/presentation/viewmodel/home/lost_child_viewmodel.dart';
import 'package:provider/provider.dart';

/// 홈 화면
class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key, this.drivingData}) : super(key: key);

  static const String routeName = "home";
  static const String routeURL = "/home";

  final Map<String, dynamic>? drivingData;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final HomeViewModel _homeViewModel;
  late final NaverMapViewModel _naverMapViewModel;
  late final LostChildViewModel _lostChildViewModel;
  DateTime? _lastOnPressed;

  late final NMarker currentMarker;

  /// 호출 정보 바텀시트 (출발/도착지는 항상 노출, 그 외 정보는 자유롭게 드래그하여 크기 조절)
  /// 현재 드래그로 펼쳐진 나머지 영역(요금/결제/버튼)의 높이(px). 손을 뗀 위치 그대로 고정됨.
  double _extraContentHeight = 0;

  /// 나머지 영역이 전부 펼쳐졌을 때의 실제(자연스러운) 높이(px). 콘텐츠에 따라 매 프레임 갱신됨.
  double _extraContentMaxHeight = 0;
  bool _extraContentHeightInitialized = false;
  final GlobalKey _extraContentKey = GlobalKey();

  /// 나머지 영역의 실제 높이를 측정하여 드래그 가능 범위(0 ~ 실제 높이)를 최신 상태로 유지
  void _measureExtraContentHeight() {
    final renderBox =
        _extraContentKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox == null || !renderBox.hasSize) {
      return;
    }

    final measuredHeight = renderBox.size.height;
    if ((measuredHeight - _extraContentMaxHeight).abs() < 0.5) {
      return;
    }

    final wasAtMax = !_extraContentHeightInitialized ||
        _extraContentHeight >= _extraContentMaxHeight - 0.5;
    setState(() {
      _extraContentMaxHeight = measuredHeight;
      if (!_extraContentHeightInitialized || wasAtMax) {
        /// 최초 진입 시, 혹은 이전에 완전히 펼쳐진 상태였다면 새 높이에 맞춰 펼침 유지
        _extraContentHeight = measuredHeight;
      } else {
        _extraContentHeight = _extraContentHeight.clamp(0.0, measuredHeight);
      }
      _extraContentHeightInitialized = true;
    });
  }

  /// 네이버 지도
  final ValueNotifier<NaverMap?> _naverMap = ValueNotifier<NaverMap?>(null);

  ValueNotifier<NaverMap?> get naverMapNotifier => _naverMap;

  NaverMap? get naverMap => _naverMap.value;

  set naverMap(NaverMap? value) => _naverMap.value = value;

  @override
  void initState() {
    super.initState();
    initViewModel();
    initDataFirst();
    initData();
  }

  /// Create
  void initViewModel() async {
    _homeViewModel = HomeViewModel(
      getMbrSqUseCase: GetIt.instance<GetMbrSqUseCase>(),
      getCarListUseCase: GetIt.instance<GetCarListUseCase>(),
      getNaverDrivingUseCase: GetIt.instance<GetNaverDrivingUseCase>(),
      setCallRequestUseCase: GetIt.instance<SetCallRequestUseCase>(),
      setReservationRequestUseCase:
          GetIt.instance<SetReservationRequestUseCase>(),
      getDrivingUseCase: GetIt.instance<GetDrivingUseCase>(),
      getDrivingPriceUseCase: GetIt.instance<GetDrivingPriceUseCase>(),
      getPaymentListUseCase: GetIt.instance<GetPaymentListUseCase>(),
      getPolicyUseCase: GetIt.instance<GetPolicyUseCase>(),
    );

    /// 키 관리 파일 가져오기
    await dotenv.load(fileName: ".env");
    _homeViewModel.clientId = dotenv.get(AppConstants.NAVER_CLIENT_ID);
    _homeViewModel.clientSecret = dotenv.get(AppConstants.NAVER_CLIENT_SECRET);

    _naverMapViewModel = NaverMapViewModel(
      clientId: _homeViewModel.clientId,
      clientSecret: _homeViewModel.clientSecret,
      getNaverAddressUseCase: GetIt.instance<GetNaverAddressUseCase>(),
    );

    _lostChildViewModel = LostChildViewModel(
      getLostChildListUseCase: GetIt.instance<GetLostChildListUseCase>(),
      setupUseCase: GetIt.instance<SetupUseCase>(),
    );
  }

  void initDataFirst() async {
    /// 결제수단 조회
    await _homeViewModel.getPayment();
    debugPrint("initDataFirst: ${widget.drivingData}");

    /// 다시 호출로 접근 시 호출 데이터 전달
    if (widget.drivingData != null) {
      _homeViewModel.setDrivingData(
        startMapData: widget.drivingData!["startMapData"] as MapData,
        endMapData: widget.drivingData!["endMapData"] as MapData,
        stopOverList: widget.drivingData!["stopOverList"] as List<StopOver>,
      );
    }
  }

  void initData() async {
    /// 현재 진행중인 콜 여부 조회, 운행 화면으로 이동
    final drvReqSq = await _homeViewModel.getDriving();
    if (drvReqSq != null) {
      await context.pushNamed(
        WorkScreen.routeName,
        extra: drvReqSq,
      );
    }

    /// 현위치 좌표 가져오기
    _homeViewModel.currentLatLng = await getCurrentLocation();
    // _homeViewModel.currentLatLng = const NLatLng(37.4668787, 126.88837); // TODO: 임시값

    /// 출발지 미지정 시 현재 위치를 기본 출발지로 설정 (다시 호출 데이터가 있는 경우는 제외)
    MapData? currentMapData;
    if (_homeViewModel.startMapData == null && widget.drivingData == null) {
      currentMapData = await _naverMapViewModel.getAddress(
          nLatLng: _homeViewModel.currentLatLng);
      _homeViewModel.startMapData = currentMapData;
    }

    /// 네이버 지도 초기화
    naverMap = initNaverMap(nLatLng: _homeViewModel.currentLatLng);

    /// 실종아동 찾기 팝업 (24시간마다 1회 자동 노출)
    _checkLostChild(currentMapData);
  }

  /// 실종아동 찾기 팝업 노출 여부 확인 후 노출
  void _checkLostChild(MapData? currentMapData) async {
    final needToShow = await _lostChildViewModel.needToShow();
    if (!needToShow) {
      return;
    }

    final mapData = currentMapData ??
        await _naverMapViewModel.getAddress(
            nLatLng: _homeViewModel.currentLatLng);

    final lostChildList = await _lostChildViewModel.getLostChildList(
      sido: mapData.drivingAddress.sido,
      sigungu: mapData.drivingAddress.sigungu,
    );

    if (!mounted || lostChildList.isEmpty) {
      return;
    }

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return LostChildDialog(
          lostChildList: lostChildList,
          lostChildHour: _lostChildViewModel.lostChildHour,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance
        .addPostFrameCallback((_) => _measureExtraContentHeight());

    return MultiProvider(
      providers: [
        Provider<HomeViewModel>(
          create: (context) => _homeViewModel,
        ),
      ],
      child: Scaffold(
        /// 상단 앱바
        appBar: AppBar(
          title: Text(
            StringHome.title,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          centerTitle: true,
          automaticallyImplyLeading: false,
          elevation: 0.0,
          actions: [
            /// 메뉴 버튼
            IconButton(
              onPressed: () async {
                /// 화면 이동 전 네이버지도 가림
                naverMap = null;

                await context.pushNamed(MenuScreen.routeName);

                /// 화면 이동 완료 후 네이버 지도 보여줌
                initData();
              },
              padding: const EdgeInsets.only(right: 10),
              icon: const Icon(Icons.menu),
            ),
          ],
        ),

        /// 화면
        body: WillPopScope(
          onWillPop: _onBackPressed,
          child: SafeArea(
            child: Stack(
              children: [
                /// 네이버 지도 (전체 화면)
                Positioned.fill(
                  child: ValueListenableBuilder<NaverMap?>(
                    valueListenable: naverMapNotifier,
                    builder: (context, value, child) {
                      return value ??
                          Container(color: Theme.of(context).cardColor);
                    },
                  ),
                ),

                /// 호출 정보 바텀시트 (출발/도착지는 항상 노출, 나머지는 접고 펼침)
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Container(
                    constraints: BoxConstraints(
                      maxHeight: MediaQuery.of(context).size.height * 0.9,
                    ),
                    decoration: BoxDecoration(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color:
                              Theme.of(context).disabledColor.withOpacity(0.5),
                          spreadRadius: 0,
                          blurRadius: 20,
                          offset: const Offset(0, -4),
                        ),
                      ],
                    ),
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onVerticalDragUpdate: (details) {
                        setState(() {
                          _extraContentHeight =
                              (_extraContentHeight - details.delta.dy)
                                  .clamp(0.0, _extraContentMaxHeight);
                        });
                      },
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          /// 드래그 핸들 (시트 어디를 드래그해도 동작, 손을 뗀 위치 그대로 고정됨)
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            alignment: Alignment.center,
                            child: Container(
                              width: 40,
                              height: 4,
                              decoration: BoxDecoration(
                                color: Theme.of(context).disabledColor,
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                          ),

                          SingleChildScrollView(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                /// 출발지 / 도착지 (항상 노출)
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(28, 0, 28, 20),
                                  child: Column(
                                    children: [
                                      /// 출발지
                                      ValueListenableBuilder<MapData?>(
                                        valueListenable:
                                            _homeViewModel.startMapDataNotifier,
                                        builder: (context, value, child) {
                                          return Row(
                                            children: [
                                              Icon(
                                                Icons.location_on,
                                                color: value != null
                                                    ? Theme.of(context)
                                                        .colorScheme
                                                        .secondary
                                                    : Theme.of(context)
                                                        .disabledColor,
                                                size: 24,
                                              ),
                                              const SizedBox(width: 4),
                                              Text(
                                                StringCommon.startSpot,
                                                style: TextStyle(
                                                  color: value != null
                                                      ? Theme.of(context)
                                                          .colorScheme
                                                          .secondary
                                                      : Theme.of(context)
                                                          .disabledColor,
                                                ),
                                              ),

                                              /// 출발지 검색 버튼
                                              Expanded(
                                                child: CustomTextButton(
                                                  hint:
                                                      StringHome.startPlaceHint,
                                                  text: value != null
                                                      ? value.place.isNotEmpty
                                                          ? value.place
                                                          : value.addressRoad
                                                      : "",
                                                  backgroundColor:
                                                      Colors.transparent,
                                                  onPressed: () async {
                                                    /// 화면 이동 전 네이버지도 가림
                                                    naverMap = null;

                                                    /// 출발지 설정 검색 화면으로 이동
                                                    final result =
                                                        await context.pushNamed(
                                                            StartSearchScreen
                                                                .routeName);
                                                    if (result != null &&
                                                        result is MapData) {
                                                      _homeViewModel
                                                              .startMapData =
                                                          result;
                                                    }

                                                    /// 화면 이동, 데이터 갱신 후, 네이버 지도 갱신
                                                    initData();
                                                  },
                                                ),
                                              ),
                                            ],
                                          );
                                        },
                                      ),

                                      /// 구분선
                                      ValueListenableBuilder<List<StopOver>>(
                                        valueListenable:
                                            _homeViewModel.stopOverListNotifier,
                                        builder: (context, value, child) {
                                          String text = value.isNotEmpty
                                              ? value[0].placeName.isNotEmpty
                                                  ? value[0].placeName
                                                  : value[0].address
                                              : "";
                                          if (value.length > 1) {
                                            text += " 외 ${value.length - 1}";
                                          }
                                          return value.isNotEmpty
                                              ? Row(
                                                  children: [
                                                    SizedBox(
                                                      height: 44,
                                                      child:
                                                          VerticalDashedDivider(
                                                        thickness: 2,
                                                        color: Theme.of(context)
                                                            .disabledColor,
                                                        space: 24,
                                                        length: 3,
                                                      ),
                                                    ),

                                                    /// 경유지 표시
                                                    Expanded(
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                vertical: 12),
                                                        child: Text(text,
                                                            style: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .bodyLarge),
                                                      ),
                                                    ),

                                                    /// 경유지 삭제 버튼
                                                    GestureDetector(
                                                      child: Icon(Icons.close,
                                                          size: 16,
                                                          color: Theme.of(
                                                                  context)
                                                              .disabledColor),
                                                      onTap: () {
                                                        /// 경유지 삭제
                                                        _homeViewModel
                                                            .clearStopOverList();

                                                        /// 화면 이동, 데이터 갱신 후, 네이버 지도 갱신
                                                        naverMap = null;
                                                        initData();
                                                      },
                                                    ),
                                                  ],
                                                )
                                              : Row(
                                                  children: [
                                                    SizedBox(
                                                      height: 16,
                                                      child:
                                                          VerticalDashedDivider(
                                                        thickness: 2,
                                                        color: Theme.of(context)
                                                            .disabledColor,
                                                        space: 24,
                                                        length: 2,
                                                      ),
                                                    ),
                                                    const SizedBox(width: 18),
                                                    const Expanded(
                                                        child: Divider(
                                                            thickness: 1)),
                                                  ],
                                                );
                                        },
                                      ),

                                      /// 도착지
                                      ValueListenableBuilder<MapData?>(
                                        valueListenable:
                                            _homeViewModel.endMapDataNotifier,
                                        builder: (context, value, child) {
                                          return Row(
                                            children: [
                                              Icon(
                                                Icons.flag_sharp,
                                                color: value != null
                                                    ? Theme.of(context)
                                                        .colorScheme
                                                        .secondary
                                                    : Theme.of(context)
                                                        .disabledColor,
                                                size: 24,
                                              ),
                                              const SizedBox(width: 4),
                                              Text(
                                                StringCommon.endSpot,
                                                style: TextStyle(
                                                  color: value != null
                                                      ? Theme.of(context)
                                                          .colorScheme
                                                          .secondary
                                                      : Theme.of(context)
                                                          .disabledColor,
                                                ),
                                              ),

                                              /// 도착지 검색 버튼
                                              Expanded(
                                                child: CustomTextButton(
                                                  hint: StringHome.endPlaceHint,
                                                  text: value != null
                                                      ? value.place.isNotEmpty
                                                          ? value.place
                                                          : value.addressRoad
                                                      : "",
                                                  backgroundColor:
                                                      Colors.transparent,
                                                  onPressed: () async {
                                                    /// 화면 이동 전 네이버지도 가림
                                                    naverMap = null;

                                                    /// 도착지 설정 검색 화면으로 이동
                                                    final result =
                                                        await context.pushNamed(
                                                            EndSearchScreen
                                                                .routeName);
                                                    if (result != null &&
                                                        result is MapData) {
                                                      _homeViewModel
                                                          .endMapData = result;
                                                    }

                                                    /// 화면 이동, 데이터 갱신 후, 네이버 지도 갱신
                                                    initData();
                                                  },
                                                ),
                                              ),
                                            ],
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                ),

                                /// 나머지 영역 (요금/결제/버튼) - 드래그한 높이만큼만 노출됨
                                ClipRect(
                                  child: SizedBox(
                                    height: _extraContentHeight,
                                    child: OverflowBox(
                                      alignment: Alignment.topCenter,
                                      minHeight: 0,
                                      maxHeight: double.infinity,
                                      child: Column(
                                        key: _extraContentKey,
                                        children: [
                                          /// 요금 선택
                                          ValueListenableBuilder<bool>(
                                            valueListenable: _homeViewModel
                                                .isPriceButtonValidNotifier,
                                            builder: (context, value, child) {
                                              debugPrint(
                                                  "asdfasdfasdfasdf: $value");
                                              return value
                                                  ? Container(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 24,
                                                          vertical: 18),
                                                      child:
                                                          ValueListenableBuilder<
                                                              PriceType>(
                                                        valueListenable:
                                                            _homeViewModel
                                                                .priceTypeNotifier,
                                                        builder: (context,
                                                            value, child) {
                                                          return Column(
                                                            children: [
                                                              /// 일반요금
                                                              Container(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .symmetric(
                                                                        vertical:
                                                                            4),
                                                                decoration:
                                                                    BoxDecoration(
                                                                  borderRadius:
                                                                      const BorderRadius
                                                                          .all(
                                                                          Radius.circular(
                                                                              12)),
                                                                  border: Border.all(
                                                                      color: value ==
                                                                              PriceType
                                                                                  .basic
                                                                          ? Theme.of(context)
                                                                              .colorScheme
                                                                              .secondary
                                                                          : Colors
                                                                              .transparent,
                                                                      width: 1),
                                                                  color: value ==
                                                                          PriceType
                                                                              .basic
                                                                      ? Theme.of(
                                                                              context)
                                                                          .toggleButtonsTheme
                                                                          .fillColor
                                                                      : Theme.of(
                                                                              context)
                                                                          .cardColor,
                                                                ),
                                                                child:
                                                                    RadioListTile(
                                                                  value:
                                                                      PriceType
                                                                          .basic,
                                                                  groupValue:
                                                                      _homeViewModel
                                                                          .priceType,
                                                                  onChanged:
                                                                      (value) {
                                                                    /// 일반요금 선택
                                                                    if (value
                                                                        is PriceType) {
                                                                      _homeViewModel
                                                                              .priceType =
                                                                          value;
                                                                    }
                                                                  },
                                                                  title: Column(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      Text(
                                                                        StringHome
                                                                            .basicPrice,
                                                                        style: value ==
                                                                                PriceType.basic
                                                                            ? Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.secondary)
                                                                            : Theme.of(context).textTheme.bodyMedium,
                                                                      ),
                                                                      // const SizedBox(height: 4),
                                                                      // Text(StringHome.basicPriceSub, style: Theme.of(context).textTheme.bodySmall),
                                                                    ],
                                                                  ),
                                                                  secondary:
                                                                      ValueListenableBuilder<
                                                                          int>(
                                                                    valueListenable:
                                                                        _homeViewModel
                                                                            .basicPriceNotifier,
                                                                    builder: (context,
                                                                        value,
                                                                        child) {
                                                                      return Text(
                                                                          getPrice(
                                                                              value),
                                                                          style: Theme.of(context)
                                                                              .textTheme
                                                                              .bodyMedium);
                                                                    },
                                                                  ),
                                                                  fillColor: MaterialStateProperty.all(value ==
                                                                          PriceType
                                                                              .basic
                                                                      ? Theme.of(
                                                                              context)
                                                                          .colorScheme
                                                                          .secondary
                                                                      : Theme.of(
                                                                              context)
                                                                          .disabledColor),
                                                                ),
                                                              ),
                                                              const SizedBox(
                                                                  height: 8),

                                                              /// 요금 직접 입력
                                                              GestureDetector(
                                                                onTap:
                                                                    () async {
                                                                  /// 요금 직접 입력 팝업 띄움
                                                                  final result =
                                                                      await showModalBottomSheet(
                                                                    context:
                                                                        context,
                                                                    isScrollControlled:
                                                                        true,
                                                                    builder:
                                                                        (context) {
                                                                      return Wrap(
                                                                        children: [
                                                                          Padding(
                                                                            padding:
                                                                                EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                                                                            child:
                                                                                CallPriceBottomSheet(
                                                                              initPrice: _homeViewModel.inputPrice,
                                                                              minPrice: 0,
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      );
                                                                    },
                                                                  );
                                                                  if (result !=
                                                                      null) {
                                                                    _homeViewModel
                                                                            .inputPrice =
                                                                        result;
                                                                    _homeViewModel
                                                                            .priceType =
                                                                        PriceType
                                                                            .input;
                                                                  }
                                                                },
                                                                child:
                                                                    Container(
                                                                  padding: const EdgeInsets
                                                                      .symmetric(
                                                                      vertical:
                                                                          4),
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    borderRadius:
                                                                        const BorderRadius
                                                                            .all(
                                                                            Radius.circular(12)),
                                                                    border: Border.all(
                                                                        color: value == PriceType.input
                                                                            ? Theme.of(context)
                                                                                .colorScheme
                                                                                .secondary
                                                                            : Colors
                                                                                .transparent,
                                                                        width:
                                                                            1),
                                                                    color: value ==
                                                                            PriceType
                                                                                .input
                                                                        ? Theme.of(context)
                                                                            .toggleButtonsTheme
                                                                            .fillColor
                                                                        : Theme.of(context)
                                                                            .cardColor,
                                                                  ),
                                                                  child:
                                                                      RadioListTile(
                                                                    value: PriceType
                                                                        .input,
                                                                    groupValue:
                                                                        _homeViewModel
                                                                            .priceType,
                                                                    onChanged:
                                                                        null,
                                                                    title:
                                                                        Column(
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      children: [
                                                                        Text(
                                                                          StringHome
                                                                              .inputPrice,
                                                                          style: value == PriceType.input
                                                                              ? Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.secondary)
                                                                              : Theme.of(context).textTheme.bodyMedium,
                                                                        ),
                                                                        // const SizedBox(height: 4),
                                                                        // Text(StringHome.inputPriceSub, style: Theme.of(context).textTheme.bodySmall),
                                                                      ],
                                                                    ),
                                                                    secondary:
                                                                        ValueListenableBuilder<
                                                                            int>(
                                                                      valueListenable:
                                                                          _homeViewModel
                                                                              .inputPriceNotifier,
                                                                      builder: (context,
                                                                          value,
                                                                          child) {
                                                                        return Text(
                                                                            getPrice(
                                                                                value),
                                                                            style:
                                                                                Theme.of(context).textTheme.bodyMedium);
                                                                      },
                                                                    ),
                                                                    fillColor: MaterialStateProperty.all(value ==
                                                                            PriceType
                                                                                .input
                                                                        ? Theme.of(context)
                                                                            .colorScheme
                                                                            .secondary
                                                                        : Theme.of(context)
                                                                            .disabledColor),
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          );
                                                        },
                                                      ),
                                                    )
                                                  : const SizedBox();
                                            },
                                          ),

                                          const Divider(thickness: 1),

                                          /// 결제수단
                                          ValueListenableBuilder<String>(
                                            valueListenable: _homeViewModel
                                                .paymentNmNotifier,
                                            builder: (context, value, child) {
                                              return Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 28),
                                                child: Column(
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Icon(
                                                          Icons.credit_card,
                                                          color:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .bodyMedium
                                                                  ?.color,
                                                          size: 24,
                                                        ),
                                                        const SizedBox(
                                                            width: 18),

                                                        Text(
                                                            value.isEmpty
                                                                ? StringHome
                                                                    .payment1
                                                                : StringHome
                                                                    .payment2,
                                                            style: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .bodyLarge),
                                                        const SizedBox(
                                                            width: 14),

                                                        /// 선택한 결제수단
                                                        Expanded(
                                                          child: Text(
                                                            value.isEmpty
                                                                ? StringHome
                                                                    .empty
                                                                : value,
                                                            style: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .bodyLarge
                                                                ?.copyWith(
                                                                  color: Theme.of(
                                                                          context)
                                                                      .disabledColor,
                                                                ),
                                                          ),
                                                        ),

                                                        /// 결제수단 선택 버튼
                                                        CustomRoundButton(
                                                          text: value.isEmpty
                                                              ? StringHome
                                                                  .selectButton
                                                              : StringHome
                                                                  .changeButton,
                                                          backgroundColor:
                                                              Theme.of(context)
                                                                  .colorScheme
                                                                  .primary,
                                                          textColor:
                                                              Colors.white,
                                                          borderColor:
                                                              Theme.of(context)
                                                                  .colorScheme
                                                                  .primary,
                                                          padding:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                                  vertical: 10,
                                                                  horizontal:
                                                                      16),
                                                          onPressed: () async {
                                                            /// 화면 이동 전 네이버지도 가림
                                                            naverMap = null;

                                                            /// 결제수단 화면으로 이동
                                                            final result =
                                                                await context
                                                                    .pushNamed(
                                                              PaymentManagementScreen
                                                                  .routeName,
                                                              extra:
                                                                  true, // 결제선택 여부
                                                            );
                                                            if (result
                                                                is Payment) {
                                                              /// 선택한 결제수단 데이터 받기
                                                              _homeViewModel
                                                                  .setPaymentInfo(
                                                                paymKind: result
                                                                            .cardId ==
                                                                        "CASH"
                                                                    ? "CASH"
                                                                    : "CARD",
                                                                paymentNm: result
                                                                    .paymentNm,
                                                                cardId: result
                                                                            .cardId ==
                                                                        "CASH"
                                                                    ? ""
                                                                    : result
                                                                        .cardId,
                                                              );
                                                            }

                                                            /// 화면 이동 완료 후 네이버 지도 보여줌
                                                            initData();
                                                          },
                                                        ),
                                                      ],
                                                    )
                                                  ],
                                                ),
                                              );
                                            },
                                          ),

                                          /// 예약하기 / 호출하기 버튼
                                          ValueListenableBuilder<bool>(
                                            valueListenable: _homeViewModel
                                                .isCallButtonValidNotifier,
                                            builder: (context, value, child) {
                                              return Container(
                                                color: Theme.of(context)
                                                    .scaffoldBackgroundColor,
                                                padding: const EdgeInsets.only(
                                                    top: 8,
                                                    bottom: 20,
                                                    left: 20,
                                                    right: 20),
                                                child: Row(
                                                  children: [
                                                    /// 예약하기 버튼
                                                    Expanded(
                                                      child: CustomRadiusButton(
                                                        isEnabled: value,
                                                        text: StringHome
                                                            .reservationButton,
                                                        onPressed: () async {
                                                          /// 예약콜 유의사항 조회
                                                          final notiPolicy =
                                                              await _homeViewModel
                                                                  .getPolicy(
                                                                      policyTp:
                                                                          PolicyTp
                                                                              .notc);
                                                          if (notiPolicy ==
                                                              null) {
                                                            return;
                                                          }

                                                          /// 예약 일시 팝업 띄움
                                                          final result =
                                                              await showModalBottomSheet(
                                                            context: context,
                                                            isScrollControlled:
                                                                true,
                                                            builder: (context) {
                                                              return const Wrap(
                                                                  children: [
                                                                    ReservationBottomSheet()
                                                                  ]);
                                                            },
                                                          );
                                                          debugPrint(
                                                              "======$result");
                                                          if (result == null) {
                                                            return;
                                                          }

                                                          final dateTitle =
                                                              result["title"];
                                                          final dateValue =
                                                              result["value"];

                                                          /// 예약 정보 확인 팝업 띄움
                                                          final resultConfirm =
                                                              await showModalBottomSheet(
                                                            context: context,
                                                            isScrollControlled:
                                                                true,
                                                            useSafeArea: true,
                                                            builder: (context) {
                                                              return ReservationConfirmBottomSheet(
                                                                dateTitle:
                                                                    dateTitle,
                                                                dateValue:
                                                                    dateValue,
                                                                price:
                                                                    _homeViewModel
                                                                        .price,
                                                                paymentNm:
                                                                    _homeViewModel
                                                                        .paymentNm,
                                                                start: _homeViewModel
                                                                    .startMapData!,
                                                                end: _homeViewModel
                                                                    .endMapData!,
                                                                stopOverList:
                                                                    _homeViewModel
                                                                        .stopOverList,
                                                                notiPolicy:
                                                                    notiPolicy,
                                                              );
                                                            },
                                                          );
                                                          debugPrint(
                                                              "======$resultConfirm");
                                                          if (resultConfirm ==
                                                              null) {
                                                            return;
                                                          }

                                                          /// 차량정보 리스트 조회
                                                          final carList =
                                                              await _homeViewModel
                                                                  .getCarList();

                                                          String carNumId = "";
                                                          if (carList
                                                              .isNotEmpty) {
                                                            /// 선택 안함 추가
                                                            carList.add(Car(
                                                                carNumId: ""));

                                                            /// 차량선택 팝업
                                                            final carResult =
                                                                await showModalBottomSheet(
                                                              context: context,
                                                              isScrollControlled:
                                                                  true,
                                                              builder:
                                                                  (context) {
                                                                return Wrap(
                                                                    children: [
                                                                      CarSelectBottomSheet(
                                                                          carList:
                                                                              carList)
                                                                    ]);
                                                              },
                                                            );
                                                            if (carResult !=
                                                                    null &&
                                                                carResult
                                                                    is Car) {
                                                              carNumId =
                                                                  carResult
                                                                      .carNumId;
                                                            } else {
                                                              return;
                                                            }
                                                          }

                                                          /// 예약하기
                                                          final requestResult =
                                                              await _homeViewModel
                                                                  .requestReservation(
                                                            carNumId: carNumId,
                                                            date: dateValue,
                                                          );
                                                          if (requestResult
                                                              is Success) {
                                                            /// 예약 접수 성공 팝업
                                                            await _showAlertDialog(
                                                                content:
                                                                    StringReservation
                                                                        .reservationConfirmAlert,
                                                                isCanceled:
                                                                    false);

                                                            /// 입력 데이터 삭제
                                                            _homeViewModel
                                                                .clearData();

                                                            /// 화면 이동, 데이터 갱신 후, 네이버 지도 갱신
                                                            naverMap = null;
                                                            initData();

                                                            /// 운행 정보 화면으로 이동
                                                            final drvReqSq =
                                                                requestResult
                                                                    .drvResponse
                                                                    .drvReqSq;
                                                            await context
                                                                .pushNamed(
                                                              CallDetailScreen
                                                                  .routeName,
                                                              extra: drvReqSq,
                                                            );
                                                          }
                                                        },
                                                      ),
                                                    ),
                                                    const SizedBox(width: 8),

                                                    /// 호출하기 버튼
                                                    Expanded(
                                                      child: ElevatedButton(
                                                        onPressed: value
                                                            ? () async {
                                                                /// 일반콜 유의사항 조회
                                                                final notiPolicy =
                                                                    await _homeViewModel.getPolicy(
                                                                        policyTp:
                                                                            PolicyTp.cano);
                                                                if (notiPolicy ==
                                                                    null) {
                                                                  return;
                                                                }

                                                                final content = _homeViewModel
                                                                        .endMapData!
                                                                        .place
                                                                        .isNotEmpty
                                                                    ? _homeViewModel
                                                                        .endMapData!
                                                                        .place
                                                                    : _homeViewModel
                                                                        .endMapData!
                                                                        .addressRoad;
                                                                await _showCallConfirmDialog(
                                                                  content:
                                                                      content,
                                                                  notiPolicy:
                                                                      notiPolicy,
                                                                  onConfirm:
                                                                      () async {
                                                                    Navigator.pop(
                                                                        context);

                                                                    /// 차량정보 리스트 조회
                                                                    final carList =
                                                                        await _homeViewModel
                                                                            .getCarList();

                                                                    String
                                                                        carNumId =
                                                                        "";
                                                                    if (carList
                                                                        .isNotEmpty) {
                                                                      /// 선택 안함 추가
                                                                      carList.add(Car(
                                                                          carNumId:
                                                                              ""));

                                                                      /// 차량선택 팝업
                                                                      final carResult =
                                                                          await showModalBottomSheet(
                                                                        context:
                                                                            context,
                                                                        isScrollControlled:
                                                                            true,
                                                                        builder:
                                                                            (context) {
                                                                          return Wrap(
                                                                              children: [
                                                                                CarSelectBottomSheet(carList: carList)
                                                                              ]);
                                                                        },
                                                                      );
                                                                      if (carResult !=
                                                                              null &&
                                                                          carResult
                                                                              is Car) {
                                                                        carNumId =
                                                                            carResult.carNumId;
                                                                      } else {
                                                                        return;
                                                                      }
                                                                    }

                                                                    /// 호출하기
                                                                    final requestResult =
                                                                        await _homeViewModel.requestCall(
                                                                            carNumId:
                                                                                carNumId);
                                                                    if (requestResult
                                                                        is Success) {
                                                                      /// 화면 이동 전 네이버지도 가림
                                                                      naverMap =
                                                                          null;

                                                                      /// 운행 화면으로 이동
                                                                      final drvReqSq = requestResult
                                                                          .drvResponse
                                                                          .drvReqSq;
                                                                      final callResult =
                                                                          await context
                                                                              .pushNamed(
                                                                        WorkScreen
                                                                            .routeName,
                                                                        extra:
                                                                            drvReqSq,
                                                                      );
                                                                      if (callResult ==
                                                                          false) {
                                                                        /// 운행취소
                                                                        /// 입력 데이터 삭제
                                                                        _homeViewModel
                                                                            .clearData();
                                                                      }

                                                                      /// 화면 이동 완료 후 네이버 지도 보여줌
                                                                      initData();
                                                                    }
                                                                  },
                                                                );
                                                              }
                                                            : null,
                                                        style: ElevatedButton
                                                            .styleFrom(
                                                          padding:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                                  vertical: 14,
                                                                  horizontal:
                                                                      24),
                                                        ),
                                                        child: Row(
                                                          children: [
                                                            /// 아이콘
                                                            Container(
                                                              width: 32,
                                                              height: 32,
                                                              decoration: const BoxDecoration(
                                                                  color: Colors
                                                                      .white10,
                                                                  shape: BoxShape
                                                                      .circle),
                                                              child:
                                                                  const Material(
                                                                color: Colors
                                                                    .transparent,
                                                                child: InkWell(
                                                                  child: Icon(
                                                                      Icons
                                                                          .call,
                                                                      color: Colors
                                                                          .white,
                                                                      size: 20),
                                                                ),
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                                width: 18),

                                                            /// 예약콜
                                                            const Expanded(
                                                              child: Text(
                                                                StringHome
                                                                    .callButton,
                                                                style:
                                                                    TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<NLatLng> getCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    debugPrint("location position: $position");
    return NLatLng(position.latitude, position.longitude);
  }

  _showAlertDialog(
      {String? title,
      String? content,
      bool isWarning = false,
      bool isCanceled = true}) {
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

  _showConfirmDialog(
      {String? title,
      String? content,
      bool isWarning = false,
      required Function() onConfirm}) {
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

  _showCallConfirmDialog(
      {String? title,
      required String content,
      required Policy notiPolicy,
      required Function() onConfirm}) {
    return showDialog(
      context: context,
      barrierDismissible: true, // dialog 영역 외 터치 여부
      builder: (BuildContext context) {
        return CallConfirmDialog(
          title: title,
          content: content,
          notiPolicy: notiPolicy,
          onConfirm: onConfirm,
        );
      },
    );
  }

  /// 네이버 지도
  NaverMap initNaverMap({required NLatLng nLatLng}) {
    return NaverMap(
      options: NaverMapViewOptions(
        // 실내 맵 사용 가능 여부
        indoorEnable: true,
        // 위치 버튼 표시 여부
        locationButtonEnable: true,
        // 심볼 탭 이벤트 소비 여부
        consumeSymbolTapEvents: true,
        // 줌아웃 조절 여부
        zoomGesturesEnable: true,
        // 방향 조절 여부
        rotationGesturesEnable: true,
        // 이동 조절 여부
        scrollGesturesEnable: true,
        // 네이버 로고 클릭 이벤트 여부
        logoClickEnable: false,
        // 네이버 로고 위치
        logoAlign: NLogoAlign.leftTop,
        // 네이버 로고 마진
        logoMargin: const EdgeInsets.all(8),
        // 하단 거리 표시 없애기
        scaleBarEnable: false,

        initialCameraPosition: NCameraPosition(
          target: nLatLng,
          zoom: 16, // 0.0 ~ 21.0
        ),
        mapType: NMapType.navi,
        nightModeEnable: CustomThemeMode.getThemeMode ==
            ThemeMode.dark, // mapType이 네비게이션일 경우에만 제공
      ),
      onMapReady: (controller) async {
        debugPrint("========== onMapReady ===========");

        final startMapData = _homeViewModel.startMapData;
        final endMapData = _homeViewModel.endMapData;
        final stopOverList = _homeViewModel.stopOverList;

        Set<NAddableOverlay> markers = Set.from({});

        NMarker? startMarker;
        if (startMapData != null) {
          /// 출발지 마커 추가
          startMarker = NMarker(
            id: "start",
            position: startMapData.latLng,
            icon: await NOverlayImage.fromWidget(
              widget: Icon(
                Icons.flag,
                size: 30,
                color: Theme.of(context).colorScheme.secondary,
              ),
              size: const Size(30, 30),
              context: context,
            ),
          );
          markers.add(startMarker);
        }

        NMarker? endMarker;
        if (endMapData != null) {
          /// 도착지 마커 추가 (출발지 마커와 동일한 스타일로 통일)
          endMarker = NMarker(
            id: "end",
            position: endMapData.latLng,
            icon: await NOverlayImage.fromWidget(
              widget: Icon(
                Icons.flag,
                size: 30,
                color: Theme.of(context).colorScheme.secondary,
              ),
              size: const Size(30, 30),
              context: context,
            ),
          );
          markers.add(endMarker);
        }

        if (stopOverList.isNotEmpty) {
          /// 경유지 마커 추가
          for (int i = 0; i < stopOverList.length; i++) {
            final stopOverMarker = NMarker(
              id: "stopover$i",
              position: NLatLng(stopOverList[i].lat, stopOverList[i].long),
              icon: await NOverlayImage.fromWidget(
                  widget: Icon(
                    Icons.circle,
                    size: 10,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                  size: const Size(10, 10),
                  context: context),
            );
            markers.add(stopOverMarker);
          }
        }
        await controller.addOverlayAll(markers);

        if (startMarker != null) {
          /// 출발지 마커 라벨 표시
          final startInfoWindow =
              NInfoWindow.onMarker(id: "start_info", text: "출발지");
          startInfoWindow.setOffsetY(-1);
          startMarker.openInfoWindow(startInfoWindow);
        }

        if (endMarker != null) {
          /// 도착지 마커 라벨 표시
          final endInfoWindow =
              NInfoWindow.onMarker(id: "end_info", text: "도착지");
          endInfoWindow.setOffsetY(-1);
          endMarker.openInfoWindow(endInfoWindow);
        }

        /// 내 위치 표시(파란 동그라미) 기본 활성화
        controller.setLocationTrackingMode(NLocationTrackingMode.noFollow);

        if (startMapData != null && endMapData != null) {
          /// 출발지와 도착지가 멀리 떨어져 있어도 두 마커가 모두 화면에 보이도록 범위 맞춤
          final points = [startMapData.latLng, endMapData.latLng];
          for (final stopOver in stopOverList) {
            points.add(NLatLng(stopOver.lat, stopOver.long));
          }
          /// 하단 호출 정보 바텀시트에 마커가 가려지지 않도록 아래쪽에 여유 패딩 확보
          final screenHeight = MediaQuery.of(context).size.height;
          controller.updateCamera(
            NCameraUpdate.fitBounds(
              NLatLngBounds.from(points),
              padding: EdgeInsets.only(
                top: 100,
                left: 60,
                right: 60,
                bottom: screenHeight * 0.55,
              ),
            ),
          );
        } else {
          var target = _homeViewModel.currentLatLng;
          if (startMapData != null) {
            target = startMapData.latLng;
          } else if (endMapData != null) {
            target = endMapData.latLng;
          }

          /// 카메라 위치 변경
          controller.updateCamera(
            NCameraUpdate.scrollAndZoomTo(
              target: target,
              zoom: 16, // 0.0 ~ 21.0
            ),
          );
        }
      },
      onCameraChange: (reason, animated) async {
        /// 카메라 위치 변경에 따른 위치값 변경
        // final cameraPosition = await _mapController.getCameraPosition();
        // final newLatLng = NLatLng(cameraPosition.target.latitude, cameraPosition.target.longitude);
        // currentMarker.setPosition(newLatLng);
        // _homeViewModel.startLatLng = newLatLng;
      },
    );
  }

  /// 앱 뒤로가기
  Future<bool> _onBackPressed() async {
    final now = DateTime.now();
    if (_lastOnPressed == null ||
        now.difference(_lastOnPressed!) > const Duration(seconds: 2)) {
      _lastOnPressed = now;
      Fluttertoast.showToast(msg: StringHome.onBackPressed);
      return false;
    }
    return true;
  }
}
