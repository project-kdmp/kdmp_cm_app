import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:kdmp_cm_app/data/constant/constants.dart';
import 'package:kdmp_cm_app/data/model/common/map_data_model.dart';
import 'package:kdmp_cm_app/domain/usecase/naver/get_naver_address_usecase.dart';
import 'package:kdmp_cm_app/domain/usecase/secure_storage/mbr/get_mbrsq_usecase.dart';
import 'package:kdmp_cm_app/presentation/theme/custom_theme_mode.dart';
import 'package:kdmp_cm_app/presentation/values/strings.dart';
import 'package:kdmp_cm_app/presentation/view/dialog/custom_alert_dialog.dart';
import 'package:kdmp_cm_app/presentation/view/dialog/custom_confirm_dialog.dart';
import 'package:kdmp_cm_app/presentation/view/widget/common/button/custom_elevated_button.dart';
import 'package:kdmp_cm_app/presentation/view/widget/common/section/base_appbar.dart';
import 'package:kdmp_cm_app/presentation/view/widget/common/text/custom_tag.dart';
import 'package:kdmp_cm_app/presentation/viewmodel/address/end_map_viewmodel.dart';
import 'package:kdmp_cm_app/presentation/viewmodel/address/naver_map_viewmodel.dart';
import 'package:provider/provider.dart';

/// 도착지 설정 지도 화면
class EndMapScreen extends StatefulWidget {
  const EndMapScreen({Key? key}) : super(key: key);

  static const String routeName = "end_map";

  @override
  State<EndMapScreen> createState() => _EndMapScreenState();
}

class _EndMapScreenState extends State<EndMapScreen> {
  late final EndMapViewModel _endMapViewModel;
  late final NaverMapViewModel _naverMapViewModel;

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
  void initViewModel() async {
    _endMapViewModel = EndMapViewModel(
      getMbrSqUseCase: GetIt.instance<GetMbrSqUseCase>(),
    );

    /// 키 관리 파일 가져오기
    await dotenv.load(fileName: ".env");
    _naverMapViewModel = NaverMapViewModel(
      clientId: dotenv.get(AppConstants.NAVER_CLIENT_ID),
      clientSecret: dotenv.get(AppConstants.NAVER_CLIENT_SECRET),
      getNaverAddressUseCase: GetIt.instance<GetNaverAddressUseCase>(),
    );
  }

  void initData() async {
    /// 현위치 좌표 가져오기
    final nLatLng = await getCurrentLocation();

    /// 좌표로 장소 조회
    final mapData = await _naverMapViewModel.getAddress(nLatLng: nLatLng);
    _endMapViewModel.mapData = mapData;

    /// 네이버 지도 초기화
    naverMap = initNaverMap(nLatLng: nLatLng);
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<EndMapViewModel>(
          create: (context) => _endMapViewModel,
        ),
        Provider<NaverMapViewModel>(
          create: (context) => _naverMapViewModel,
        ),
      ],
      child: Scaffold(
        /// 상단 앱바
        appBar: BaseAppBar(
          appBar: AppBar(),
          title: StringEndSetup.title,
        ),

        /// 화면
        body: SafeArea(
          child: Column(
            children: [
              /// 지도
              ValueListenableBuilder<NaverMap?>(
                valueListenable: naverMapNotifier,
                builder: (context, value, child) {
                  return Expanded(child: value ?? Container(color: Theme.of(context).cardColor));
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
                  ValueListenableBuilder<MapData>(
                    valueListenable: _endMapViewModel.mapDataNotifier,
                    builder: (context, value, child) {
                      return Container(
                        color: Theme.of(context).scaffoldBackgroundColor,
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        child: Column(
                          children: [
                            /// 장소명
                            value.place.isNotEmpty
                                ? Container(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      value.place,
                                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                            color: Theme.of(context).colorScheme.primary,
                                          ),
                                    ),
                                  )
                                : const SizedBox(),
                            value.place.isNotEmpty ? const SizedBox(height: 10) : const SizedBox(),

                            /// 주소
                            Container(
                              alignment: Alignment.centerLeft,
                              child: value.addressRoad.isNotEmpty
                                  ? Column(
                                      children: [
                                        Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            const CustomTag(text: "도로명"),
                                            const SizedBox(width: 6),
                                            Expanded(child: Text(value.addressRoad, style: Theme.of(context).textTheme.bodyMedium)),
                                          ],
                                        ),
                                        const SizedBox(height: 10),
                                        Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            const CustomTag(text: "지번"),
                                            const SizedBox(width: 6),
                                            Expanded(child: Text(value.addressJibun, style: Theme.of(context).textTheme.bodyMedium)),
                                          ],
                                        ),
                                      ],
                                    )
                                  : Text(
                                      "화면을 이동하여 장소를 지정해주세요.",
                                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                            color: Theme.of(context).disabledColor,
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

              /// 도착지 설정 버튼
              ValueListenableBuilder<bool>(
                valueListenable: _endMapViewModel.isValidNotifier,
                builder: (context, value, child) {
                  return Container(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    padding: const EdgeInsets.all(20),
                    child: CustomElevatedButton(
                      isEnabled: value,
                      text: StringEndSetup.bottomButton,
                      enabledBackgroundColor: Theme.of(context).colorScheme.secondary,
                      onPressed: () {
                        /// 조회한 데이터 전달
                        final mapData = _endMapViewModel.mapData;
                        context.pop(mapData);
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

        /// 도착지 초기값 지정
        currentMarker = NMarker(id: "current", position: nLatLng, alpha: 0, size: const Size(1, 1));
        _mapController.addOverlayAll({currentMarker});
        final infoWindow = NInfoWindow.onMarker(id: currentMarker.info.id, text: "도착지");
        infoWindow.setOffsetX(-1);
        infoWindow.setOffsetY(-1);
        currentMarker.openInfoWindow(infoWindow);
      },
      onCameraChange: (reason, animated) async {
        // debugPrint("onCameraChange");

        /// 카메라 위치 변경에 따른 마커 변경 (실시간)
        final cameraPosition = await _mapController.getCameraPosition();
        final newLatLng = NLatLng(cameraPosition.target.latitude, cameraPosition.target.longitude);
        currentMarker.setPosition(newLatLng);
      },
      onCameraIdle: () async {
        debugPrint("onCameraIdle");

        /// 카메라 위치 변경에 따른 위치값 변경 (스크롤이 멈춘 후)
        final cameraPosition = await _mapController.getCameraPosition();
        final newLatLng = NLatLng(cameraPosition.target.latitude, cameraPosition.target.longitude);

        /// 좌표로 장소 조회
        final mapData = await _naverMapViewModel.getAddress(nLatLng: newLatLng);
        _endMapViewModel.mapData = mapData;
      },
    );
  }
}
