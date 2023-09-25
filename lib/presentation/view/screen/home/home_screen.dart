import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:kdmp_cm_app/domain/usecase/secure_storage/mbr/get_mbrsq_usecase.dart';
import 'package:kdmp_cm_app/presentation/values/strings.dart';
import 'package:kdmp_cm_app/presentation/view/dialog/custom_alert_dialog.dart';
import 'package:kdmp_cm_app/presentation/view/dialog/custon_confirm_dialog.dart';
import 'package:kdmp_cm_app/presentation/view/screen/menu/menu_screen.dart';
import 'package:kdmp_cm_app/presentation/view/widget/common/behavior/custom_scroll_behavior.dart';
import 'package:kdmp_cm_app/presentation/view/widget/common/button/custom_radius_button.dart';
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

  void initData() {}

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
              Expanded(
                child: SizedBox(
                  width: double.maxFinite,
                  child: ScrollConfiguration(
                    behavior: CustomScrollBehavior(),
                    child: SingleChildScrollView(
                      child:
                          // TODO: 네이버지도 / 호출정보 입력 화면. Stack
                          Container(
                        color: Colors.green,
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    /// 예약하기 버튼
                    Expanded(
                      child: CustomRadiusButton(
                        text: StringHome.reservationButton,
                        onPressed: () async {
                          // TODO: 예약하기
                        },
                      ),
                    ),
                    const SizedBox(width: 8),

                    /// 호출하기 버튼
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () async {
                          // TODO: 호출하기
                        },
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
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<String> getCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    debugPrint("location position: $position");
    return "latitude: ${position.latitude}\nlongitude:${position.longitude}";
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
}
