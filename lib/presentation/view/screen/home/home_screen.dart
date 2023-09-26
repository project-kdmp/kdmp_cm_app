import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:kdmp_cm_app/data/model/common/state.dart';
import 'package:kdmp_cm_app/data/model/common/stopover_model.dart';
import 'package:kdmp_cm_app/domain/usecase/secure_storage/mbr/get_mbrsq_usecase.dart';
import 'package:kdmp_cm_app/presentation/theme/custom_theme_mode.dart';
import 'package:kdmp_cm_app/presentation/util/string_util.dart';
import 'package:kdmp_cm_app/presentation/values/strings.dart';
import 'package:kdmp_cm_app/presentation/view/bottomsheet/call_price_bottom_sheet.dart';
import 'package:kdmp_cm_app/presentation/view/dialog/custom_alert_dialog.dart';
import 'package:kdmp_cm_app/presentation/view/dialog/custon_confirm_dialog.dart';
import 'package:kdmp_cm_app/presentation/view/screen/address/start_search_screen.dart';
import 'package:kdmp_cm_app/presentation/view/screen/menu/menu_screen.dart';
import 'package:kdmp_cm_app/presentation/view/widget/common/button/custom_radius_button.dart';
import 'package:kdmp_cm_app/presentation/view/widget/common/button/custom_round_button.dart';
import 'package:kdmp_cm_app/presentation/view/widget/common/button/custom_text_button.dart';
import 'package:kdmp_cm_app/presentation/view/widget/common/divider/vertical_dashed_divider.dart';
import 'package:kdmp_cm_app/presentation/viewmodel/home/home_viewmodel.dart';
import 'package:provider/provider.dart';

/// 홈 화면
class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  static const String routeName = "home";
  static const String routeURL = "/home";

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final HomeViewModel _homeViewModel;

  late final NaverMapController _mapController;
  final Completer<NaverMapController> mapControllerCompleter = Completer();
  late final NMarker currentMarker;

  /// 네이버 지도
  final ValueNotifier<NaverMap?> _naverMap = ValueNotifier<NaverMap?>(null);

  ValueNotifier<NaverMap?> get naverMapNotifier => _naverMap;

  NaverMap? get naverMap => _naverMap.value;

  set naverMap(NaverMap? value) => _naverMap.value = value;

  @override
  void initState() {
    super.initState();
    initViewModel();
    initData();
  }

  /// Create
  void initViewModel() {
    _homeViewModel = HomeViewModel(
      getMbrSqUseCase: GetIt.instance<GetMbrSqUseCase>(),
    );
  }

  void initData() async {
    /// 현위치 좌표 가져오기
    _homeViewModel.startLatLng = await getCurrentLocation();

    /// 네이버 지도 초기화
    naverMap = initNaverMap(nLatLng: _homeViewModel.startLatLng);
  }

  @override
  Widget build(BuildContext context) {
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
            IconButton(
              onPressed: () {
                context.pushNamed(MenuScreen.routeName);
              },
              padding: const EdgeInsets.only(right: 10),
              icon: const Icon(Icons.menu),
            ),
          ],
        ),

        /// 화면
        body: SafeArea(
          child: Column(
            children: [
              /// 지도
              ValueListenableBuilder<NaverMap?>(
                valueListenable: naverMapNotifier,
                builder: (context, value, child) {
                  return Expanded(child: value ?? Container(color: Theme.of(context).dividerColor));
                },
              ),

              Stack(
                children: [
                  /// 상단 둥근 테두리
                  Transform.translate(
                    offset: const Offset(0, -20),
                    child: Container(
                      height: 20,
                      decoration: BoxDecoration(
                        color: Theme.of(context).scaffoldBackgroundColor,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Theme.of(context).disabledColor.withOpacity(0.5),
                            spreadRadius: 0,
                            blurRadius: 20,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                    ),
                  ),

                  /// 호출 정보 입력지
                  Container(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 28),
                          child: Column(
                            children: [
                              /// 출발지
                              ValueListenableBuilder<String>(
                                valueListenable: _homeViewModel.startPlaceNotifier,
                                builder: (context, value, child) {
                                  return Row(
                                    children: [
                                      Icon(
                                        Icons.location_on,
                                        color: value.isNotEmpty ? Theme.of(context).colorScheme.secondary : Theme.of(context).disabledColor,
                                        size: 24,
                                      ),

                                      /// 출발지 검색 버튼
                                      Expanded(
                                        child: CustomTextButton(
                                          hint: StringHome.startPlaceHint,
                                          text: value,
                                          backgroundColor: Colors.transparent,
                                          onPressed: () async {
                                            final result = await context.pushNamed(StartSearchScreen.routeName);
                                          },
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              ),

                              /// 구분선
                              ValueListenableBuilder<List<StopOver>>(
                                valueListenable: _homeViewModel.stopoverListNotifier,
                                builder: (context, value, child) {
                                  String text = "";
                                  if (value.length > 1) {
                                    text = "${value[0].placeName} 외 ${value.length - 1}";
                                  } else if (value.length == 1) {
                                    text = value[0].placeName;
                                  }
                                  return value.isNotEmpty
                                      ? Row(
                                          children: [
                                            SizedBox(
                                              height: 44,
                                              child: VerticalDashedDivider(
                                                thickness: 2,
                                                color: Theme.of(context).disabledColor,
                                                space: 24,
                                                length: 3,
                                              ),
                                            ),

                                            /// 경유지 설정 버튼
                                            Expanded(
                                              child: CustomTextButton(
                                                text: text,
                                                backgroundColor: Colors.transparent,
                                                onPressed: () {
                                                  // TODO: 경유지 설정 화면으로 이동
                                                  _homeViewModel.stopoverList = List.empty();
                                                },
                                              ),
                                            ),
                                          ],
                                        )
                                      : Row(
                                          children: [
                                            SizedBox(
                                              height: 16,
                                              child: VerticalDashedDivider(
                                                thickness: 2,
                                                color: Theme.of(context).disabledColor,
                                                space: 24,
                                                length: 2,
                                              ),
                                            ),
                                            const SizedBox(width: 18),
                                            const Expanded(child: Divider(thickness: 1)),
                                          ],
                                        );
                                },
                              ),

                              /// 도착지
                              ValueListenableBuilder<String>(
                                valueListenable: _homeViewModel.endPlaceNotifier,
                                builder: (context, value, child) {
                                  return Row(
                                    children: [
                                      Icon(
                                        Icons.flag_sharp,
                                        color: value.isNotEmpty ? Theme.of(context).colorScheme.secondary : Theme.of(context).disabledColor,
                                        size: 24,
                                      ),

                                      /// 도착지 검색 버튼
                                      Expanded(
                                        child: CustomTextButton(
                                          hint: StringHome.endPlaceHint,
                                          text: value,
                                          backgroundColor: Colors.transparent,
                                          onPressed: () {
                                            // TODO: 도착지 설정 화면으로 이동
                                            _homeViewModel.endPlace = "도착지";
                                          },
                                        ),
                                      ),

                                      /// 도착지 검색 내 경유지 설정 버튼
                                      ValueListenableBuilder<bool>(
                                        valueListenable: _homeViewModel.isStopoverButtonValidNotifier,
                                        builder: (context, value, child) {
                                          return value
                                              ? CustomRoundButton(
                                                  text: StringHome.stopoverButton,
                                                  backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                                                  textColor: Theme.of(context).colorScheme.secondary,
                                                  borderColor: Theme.of(context).cardColor,
                                                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                                                  onPressed: () {
                                                    // TODO: 경유지 설정 화면으로 이동
                                                    _homeViewModel.addStopoverList(
                                                      StopOver(
                                                        address: "주소",
                                                        placeName: "경유지장소명",
                                                        stopDistance: 10,
                                                        lat: 0.0,
                                                        long: 0.0,
                                                      ),
                                                    );
                                                  },
                                                )
                                              : const SizedBox();
                                        },
                                      ),
                                    ],
                                  );
                                },
                              ),
                            ],
                          ),
                        ),

                        /// 요금 선택
                        ValueListenableBuilder<bool>(
                          valueListenable: _homeViewModel.isPriceButtonValidNotifier,
                          builder: (context, value, child) {
                            return value
                                ? Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
                                    child: ValueListenableBuilder<PriceType>(
                                      valueListenable: _homeViewModel.priceTypeNotifier,
                                      builder: (context, value, child) {
                                        return Column(
                                          children: [
                                            /// 일반요금
                                            Container(
                                              padding: const EdgeInsets.symmetric(vertical: 4),
                                              decoration: BoxDecoration(
                                                borderRadius: const BorderRadius.all(Radius.circular(12)),
                                                border: Border.all(color: value == PriceType.basic ? Theme.of(context).colorScheme.secondary : Colors.transparent, width: 1),
                                                color: value == PriceType.basic ? Theme.of(context).toggleButtonsTheme.fillColor : Theme.of(context).dividerColor,
                                              ),
                                              child: RadioListTile(
                                                value: PriceType.basic,
                                                groupValue: _homeViewModel.priceType,
                                                onChanged: (value) {
                                                  /// 일반요금 선택
                                                  if (value is PriceType) {
                                                    _homeViewModel.priceType = value;
                                                  }
                                                },
                                                title: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      StringHome.basicPrice,
                                                      style: value == PriceType.basic ? Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.secondary) : Theme.of(context).textTheme.bodyMedium,
                                                    ),
                                                    const SizedBox(height: 4),
                                                    Text(StringHome.basicPriceSub, style: Theme.of(context).textTheme.bodySmall),
                                                  ],
                                                ),
                                                secondary: ValueListenableBuilder<int>(
                                                  valueListenable: _homeViewModel.basicPriceNotifier,
                                                  builder: (context, value, child) {
                                                    return Text(getPrice(value));
                                                  },
                                                ),
                                                fillColor: MaterialStateProperty.all(value == PriceType.basic ? Theme.of(context).colorScheme.secondary : Theme.of(context).disabledColor),
                                              ),
                                            ),
                                            const SizedBox(height: 8),

                                            /// 요금 직접 입력
                                            GestureDetector(
                                              onTap: () async {
                                                /// 요금 직접 입력 팝업 띄움
                                                final result = await showModalBottomSheet(
                                                  context: context,
                                                  isScrollControlled: true,
                                                  builder: (context) {
                                                    return Wrap(
                                                      children: [
                                                        Padding(
                                                          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                                                          child: CallPriceBottomSheet(minPrice: _homeViewModel.basicPrice),
                                                        ),
                                                      ],
                                                    );
                                                  },
                                                );
                                                if (result != null) {
                                                  _homeViewModel.inputPrice = result;
                                                  _homeViewModel.priceType = PriceType.input;
                                                }
                                              },
                                              child: Container(
                                                padding: const EdgeInsets.symmetric(vertical: 4),
                                                decoration: BoxDecoration(
                                                  borderRadius: const BorderRadius.all(Radius.circular(12)),
                                                  border: Border.all(color: value == PriceType.input ? Theme.of(context).colorScheme.secondary : Colors.transparent, width: 1),
                                                  color: value == PriceType.input ? Theme.of(context).toggleButtonsTheme.fillColor : Theme.of(context).dividerColor,
                                                ),
                                                child: RadioListTile(
                                                  value: PriceType.input,
                                                  groupValue: _homeViewModel.priceType,
                                                  onChanged: null,
                                                  title: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                        StringHome.inputPrice,
                                                        style: value == PriceType.input ? Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.secondary) : Theme.of(context).textTheme.bodyMedium,
                                                      ),
                                                      const SizedBox(height: 4),
                                                      Text(StringHome.inputPriceSub, style: Theme.of(context).textTheme.bodySmall),
                                                    ],
                                                  ),
                                                  secondary: ValueListenableBuilder<int>(
                                                    valueListenable: _homeViewModel.inputPriceNotifier,
                                                    builder: (context, value, child) {
                                                      return Text(getPrice(value), style: Theme.of(context).textTheme.bodyMedium);
                                                    },
                                                  ),
                                                  fillColor: MaterialStateProperty.all(value == PriceType.input ? Theme.of(context).colorScheme.secondary : Theme.of(context).disabledColor),
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
                          valueListenable: _homeViewModel.paymKindNotifier,
                          builder: (context, value, child) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 28),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.credit_card,
                                        color: Theme.of(context).textTheme.bodyMedium?.color,
                                        size: 24,
                                      ),
                                      const SizedBox(width: 18),

                                      Text(value.isEmpty ? StringHome.payment1 : StringHome.payment2, style: Theme.of(context).textTheme.bodyLarge),
                                      const SizedBox(width: 14),

                                      /// 선택한 결제수단
                                      Expanded(
                                        child: Text(
                                          value.isEmpty ? StringHome.empty : value,
                                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                                color: Theme.of(context).disabledColor,
                                              ),
                                        ),
                                      ),

                                      /// 결제수단 선택
                                      CustomRoundButton(
                                        text: value.isEmpty ? StringHome.selectButton : StringHome.changeButton,
                                        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                                        textColor: Theme.of(context).colorScheme.secondary,
                                        borderColor: Theme.of(context).cardColor,
                                        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                                        onPressed: () {
                                          // TODO: 결제수단 선택 화면으로 이동
                                          _homeViewModel.paymKind = "asdf";
                                        },
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              ValueListenableBuilder<bool>(
                  valueListenable: _homeViewModel.isCallButtonValidNotifier,
                  builder: (context, value, child) {
                    return Container(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      padding: const EdgeInsets.only(top: 8, bottom: 20, left: 20, right: 20),
                      child: Row(
                        children: [
                          /// 예약하기 버튼
                          Expanded(
                            child: CustomRadiusButton(
                              isEnabled: value,
                              text: StringHome.reservationButton,
                              onPressed: () async {
                                // TODO: 예약하기
                                final result = await _homeViewModel.requestReservation();
                                if (result is Success) {
                                  // TODO: 콜 예약 성공시 처리
                                } else if (result is Bad) {
                                  Fluttertoast.showToast(msg: StringCommon.httpBad);
                                } else if (result is Fail) {
                                  Fluttertoast.showToast(msg: "${result.errorMessage}");
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
                                      // TODO: 호출하기
                                      final result = await _homeViewModel.requestCall();
                                      if (result is Success) {
                                        // TODO: 콜 호출 성공시 처리
                                      } else if (result is Bad) {
                                        Fluttertoast.showToast(msg: StringCommon.httpBad);
                                      } else if (result is Fail) {
                                        Fluttertoast.showToast(msg: "${result.errorMessage}");
                                      }
                                    }
                                  : null,
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
                              ),
                              child: Row(
                                children: [
                                  /// 아이콘
                                  Container(
                                    width: 32,
                                    height: 32,
                                    decoration: const BoxDecoration(color: Colors.white10, shape: BoxShape.circle),
                                    child: const Material(
                                      color: Colors.transparent,
                                      child: InkWell(
                                        child: Icon(Icons.call, color: Colors.white, size: 20),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 18),

                                  /// 예약콜
                                  const Text(
                                    StringHome.callButton,
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
            ],
          ),
        ),
      ),
    );
  }

  Future<NLatLng> getCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    debugPrint("location position: $position");
    return NLatLng(position.latitude, position.longitude);
  }

  showAlertDialog() {
    return showDialog(
      context: context,
      barrierDismissible: false, // dialog 영역 외 터치 여부
      builder: (BuildContext context) {
        return CustomAlertDialog(
          onConfirm: () {
            Navigator.pop(context);
          },
        );
      },
    );
  }

  showConfirmDialog() {
    return showDialog(
      context: context,
      barrierDismissible: true, // dialog 영역 외 터치 여부
      builder: (BuildContext context) {
        return CustomConfirmDialog(
          onConfirm: () {
            Navigator.pop(context);
          },
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
        nightModeEnable: CustomThemeMode.getThemeMode == ThemeMode.dark, // mapType이 네비게이션일 경우에만 제공
      ),
      onMapReady: (controller) async {
        // 지도 준비 완료 시 호출되는 콜백 함수
        _mapController = controller;
        mapControllerCompleter.complete(controller); // completer에 지도 컨트롤러 완료 신호 전송
        debugPrint("onMapReady");

        /// 출발지 초기값 지정
        // currentMarker = NMarker(id: "current", position: nLatLng, alpha: 0, size: const Size(1, 1));
        // _mapController.addOverlayAll({currentMarker});
        // final infoWindow = NInfoWindow.onMarker(id: currentMarker.info.id, text: "출발지");
        // infoWindow.setOffsetX(-1);
        // infoWindow.setOffsetY(-1);
        // currentMarker.openInfoWindow(infoWindow);
      },
      onCameraChange: (reason, animated) async {
        /// 카메라 위치 변경에 따른 위치값 변경
        final cameraPosition = await _mapController.getCameraPosition();
        final newLatLng = NLatLng(cameraPosition.target.latitude, cameraPosition.target.longitude);
        currentMarker.setPosition(newLatLng);
        _homeViewModel.startLatLng = newLatLng;
      },
    );
  }
}
