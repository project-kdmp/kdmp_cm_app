import 'dart:async';

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
import 'package:kdmp_cm_app/data/model/common/stopover_model.dart';
import 'package:kdmp_cm_app/data/model/mypage/car_list_response.dart';
import 'package:kdmp_cm_app/data/model/payment/payment_model.dart';
import 'package:kdmp_cm_app/domain/usecase/mypage/get_car_list_usecase.dart';
import 'package:kdmp_cm_app/domain/usecase/naver/get_naver_price_usecase.dart';
import 'package:kdmp_cm_app/domain/usecase/secure_storage/mbr/get_mbrsq_usecase.dart';
import 'package:kdmp_cm_app/domain/usecase/secure_storage/mbr/get_payment_list_usecase.dart';
import 'package:kdmp_cm_app/domain/usecase/work/get_driving_usecase.dart';
import 'package:kdmp_cm_app/domain/usecase/work/set_call_request_usecase.dart';
import 'package:kdmp_cm_app/domain/usecase/work/set_reservation_request_usecase.dart';
import 'package:kdmp_cm_app/presentation/theme/custom_theme_mode.dart';
import 'package:kdmp_cm_app/presentation/util/string_util.dart';
import 'package:kdmp_cm_app/presentation/values/images.dart';
import 'package:kdmp_cm_app/presentation/values/strings.dart';
import 'package:kdmp_cm_app/presentation/view/bottomsheet/call_price_bottom_sheet.dart';
import 'package:kdmp_cm_app/presentation/view/bottomsheet/car_select_bottom_sheet.dart';
import 'package:kdmp_cm_app/presentation/view/bottomsheet/reservation_bottom_sheet.dart';
import 'package:kdmp_cm_app/presentation/view/bottomsheet/reservation_confirm_bottom_sheet.dart';
import 'package:kdmp_cm_app/presentation/view/dialog/call_confirm_dialog.dart';
import 'package:kdmp_cm_app/presentation/view/dialog/custom_alert_dialog.dart';
import 'package:kdmp_cm_app/presentation/view/dialog/custom_confirm_dialog.dart';
import 'package:kdmp_cm_app/presentation/view/screen/address/end_search_screen.dart';
import 'package:kdmp_cm_app/presentation/view/screen/address/start_search_screen.dart';
import 'package:kdmp_cm_app/presentation/view/screen/address/stopover_screen.dart';
import 'package:kdmp_cm_app/presentation/view/screen/menu/menu_screen.dart';
import 'package:kdmp_cm_app/presentation/view/screen/mypage/call_detail_screen.dart';
import 'package:kdmp_cm_app/presentation/view/screen/payment/payment_management_screen.dart';
import 'package:kdmp_cm_app/presentation/view/screen/work/work_screen.dart';
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
  DateTime? _lastOnPressed;

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
    initDataFirst();
    initData();
  }

  /// Create
  void initViewModel() async {
    _homeViewModel = HomeViewModel(
      getMbrSqUseCase: GetIt.instance<GetMbrSqUseCase>(),
      getCarListUseCase: GetIt.instance<GetCarListUseCase>(),
      getNaverPriceUseCase: GetIt.instance<GetNaverPriceUseCase>(),
      setCallRequestUseCase: GetIt.instance<SetCallRequestUseCase>(),
      setReservationRequestUseCase: GetIt.instance<SetReservationRequestUseCase>(),
      getDrivingUseCase: GetIt.instance<GetDrivingUseCase>(),
      getPaymentListUseCase: GetIt.instance<GetPaymentListUseCase>(),
    );

    /// 키 관리 파일 가져오기
    await dotenv.load(fileName: ".env");
    _homeViewModel.clientId = dotenv.get(AppConstants.NAVER_CLIENT_ID);
    _homeViewModel.clientSecret = dotenv.get(AppConstants.NAVER_CLIENT_SECRET);
  }

  void initDataFirst() async {
    /// 결제수단 조회
    await _homeViewModel.getPayment();
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
    /// 네이버 지도 초기화
    naverMap = initNaverMap(nLatLng: _homeViewModel.currentLatLng);
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
            child: Column(
              children: [
                /// 네이버 지도
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

                    /// 호출 정보 입력
                    Container(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 28),
                            child: Column(
                              children: [
                                /// 출발지
                                ValueListenableBuilder<MapData?>(
                                  valueListenable: _homeViewModel.startMapDataNotifier,
                                  builder: (context, value, child) {
                                    return Row(
                                      children: [
                                        Icon(
                                          Icons.location_on,
                                          color: value != null ? Theme.of(context).colorScheme.secondary : Theme.of(context).disabledColor,
                                          size: 24,
                                        ),

                                        /// 출발지 검색 버튼
                                        Expanded(
                                          child: CustomTextButton(
                                            hint: StringHome.startPlaceHint,
                                            text: value != null
                                                ? value.place.isNotEmpty
                                                    ? value.place
                                                    : value.address
                                                : "",
                                            backgroundColor: Colors.transparent,
                                            onPressed: () async {
                                              /// 화면 이동 전 네이버지도 가림
                                              naverMap = null;

                                              /// 출발지 설정 검색 화면으로 이동
                                              final result = await context.pushNamed(StartSearchScreen.routeName);
                                              if (result != null && result is MapData) {
                                                _homeViewModel.startMapData = result;
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
                                  valueListenable: _homeViewModel.stopOverListNotifier,
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
                                                  onPressed: () async {
                                                    /// 화면 이동 전 네이버지도 가림
                                                    naverMap = null;

                                                    /// 경유지 설정 화면으로 이동
                                                    final result = await context.pushNamed(
                                                      StopOverScreen.routeName,
                                                      extra: _homeViewModel.stopOverList,
                                                    );

                                                    if (result != null && result is List<StopOver>) {
                                                      _homeViewModel.stopOverList = result;
                                                    }

                                                    /// 화면 이동, 데이터 갱신 후, 네이버 지도 갱신
                                                    initData();
                                                  },
                                                ),
                                              ),

                                              /// 경유지 삭제 버튼
                                              GestureDetector(
                                                child: Icon(Icons.close, size: 16, color: Theme.of(context).disabledColor),
                                                onTap: () {
                                                  /// 경유지 삭제
                                                  _homeViewModel.clearStopOverList();

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
                                ValueListenableBuilder<MapData?>(
                                  valueListenable: _homeViewModel.endMapDataNotifier,
                                  builder: (context, value, child) {
                                    return Row(
                                      children: [
                                        Icon(
                                          Icons.flag_sharp,
                                          color: value != null ? Theme.of(context).colorScheme.secondary : Theme.of(context).disabledColor,
                                          size: 24,
                                        ),

                                        /// 도착지 검색 버튼
                                        Expanded(
                                          child: CustomTextButton(
                                            hint: StringHome.endPlaceHint,
                                            text: value != null
                                                ? value.place.isNotEmpty
                                                    ? value.place
                                                    : value.address
                                                : "",
                                            backgroundColor: Colors.transparent,
                                            onPressed: () async {
                                              /// 화면 이동 전 네이버지도 가림
                                              naverMap = null;

                                              /// 도착지 설정 검색 화면으로 이동
                                              final result = await context.pushNamed(EndSearchScreen.routeName);
                                              if (result != null && result is MapData) {
                                                _homeViewModel.endMapData = result;
                                              }

                                              /// 화면 이동, 데이터 갱신 후, 네이버 지도 갱신
                                              initData();
                                            },
                                          ),
                                        ),

                                        /// 도착지 검색 내 경유지 설정 버튼
                                        ValueListenableBuilder<bool>(
                                          valueListenable: _homeViewModel.isStopOverButtonValidNotifier,
                                          builder: (context, value, child) {
                                            return value
                                                ? CustomRoundButton(
                                                    text: StringHome.stopOverButton,
                                                    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                                                    textColor: Theme.of(context).colorScheme.secondary,
                                                    borderColor: Theme.of(context).cardColor,
                                                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                                                    onPressed: () async {
                                                      /// 화면 이동 전 네이버지도 가림
                                                      naverMap = null;

                                                      /// 경유지 설정 화면으로 이동
                                                      final result = await context.pushNamed(
                                                        StopOverScreen.routeName,
                                                        extra: _homeViewModel.stopOverList,
                                                      );

                                                      if (result != null && result is List<StopOver>) {
                                                        _homeViewModel.stopOverList = result;
                                                      }

                                                      /// 화면 이동, 데이터 갱신 후, 네이버 지도 갱신
                                                      initData();
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
                              debugPrint("asdfasdfasdfasdf: $value");
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
                                                            child: CallPriceBottomSheet(initPrice: _homeViewModel.basicPrice, minPrice: _homeViewModel.basicPrice),
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
                            valueListenable: _homeViewModel.paymentNmNotifier,
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

                                        /// 결제수단 선택 버튼
                                        CustomRoundButton(
                                          text: value.isEmpty ? StringHome.selectButton : StringHome.changeButton,
                                          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                                          textColor: Theme.of(context).colorScheme.secondary,
                                          borderColor: Theme.of(context).cardColor,
                                          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                                          onPressed: () async {
                                            /// 화면 이동 전 네이버지도 가림
                                            naverMap = null;

                                            /// 결제수단 화면으로 이동
                                            final result = await context.pushNamed(
                                              PaymentManagementScreen.routeName,
                                              extra: true, // 결제선택 여부
                                            );
                                            if (result is Payment) {
                                              /// 선택한 결제수단 데이터 받기
                                              _homeViewModel.cardId = result.cardId == "CASH" ? "" : result.cardId;
                                              _homeViewModel.paymentNm = result.paymentNm;
                                              _homeViewModel.paymKind = result.cardId == "CASH" ? "CASH" : "CARD";
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
                                /// 예약 일시 팝업 띄움
                                final result = await showModalBottomSheet(
                                  context: context,
                                  isScrollControlled: true,
                                  builder: (context) {
                                    return const Wrap(children: [ReservationBottomSheet()]);
                                  },
                                );
                                debugPrint("======$result");
                                if (result == null) {
                                  return;
                                }

                                final dateTitle = result["title"];
                                final dateValue = result["value"];

                                /// 예약 정보 확인 팝업 띄움
                                final resultConfirm = await showModalBottomSheet(
                                  context: context,
                                  isScrollControlled: true,
                                  useSafeArea: true,
                                  builder: (context) {
                                    return ReservationConfirmBottomSheet(
                                      dateTitle: dateTitle,
                                      dateValue: dateValue,
                                      price: _homeViewModel.price,
                                      paymentNm: _homeViewModel.paymentNm,
                                      start: _homeViewModel.startMapData!,
                                      end: _homeViewModel.endMapData!,
                                      stopOverList: _homeViewModel.stopOverList,
                                    );
                                  },
                                );
                                debugPrint("======$resultConfirm");
                                if (resultConfirm == null) {
                                  return;
                                }

                                /// 차량정보 리스트 조회
                                final carList = await _homeViewModel.getCarList();

                                String carNumId = "";
                                if (carList.isNotEmpty) {
                                  /// 선택 안함 추가
                                  carList.add(Car(carNumId: ""));

                                  /// 차량선택 팝업
                                  final carResult = await showModalBottomSheet(
                                    context: context,
                                    isScrollControlled: true,
                                    builder: (context) {
                                      return Wrap(children: [CarSelectBottomSheet(carList: carList)]);
                                    },
                                  );
                                  if (carResult != null && carResult is Car) {
                                    carNumId = carResult.carNumId;
                                  } else {
                                    return;
                                  }
                                }

                                /// 예약하기
                                final requestResult = await _homeViewModel.requestReservation(
                                  carNumId: carNumId,
                                  date: dateValue,
                                );
                                if (requestResult is Success) {
                                  /// 예약 접수 성공 팝업
                                  await _showAlertDialog(content: StringReservation.reservationConfirmAlert, isCanceled: false);

                                  /// 입력 데이터 삭제
                                  _homeViewModel.clearData();

                                  /// 화면 이동, 데이터 갱신 후, 네이버 지도 갱신
                                  naverMap = null;
                                  initData();

                                  /// 운행 정보 화면으로 이동
                                  final drvReqSq = requestResult.drvResponse.drvReqSq;
                                  await context.pushNamed(
                                    CallDetailScreen.routeName,
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
                                      final content = _homeViewModel.endMapData!.place.isNotEmpty ? _homeViewModel.endMapData!.place : _homeViewModel.endMapData!.address;
                                      await _showCallConfirmDialog(
                                        content: content,
                                        onConfirm: () async {
                                          Navigator.pop(context);

                                          /// 차량정보 리스트 조회
                                          final carList = await _homeViewModel.getCarList();

                                          String carNumId = "";
                                          if (carList.isNotEmpty) {
                                            /// 선택 안함 추가
                                            carList.add(Car(carNumId: ""));

                                            /// 차량선택 팝업
                                            final carResult = await showModalBottomSheet(
                                              context: context,
                                              isScrollControlled: true,
                                              builder: (context) {
                                                return Wrap(children: [CarSelectBottomSheet(carList: carList)]);
                                              },
                                            );
                                            if (carResult != null && carResult is Car) {
                                              carNumId = carResult.carNumId;
                                            } else {
                                              return;
                                            }
                                          }

                                          /// 호출하기
                                          final requestResult = await _homeViewModel.requestCall(carNumId: carNumId);
                                          if (requestResult is Success) {
                                            /// 화면 이동 전 네이버지도 가림
                                            naverMap = null;

                                            /// 운행 화면으로 이동
                                            final drvReqSq = requestResult.drvResponse.drvReqSq;
                                            final callResult = await context.pushNamed(
                                              WorkScreen.routeName,
                                              extra: drvReqSq,
                                            );
                                            if (callResult == false) {
                                              /// 운행취소
                                              /// 입력 데이터 삭제
                                              _homeViewModel.clearData();
                                            }

                                            /// 화면 이동 완료 후 네이버 지도 보여줌
                                            initData();
                                          }
                                        },
                                      );
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
                                  const Expanded(
                                    child: Text(
                                      StringHome.callButton,
                                      style: TextStyle(
                                        color: Colors.white,
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
    );
  }

  Future<NLatLng> getCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    debugPrint("location position: $position");
    return NLatLng(position.latitude, position.longitude);
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
            Navigator.pop(context);
          },
        );
      },
    );
  }

  _showConfirmDialog({String? title, String? content, bool isWarning = false, required Function() onConfirm}) {
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

  _showCallConfirmDialog({String? title, required String content, required Function() onConfirm}) {
    return showDialog(
      context: context,
      barrierDismissible: true, // dialog 영역 외 터치 여부
      builder: (BuildContext context) {
        return CallConfirmDialog(
          title: title,
          content: content,
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
          zoom: 12, // 0.0 ~ 21.0
        ),
        mapType: NMapType.navi,
        nightModeEnable: CustomThemeMode.getThemeMode == ThemeMode.dark, // mapType이 네비게이션일 경우에만 제공
      ),
      onMapReady: (controller) async {
        debugPrint("========== onMapReady ===========");

        final startMapData = _homeViewModel.startMapData;
        final endMapData = _homeViewModel.endMapData;
        final stopOverList = _homeViewModel.stopOverList;

        Set<NAddableOverlay> markers = Set.from({});

        if (startMapData != null) {
          /// 출발지 마커 추가
          markers.add(NMarker(
            id: "start",
            position: startMapData.latLng,
            icon: const NOverlayImage.fromAssetImage(ImageCommon.icStart),
          ));
        }

        if (endMapData != null) {
          /// 도착지 마커 추가
          markers.add(NMarker(
            id: "end",
            position: endMapData.latLng,
            icon: const NOverlayImage.fromAssetImage(ImageCommon.icEnd),
          ));
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
        controller.addOverlayAll(markers);

        var target = _homeViewModel.currentLatLng;
        if (startMapData != null && endMapData != null) {
          target = NLatLng(
            (startMapData.latLng.latitude + endMapData.latLng.latitude) / 2,
            (startMapData.latLng.longitude + endMapData.latLng.longitude) / 2,
          );
        } else if (startMapData != null) {
          target = NLatLng(startMapData.latLng.latitude, startMapData.latLng.longitude);
        } else if (endMapData != null) {
          target = NLatLng(endMapData.latLng.latitude, endMapData.latLng.longitude);
        }

        /// 카메라 위치 변경
        controller.updateCamera(
          NCameraUpdate.scrollAndZoomTo(
            target: target,
            zoom: 12, // 0.0 ~ 21.0
          ),
        );
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
    if (_lastOnPressed == null || now.difference(_lastOnPressed!) > const Duration(seconds: 2)) {
      _lastOnPressed = now;
      Fluttertoast.showToast(msg: StringHome.onBackPressed);
      return false;
    }
    return true;
  }
}
