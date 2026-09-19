import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:kdmp_cm_app/common/fcm/notification.dart';
import 'package:kdmp_cm_app/data/constant/codes.dart';
import 'package:kdmp_cm_app/data/constant/constants.dart';
import 'package:kdmp_cm_app/data/model/common/map_data_model.dart';
import 'package:kdmp_cm_app/data/model/common/state.dart';
import 'package:kdmp_cm_app/data/model/common/stopover_model.dart';
import 'package:kdmp_cm_app/domain/usecase/fcm/set_fcm_push_usecase.dart';
import 'package:kdmp_cm_app/domain/usecase/naver/get_naver_address_info_usecase.dart';
import 'package:kdmp_cm_app/domain/usecase/naver/get_naver_driving_usecase.dart';
import 'package:kdmp_cm_app/domain/usecase/secure_storage/jwt/get_jwt_usecase.dart';
import 'package:kdmp_cm_app/domain/usecase/secure_storage/mbr/get_mbrsq_usecase.dart';
import 'package:kdmp_cm_app/domain/usecase/secure_storage/setup/setup_usecase.dart';
import 'package:kdmp_cm_app/domain/usecase/work/get_call_info_usecase.dart';
import 'package:kdmp_cm_app/domain/usecase/work/get_driving_price_usecase.dart';
import 'package:kdmp_cm_app/domain/usecase/work/set_call_cancel_usecase.dart';
import 'package:kdmp_cm_app/domain/usecase/work/set_call_fee_change_usecase.dart';
import 'package:kdmp_cm_app/domain/usecase/work/set_call_info_change_usecase.dart';
import 'package:kdmp_cm_app/domain/usecase/work/set_confirm_call_cancel_usecase.dart';
import 'package:kdmp_cm_app/domain/usecase/work/set_review_write_usecase.dart';
import 'package:kdmp_cm_app/presentation/util/string_util.dart';
import 'package:kdmp_cm_app/presentation/values/images.dart';
import 'package:kdmp_cm_app/presentation/theme/custom_theme_mode.dart';
import 'package:kdmp_cm_app/presentation/values/strings.dart';
import 'package:kdmp_cm_app/presentation/view/bottomsheet/call_price_bottom_sheet.dart';
import 'package:kdmp_cm_app/presentation/view/bottomsheet/review_bottom_sheet.dart';
import 'package:kdmp_cm_app/presentation/view/dialog/call_cancel_dialog.dart';
import 'package:kdmp_cm_app/presentation/view/dialog/custom_alert_dialog.dart';
import 'package:kdmp_cm_app/presentation/view/screen/address/end_search_screen.dart';
import 'package:kdmp_cm_app/presentation/view/screen/mypage/called_detail_screen.dart';
import 'package:kdmp_cm_app/presentation/view/widget/common/behavior/custom_scroll_behavior.dart';
import 'package:kdmp_cm_app/presentation/view/widget/common/button/custom_round_button.dart';
import 'package:kdmp_cm_app/presentation/view/widget/common/divider/vertical_dashed_divider.dart';
import 'package:kdmp_cm_app/presentation/view/widget/common/section/call_progress_indicator.dart';
import 'package:kdmp_cm_app/presentation/viewmodel/work/work_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

/// 운행 화면
class WorkScreen extends StatefulWidget {
  const WorkScreen({
    Key? key,
    required this.drvReqSq,
  }) : super(key: key);

  static const String routeName = "work";
  static const String routeURL = "/work";

  final int drvReqSq;

  @override
  State<WorkScreen> createState() => _WorkScreenState();
}

class _WorkScreenState extends State<WorkScreen> with WidgetsBindingObserver {
  late final WorkViewModel _workViewModel;

  String accessToken = "";

  /// 리뷰 흐름을 이미 태웠는지 (푸시와 복귀 감지가 겹쳐 두 번 뜨는 것을 막는다)
  bool _isReviewHandled = false;

  /// 이동 지도를 펼쳤는지.
  ///
  /// 접어 두는 것이 기본이다. 운행 화면에는 단계·요금·기사 연락처럼 더 자주 쓰는
  /// 것이 있어 지도가 그것을 밀어내면 손해다. 보고 싶은 사람만 펼친다.
  final ValueNotifier<bool> _isMapOpen = ValueNotifier<bool>(false);

  /// 내 현재 위치. 펼친 동안에만 갱신한다
  final ValueNotifier<NLatLng?> _myLatLng = ValueNotifier<NLatLng?>(null);

  /// 위치 구독. 펼칠 때 걸고 접거나 화면을 떠날 때 끊는다 —
  /// 주행 30~60분 내내 물고 있으면 배터리를 먹는다
  StreamSubscription<Position>? _positionSubscription;

  NaverMapController? _mapController;

  @override
  void initState() {
    super.initState();
    // 앱 상태 변경 이벤트 등록
    WidgetsBinding.instance.addObserver(this);
    initViewModel();
    initData();
  }

  @override
  void dispose() {
    _stopWatchingLocation();
    _mapController = null;
    _isMapOpen.dispose();
    _myLatLng.dispose();

    // 앱 상태 변경 이벤트 해제
    // 문제는 앱 종료시 dispose함수가 호출되지 않아 해당 함수를 실행 할 수가 없다.
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  /// 지도를 펼치거나 접는다. 펼친 동안에만 위치를 따라간다
  Future<void> _toggleMap() async {
    final willOpen = !_isMapOpen.value;
    _isMapOpen.value = willOpen;

    if (!willOpen) {
      _stopWatchingLocation();

      /// 지도 위젯이 트리에서 빠지면 네이티브 뷰도 사라진다. 컨트롤러를 들고 있으면
      /// 해제된 뷰로 명령이 나가 MissingPluginException 이 된다
      _mapController = null;
      return;
    }

    /// 펼치는 순간 한 번 읽어 지도가 빈 채로 뜨지 않게 한다
    try {
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      if (!mounted) return;
      _myLatLng.value = NLatLng(position.latitude, position.longitude);
    } catch (e) {
      debugPrint("현위치 조회 실패: $e");
    }

    _positionSubscription = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,

        /// 20m 넘게 움직였을 때만 갱신한다. 주행 중 초당 갱신은 배터리만 먹는다
        distanceFilter: 20,
      ),
    ).listen((position) {
      if (!mounted) return;
      final latLng = NLatLng(position.latitude, position.longitude);
      _myLatLng.value = latLng;
      _drawMovingMarkers(latLng);
    });
  }

  void _stopWatchingLocation() {
    _positionSubscription?.cancel();
    _positionSubscription = null;
  }

  /// 이동 지도 카드.
  ///
  /// 대리운전은 고객이 자기 차 뒷좌석에 앉아 있는 상황이라 "제대로 가고 있나" 를
  /// 묻기 어색하다. 지도는 그것을 말 없이 확인하게 해준다.
  ///
  /// 내 위치만 찍으면 기준이 없어 판단이 안 된다. 도착지를 함께 그려야
  /// "가까워지고 있다" 가 읽힌다.
  Widget getMapCard() {
    final theme = Theme.of(context);

    return ValueListenableBuilder<bool>(
      valueListenable: _isMapOpen,
      builder: (context, isOpen, _) {
        return Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: theme.cardColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: theme.dividerColor),
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            children: [
              InkWell(
                onTap: _toggleMap,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  child: Row(
                    children: [
                      Icon(Icons.map_outlined, size: 20, color: theme.colorScheme.primary),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          isOpen ? StringWork.mapClose : StringWork.mapOpen,
                          style: theme.textTheme.bodyMedium,
                        ),
                      ),
                      Icon(isOpen ? Icons.expand_less : Icons.expand_more, size: 22),
                    ],
                  ),
                ),
              ),
              if (isOpen)
                SizedBox(
                  height: 220,
                  child: ValueListenableBuilder<NLatLng?>(
                    valueListenable: _myLatLng,
                    builder: (context, myLatLng, _) {
                      if (myLatLng == null) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      return getMovingMap(myLatLng);
                    },
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  /// 내 위치와 도착지를 함께 그린다.
  ///
  /// 지도 위젯을 다시 만들지 않고 컨트롤러로 카메라만 옮긴다 — 위치가 갱신될 때마다
  /// 새로 만들면 네이티브 뷰가 매번 다시 뜬다.
  Widget getMovingMap(NLatLng myLatLng) {
    return NaverMap(
      options: NaverMapViewOptions(
        initialCameraPosition: NCameraPosition(target: myLatLng, zoom: 15),
        mapType: NMapType.navi,
        nightModeEnable: CustomThemeMode.getThemeMode == ThemeMode.dark,
        logoClickEnable: false,
        scaleBarEnable: false,

        /// 카드 안의 작은 지도다. 몸짓은 막고 보여주기만 한다 —
        /// 스크롤 중에 지도가 잡아채면 본문을 내릴 수가 없다
        scrollGesturesEnable: false,
        zoomGesturesEnable: false,
        rotationGesturesEnable: false,
      ),
      onMapReady: (controller) async {
        _mapController = controller;
        await _drawMovingMarkers(myLatLng);
      },
    );
  }

  /// 내 위치·도착지 마커를 올리고 둘이 함께 보이게 맞춘다
  Future<void> _drawMovingMarkers(NLatLng myLatLng) async {
    final controller = _mapController;

    /// 접혔거나 화면을 떠났으면 그릴 지도가 없다. 이 확인을 빼면 해제된 네이티브
    /// 뷰로 명령이 나가 MissingPluginException 으로 떨어진다
    if (controller == null || !mounted || !_isMapOpen.value) return;

    final endLatLng = _workViewModel.endMapData?.latLng;

    /// 지도는 보조 수단이다. 그리다 실패해도 운행 화면이 흔들려서는 안 된다
    try {
      await controller.clearOverlays();
      await controller.addOverlay(NMarker(id: "me", position: myLatLng));

      if (endLatLng == null) {
        await controller.updateCamera(NCameraUpdate.withParams(target: myLatLng, zoom: 15));
        return;
      }

      await controller.addOverlay(NMarker(id: "end", position: endLatLng));
      await controller.updateCamera(
        NCameraUpdate.fitBounds(
          NLatLngBounds.from([myLatLng, endLatLng]),
          padding: const EdgeInsets.all(40),
        ),
      );
    } catch (e) {
      debugPrint("이동 지도 그리기 실패: $e");
    }
  }

  // 앱 상태 변경시 호출
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // https://api.flutter.dev/flutter/dart-ui/AppLifecycleState-class.html
    switch (state) {
      case AppLifecycleState.resumed:
        // 앱이 표시되고 사용자 입력에 응답합니다.
        // 주의! 최초 앱 실행때는 해당 이벤트가 발생하지 않습니다.
        debugPrint("resumed");

        /// 호출정보 조회 후, 자리를 비운 사이 운행이 끝났는지 확인
        _workViewModel.getCallInfo(drvReqSq: widget.drvReqSq).then((_) => _checkWorkEnded());
        break;
      case AppLifecycleState.inactive:
        // 앱이 비활성화 상태이고 사용자의 입력을 받지 않습니다.
        // ios에서는 포 그라운드 비활성 상태에서 실행되는 앱 또는 Flutter 호스트 뷰에 해당합니다.
        // 안드로이드에서는 화면 분할 앱, 전화 통화, PIP 앱, 시스템 대화 상자 또는 다른 창과 같은 다른 활동이 집중되면 앱이이 상태로 전환됩니다.
        // inactive가 발생되고 얼마후 pasued가 발생합니다.
        debugPrint("inactive");
        break;
      case AppLifecycleState.paused:
        // 앱이 현재 사용자에게 보이지 않고, 사용자의 입력을 받지 않으며, 백그라운드에서 동작 중입니다.
        // 안드로이드의 onPause()와 동일합니다.
        // 응용 프로그램이 이 상태에 있으면 엔진은 Window.onBeginFrame 및 Window.onDrawFrame 콜백을 호출하지 않습니다.
        debugPrint("paused");
        break;
      case AppLifecycleState.detached:
        // 응용 프로그램은 여전히 flutter 엔진에서 호스팅되지만 "호스트 View"에서 분리됩니다.
        // 앱이 이 상태에 있으면 엔진이 "View"없이 실행됩니다.
        // 엔진이 처음 초기화 될 때 "View" 연결 진행 중이거나 네비게이터 팝으로 인해 "View"가 파괴 된 후 일 수 있습니다.
        debugPrint("detached");
        break;
      case AppLifecycleState.hidden:
        break;
    }
  }

  /// Create
  void initViewModel() async {
    _workViewModel = WorkViewModel(
      getMbrSqUseCase: GetIt.instance<GetMbrSqUseCase>(),
      getCallInfoUseCase: GetIt.instance<GetCallInfoUseCase>(),
      setCallCancelUseCase: GetIt.instance<SetCallCancelUseCase>(),
      setConfirmCallCancelUseCase: GetIt.instance<SetConfirmCallCancelUseCase>(),
      setCallFeeChangeUseCase: GetIt.instance<SetCallFeeChangeUseCase>(),
      setCallInfoChangeUseCase: GetIt.instance<SetCallInfoChangeUseCase>(),
      setReviewWriteUseCase: GetIt.instance<SetReviewWriteUseCase>(),
      setFCMPushUseCase: GetIt.instance<SetFCMPushUseCase>(),
      getDrivingPriceUseCase: GetIt.instance<GetDrivingPriceUseCase>(),
      getNaverDrivingUseCase: GetIt.instance<GetNaverDrivingUseCase>(),
      getNaverAddressInfoUseCase: GetIt.instance<GetNaverAddressInfoUseCase>(),
    );

    /// 키 관리 파일 가져오기
    await dotenv.load(fileName: ".env");
    _workViewModel.clientId = dotenv.get(AppConstants.NAVER_CLIENT_ID);
    _workViewModel.clientSecret = dotenv.get(AppConstants.NAVER_CLIENT_SECRET);
  }

  void initData() async {
    /// 저장된 인증 토큰 가져오기
    accessToken = await GetIt.instance<GetJwtUseCase>().execute();

    /// 푸시를 놓쳐도 복귀할 수 있도록 진행 중인 운행 번호를 남긴다
    await GetIt.instance<SetupUseCase>().setPendingReviewDrvReqSq(drvReqSq: widget.drvReqSq);

    /// 호출정보 조회
    await _workViewModel.getCallInfo(drvReqSq: widget.drvReqSq, isSearchMapData: true);

    /// 화면에 들어온 시점에 이미 운행이 끝나 있으면 (푸시를 놓친 경우) 리뷰 흐름을 태운다
    _checkWorkEnded();
  }

  /// 조회된 상태가 운행종료면 리뷰 작성으로 보낸다. 푸시 수신 여부와 무관하게 동작한다.
  void _checkWorkEnded() {
    if (_isReviewHandled) return;

    final drvReqSt = _workViewModel.drvReqSt;

    /// 취소된 콜은 마무리할 것이 없으므로 기록만 지운다
    if (drvReqSt == DrvReqSt.del || drvReqSt == DrvReqSt.rdl) {
      _isReviewHandled = true;
      GetIt.instance<SetupUseCase>().deletePendingReviewDrvReqSq();
      return;
    }

    if (drvReqSt != DrvReqSt.end && drvReqSt != DrvReqSt.ren) return;

    _isReviewHandled = true;
    _showReviewBottomSheet(drvReqSt);
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<WorkViewModel>(
          create: (context) => _workViewModel,
        ),
      ],
      child: Scaffold(
        /// 화면
        body: WillPopScope(
          onWillPop: _onBackPressed,
          child: SafeArea(
            child: Stack(
              children: [
                Column(
                  children: [
                    Expanded(
                      child: ScrollConfiguration(
                        behavior: CustomScrollBehavior(),
                        child: SingleChildScrollView(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    /// 호출취소 버튼
                                    ValueListenableBuilder<bool>(
                                      valueListenable: _workViewModel.isCancelVisibleNotifier,
                                      builder: (context, value, child) {
                                        return value
                                            ? CustomRoundButton(
                                                text: StringWork.cancel,
                                                backgroundColor: Theme.of(context).toggleButtonsTheme.fillColor,
                                                textColor: Theme.of(context).colorScheme.secondary,
                                                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                                                onPressed: _handleCancelPress,
                                              )
                                            : const SizedBox();
                                      },
                                    ),

                                    /// 전화 버튼
                                    ValueListenableBuilder<String>(
                                      valueListenable: _workViewModel.callNumberNotifier,
                                      builder: (context, value, child) {
                                        return value.isNotEmpty ? getCallButton(value) : const SizedBox();
                                      },
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 32),

                                /// 콜 진행 단계
                                ValueListenableBuilder<String>(
                                  valueListenable: _workViewModel.drvReqStNotifier,
                                  builder: (context, value, child) {
                                    return CallProgressIndicator(drvReqSt: value);
                                  },
                                ),
                                const SizedBox(height: 16),

                                /// 이동 지도. 운행이 시작된 뒤에만 보여준다 —
                                /// 아직 출발하지 않았으면 그릴 이동이 없다
                                ValueListenableBuilder<String>(
                                  valueListenable: _workViewModel.drvReqStNotifier,
                                  builder: (context, value, child) {
                                    final isRunning = value == DrvReqSt.sta || value == DrvReqSt.rst;
                                    return isRunning ? getMapCard() : const SizedBox();
                                  },
                                ),
                                const SizedBox(height: 32),

                                ValueListenableBuilder<String>(
                                  valueListenable: _workViewModel.drvReqStNotifier,
                                  builder: (context, value, child) {
                                    return value == DrvReqSt.cal
                                        ? Column(
                                            children: [
                                              Image.asset(ImageWork.imgWork, width: 90, height: 90),
                                              const SizedBox(height: 24),
                                              Text(StringWork.calling, style: Theme.of(context).textTheme.displaySmall),
                                            ],
                                          )
                                        : Column(
                                            children: [
                                              /// 프로필 사진
                                              Container(
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(66),
                                                  border: Border.all(color: Theme.of(context).colorScheme.primary, width: 3),
                                                ),
                                                child: ClipRRect(
                                                  borderRadius: BorderRadius.circular(60),
                                                  child: ValueListenableBuilder<String>(
                                                    valueListenable: _workViewModel.imagePathNotifier,
                                                    builder: (context, value, _) {
                                                      return Image.network(
                                                        "${AppConstants.IMAGE_URL}$value",
                                                        headers: Map.from({"SCLAuthorization": "Bearer $accessToken"}),
                                                        fit: BoxFit.cover,
                                                        width: 88,
                                                        height: 88,
                                                        errorBuilder: (context, error, stackTrace) {
                                                          return Container(
                                                            width: 88,
                                                            height: 88,
                                                            color: Theme.of(context).scaffoldBackgroundColor,
                                                          );
                                                        },
                                                      );
                                                    },
                                                  ),
                                                ),
                                              ),

                                              const SizedBox(height: 24),

                                              /// 기사명
                                              ValueListenableBuilder(
                                                valueListenable: _workViewModel.nameNotifier,
                                                builder: (context, value, _) {
                                                  return Text("$value ${StringCommon.driver}", style: Theme.of(context).textTheme.displaySmall);
                                                },
                                              ),
                                            ],
                                          );
                                  },
                                ),

                                const SizedBox(height: 60),
                                const Divider(thickness: 1, height: 72),

                                /// 출발지
                                Row(
                                  children: [
                                    Icon(
                                      Icons.location_on,
                                      size: 22,
                                      color: Theme.of(context).colorScheme.secondary,
                                    ),
                                    const SizedBox(width: 10),
                                    SizedBox(
                                      width: 70,
                                      child: Text(
                                        StringWork.start,
                                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                              color: Theme.of(context).colorScheme.secondary,
                                            ),
                                        textAlign: TextAlign.left,
                                      ),
                                    ),
                                    ValueListenableBuilder<String>(
                                      valueListenable: _workViewModel.startNotifier,
                                      builder: (context, value, child) {
                                        return Expanded(child: Text(value, style: Theme.of(context).textTheme.titleMedium));
                                      },
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),

                                /// 경유지
                                ValueListenableBuilder<List<StopOver>>(
                                  valueListenable: _workViewModel.stopOverListNotifier,
                                  builder: (context, value, child) {
                                    String text = value.isNotEmpty
                                        ? value[0].placeName.isNotEmpty
                                            ? value[0].placeName
                                            : value[0].address
                                        : "";
                                    if (value.length > 1) {
                                      text += " 외 ${value.length - 1}";
                                    }
                                    return Row(
                                      children: [
                                        SizedBox(
                                          height: 60,
                                          child: VerticalDashedDivider(
                                            thickness: 1,
                                            color: Theme.of(context).colorScheme.secondary,
                                            space: 22,
                                            length: 2,
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        SizedBox(
                                          width: 70,
                                          child: Text(
                                            value.isNotEmpty ? StringWork.stopOver : "",
                                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                                  color: Theme.of(context).colorScheme.secondary,
                                                ),
                                            textAlign: TextAlign.left,
                                          ),
                                        ),
                                        Expanded(child: Text(text, style: Theme.of(context).textTheme.titleMedium)),
                                      ],
                                    );
                                  },
                                ),

                                /// 도착지
                                Row(
                                  children: [
                                    Icon(
                                      Icons.flag,
                                      size: 22,
                                      color: Theme.of(context).colorScheme.secondary,
                                    ),
                                    const SizedBox(width: 10),
                                    SizedBox(
                                      width: 70,
                                      child: Text(
                                        StringWork.end,
                                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                              color: Theme.of(context).colorScheme.secondary,
                                            ),
                                        textAlign: TextAlign.left,
                                      ),
                                    ),
                                    ValueListenableBuilder<String>(
                                      valueListenable: _workViewModel.endNotifier,
                                      builder: (context, value, child) {
                                        return Expanded(child: Text(value, style: Theme.of(context).textTheme.titleMedium));
                                      },
                                    ),

                                    /// 도착지 변경 버튼
                                    ValueListenableBuilder<bool>(
                                      valueListenable: _workViewModel.isCallInfoChangeVisibleNotifier,
                                      builder: (context, buttonValue, child) {
                                        return buttonValue
                                            ? CustomRoundButton(
                                                text: StringHome.changeButton,
                                                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                                                textColor: Theme.of(context).colorScheme.secondary,
                                                borderColor: Theme.of(context).colorScheme.secondary,
                                                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                                                onPressed: () async {
                                                  /// 도착지 설정 검색 화면으로 이동
                                                  final result = await context.pushNamed(EndSearchScreen.routeName);
                                                  if (result != null && result is MapData) {
                                                    final changeResult = await _workViewModel.changeCallInfo(
                                                      drvReqSq: widget.drvReqSq,
                                                      changeEndMapData: result,
                                                    );
                                                    if (changeResult is Success) {
                                                      _showAlertDialog(
                                                        title: StringWork.changeCallEndTitle,
                                                        content: StringWork.changeCallEndAlert,
                                                        isCanceled: false,
                                                      );
                                                    } else {
                                                      Fluttertoast.showToast(msg: "도착지를 변경할 수 없습니다.");
                                                    }
                                                  } else {
                                                    Fluttertoast.showToast(msg: "도착지 변경을 취소했습니다.");
                                                  }
                                                },
                                              )
                                            : const SizedBox(height: 40);
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    const Divider(thickness: 6, height: 72),

                    /// 결제
                    Padding(
                      padding: const EdgeInsets.only(left: 20, right: 20, bottom: 24),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              SizedBox(
                                width: 60,
                                child: Text(
                                  StringWork.payment,
                                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                        color: Theme.of(context).colorScheme.secondary,
                                      ),
                                  textAlign: TextAlign.left,
                                ),
                              ),
                              ValueListenableBuilder<String>(
                                valueListenable: _workViewModel.paymKindNotifier,
                                builder: (context, value, child) {
                                  return Expanded(child: Text(getPaymentKind(value), style: Theme.of(context).textTheme.bodyLarge));
                                },
                              ),
                            ],
                          ),

                          /// 요금
                          ValueListenableBuilder<int>(
                            valueListenable: _workViewModel.priceNotifier,
                            builder: (context, value, child) {
                              return Row(
                                children: [
                                  SizedBox(
                                    width: 60,
                                    child: Text(
                                      StringWork.price,
                                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                            color: Theme.of(context).colorScheme.secondary,
                                          ),
                                      textAlign: TextAlign.left,
                                    ),
                                  ),

                                  Expanded(child: Text(getPrice(value), style: Theme.of(context).textTheme.bodyLarge)),

                                  /// 요금 변경 버튼
                                  ValueListenableBuilder<bool>(
                                    valueListenable: _workViewModel.isPriceInputVisibleNotifier,
                                    builder: (context, buttonValue, child) {
                                      return buttonValue
                                          ? CustomRoundButton(
                                              text: StringHome.changeButton,
                                              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                                              textColor: Theme.of(context).colorScheme.secondary,
                                              borderColor: Theme.of(context).colorScheme.secondary,
                                              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                                              onPressed: () async {
                                                /// 요금 직접 입력 팝업 띄움
                                                final result = await showModalBottomSheet(
                                                  context: context,
                                                  isScrollControlled: true,
                                                  builder: (context) {
                                                    return Wrap(
                                                      children: [
                                                        Padding(
                                                          padding: EdgeInsets.only(
                                                            bottom: MediaQuery.of(context).viewInsets.bottom + MediaQuery.of(context).padding.bottom,
                                                          ),
                                                          child: CallPriceBottomSheet(
                                                            initPrice: value,
                                                            minPrice: value + 1000,
                                                          ),
                                                        ),
                                                      ],
                                                    );
                                                  },
                                                );
                                                if (result != null) {
                                                  final changeCallFeeResult = await _workViewModel.changeCallFee(
                                                    drvReqSq: widget.drvReqSq,
                                                    newPrice: result,
                                                  );
                                                  if (changeCallFeeResult is Success) {
                                                    _showAlertDialog(content: StringWork.changeCallFeeAlert, isCanceled: false);
                                                  }
                                                }
                                              },
                                            )
                                          : const SizedBox(height: 40);
                                    },
                                  ),
                                ],
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    StreamBuilder<Map<String, dynamic>>(
                      stream: FlutterLocalNotification.streamController.stream,
                      builder: (context, snapshot) {
                        if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                          _showPushDialog(snapshot);
                        }
                        return const SizedBox();
                      },
                    ),
                  ],
                ),
                ValueListenableBuilder<StateAPI>(
                  valueListenable: _workViewModel.stateNotifier,
                  builder: (context, value, child) {
                    return value is Loading
                        ? Center(
                            child: CircularProgressIndicator(
                              color: Theme.of(context).colorScheme.secondary,
                              backgroundColor: Theme.of(context).cardColor,
                            ),
                          )
                        : const SizedBox();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _showPushDialog(AsyncSnapshot<Map<String, dynamic>> snapshot) {
    debugPrint("========${snapshot.data}");

    WidgetsBinding.instance.addPostFrameCallback((_) {
      /// 다른 팝업이 열려있으면 닫기
      if (ModalRoute.of(context)?.isCurrent != true) {
        context.pop();
      }
      final type = snapshot.data?["type"] ?? "";
      final title = snapshot.data?["title"] ?? "";
      final body = snapshot.data?["body"] ?? "";
      switch (type) {
        case DrvReqSt.cco:

        /// 예약 확정도 같은 처리다. 전에는 빠져 있어 default 로 떨어졌는데,
        /// 결과가 같았을 뿐 의도한 분기가 아니었다
        case DrvReqSt.rco:
          _workViewModel.getCallInfo(drvReqSq: widget.drvReqSq);
          _showAlertDialog(content: body, isCanceled: false);
          break;
        case DrvReqSt.rwt:
        case DrvReqSt.wat:
        case DrvReqSt.sta:
          _workViewModel.drvReqSt = type;
          _showAlertDialog(content: body, isCanceled: false);
          break;
        case DrvReqSt.end:
        case DrvReqSt.ren:
          if (!_isReviewHandled) {
            _isReviewHandled = true;
            _showReviewBottomSheet(type);
          }
          break;
        case DrvReqSt.del:
        case DrvReqSt.rdl:
          context.pop();
          _showAlertDialog(content: body, isCanceled: false);
          break;
        default:
          _workViewModel.getCallInfo(drvReqSq: widget.drvReqSq);
          _showAlertDialog(content: body, isCanceled: false);
      }

      /// 받은 데이터 지우기
      snapshot.data!.clear();
    });
  }

  /// 리뷰 작성 팝업
  Future<void> _showReviewBottomSheet(String drvReqSt) async {
    /// 상태 변경
    // TODO: API 재조회할지 변경된 값만 Push Data 값으로 받을지
    // _workViewModel.getCallInfo(drvReqSq: widget.drvReqSq);
    _workViewModel.drvReqSt = drvReqSt;

    await showModalBottomSheet(
      context: context,
      isDismissible: false, // bottomSheet 영역 외 터치 여부
      isScrollControlled: true,
      builder: (context) {
        return Wrap(
          children: [
            Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom + MediaQuery.of(context).padding.bottom,
              ),
              child: ReviewBottomSheet(
                onPressed: (star, review) async {
                  debugPrint("$star, $review");

                  /// 리뷰 작성
                  final result = await _workViewModel.writeReview(drvReqSq: widget.drvReqSq, reviewContent: review, starPoint: star);
                  if (result is Success) {
                    /// 리뷰 작성 팝업 닫기
                    context.pop();
                  }
                },
              ),
            ),
          ],
        );
      },
    );

    /// 리뷰 흐름을 마쳤으므로 복귀용 기록을 지운다
    await GetIt.instance<SetupUseCase>().deletePendingReviewDrvReqSq();

    /// 정산 내용 확인 (이용내역 상세)
    if (mounted) {
      await context.pushNamed(CalledDetailScreen.routeName, extra: widget.drvReqSq);
    }

    /// 화면 닫기, 홈 화면 초기화
    if (mounted) {
      context.pop(false);
    }
  }

  /// 앱 뒤로가기
  /// 앱 뒤로가기.
  ///
  /// 진행 중이어도 막지 않는다. 전에는 막아뒀는데, 홈이 진행 중인 콜을 찾으면
  /// 곧바로 이 화면을 다시 열어서 그러지 않으면 갇혔기 때문이다. 홈을 배너로
  /// 바꿔 고객이 직접 들어오게 했으므로 붙들어 둘 이유가 없어졌다.
  Future<bool> _onBackPressed() async {
    return true;
  }

  /// 전화 버튼
  Widget getCallButton(String callNumber) {
    return CustomRoundButton(
      text: StringWork.call,
      icon: Icons.call,
      backgroundColor: Theme.of(context).toggleButtonsTheme.fillColor,
      textColor: Theme.of(context).colorScheme.secondary,
      onPressed: () async {
        /// 전화걸기 다이얼 화면 띄움
        if (callNumber.trim().isNotEmpty) {
          makePhoneCall(callNumber);
        }
      },
    );
  }

  /// 전화걸기
  void makePhoneCall(String url) async {
    var telUrl = 'tel:$url';
    if (Platform.isIOS) {
      telUrl = telUrl.replaceAll((RegExp(r'-')), '');
    }
    if (await canLaunchUrl(Uri.parse(telUrl))) {
      await launchUrl(Uri.parse(telUrl));
    }
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
            context.pop();
          },
        );
      },
    );
  }

  _showCallCancelDialog({required Function(String, String) onConfirm}) {
    return showDialog(
      context: context,
      barrierDismissible: true, // dialog 영역 외 터치 여부
      builder: (BuildContext context) {
        return CallCancelDialog(
          onConfirm: onConfirm,
        );
      },
    );
  }

  /// 호출취소 버튼 클릭
  Future<void> _handleCancelPress() async {
    /// 호출취소 사유 선택 팝업
    final cancelResult = await _showCallCancelDialog(
      onConfirm: (drvCancelTp, cancelReason) async {
        /// 미확정 콜은 cancelCall, 확정 콜은 cancelConfirmCall
        final result = _workViewModel.drvReqSt == DrvReqSt.cal
            ? await _workViewModel.cancelCall(
                drvReqSq: widget.drvReqSq,
                drvCancelTp: drvCancelTp,
                cancelReason: cancelReason,
              )
            : await _workViewModel.cancelConfirmCall(
                drvReqSq: widget.drvReqSq,
                drvCancelTp: drvCancelTp,
                cancelReason: cancelReason,
              );
        if (result is Success) {
          /// 호출취소 사유 선택 팝업 닫기
          context.pop(true);
        }
      },
    );

    if (cancelResult == true) {
      /// 호출 취소 완료 팝업 띄움
      await _showAlertDialog(content: StringWork.cancelSuccess, isCanceled: false);

      /// 화면 닫기, 홈 화면 초기화
      context.pop(false);
    }
  }
}
