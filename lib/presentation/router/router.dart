import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:kdmp_cm_app/data/model/register/register_request.dart';
import 'package:kdmp_cm_app/domain/usecase/secure_storage/jwt/get_jwt_usecase.dart';
import 'package:kdmp_cm_app/domain/usecase/secure_storage/mbr/get_firstlogin_usecase.dart';
import 'package:kdmp_cm_app/presentation/view/screen/auth/login_screen.dart';
import 'package:kdmp_cm_app/presentation/view/screen/home/home_screen.dart';
import 'package:kdmp_cm_app/presentation/view/screen/onboarding/onboarding_screen.dart';
import 'package:kdmp_cm_app/presentation/view/screen/permission/permission_screen.dart';
import 'package:kdmp_cm_app/presentation/view/screen/register/no_permission_screen.dart';
import 'package:kdmp_cm_app/presentation/view/screen/register/phone_verify_screen.dart';
import 'package:kdmp_cm_app/presentation/view/screen/register/register_car_screen.dart';
import 'package:kdmp_cm_app/presentation/view/screen/splash/splash_screen.dart';
import 'package:kdmp_cm_app/presentation/view/screen/term/cm_term_screen.dart';
import 'package:kdmp_cm_app/presentation/view/screen/term/driver_term_screen.dart';
import 'package:kdmp_cm_app/presentation/view/screen/term/term_detail_screen.dart';
import 'package:kdmp_cm_app/presentation/view/screen/term/term_screen.dart';

final GoRouter router = GoRouter(
  initialLocation: SplashScreen.routeURL,

  /// Default
  redirect: (context, state) async {
    final jwt = await GetIt.instance<GetJwtUseCase>().execute();
    final isFirstLogin = await GetIt.instance<GetFirstLoginUseCase>().execute();

    debugPrint("GoRouter jwt : $jwt, isFirstLogin : $isFirstLogin");

    /// JWT를 보유중 == 로그인된 상태, 스플래시 화면으로 이동
    /// JWT가 없음 == 로그아웃된 상태, 로그인 화면으로 이동
    final isLogin = jwt.isNotEmpty;
    if (!isLogin) {
      /// 로그인 아닌 상태
      if (isFirstLogin) {
        /// 한번도 로그인한적이 없는 경우, 접근 권한 안내 화면으로 이동
        debugPrint("state: ${state.matchedLocation}");
        if (!state.matchedLocation.contains(PermissionScreen.routeURL) && !state.matchedLocation.contains(TermScreen.routeURL) && !state.matchedLocation.contains(PhoneVerifyScreen.routeURL) && !state.matchedLocation.contains(LoginScreen.routeURL)) {
          return PermissionScreen.routeURL;
        }
      } else {
        /// 로그인한적 있는 경우, 로그인 화면으로 이동
        if (state.matchedLocation != LoginScreen.routeURL) {
          return LoginScreen.routeURL;
        }
      }
    }
    return null;
  },
  routes: <RouteBase>[
    /// 스플래시
    GoRoute(
      name: SplashScreen.routeName,
      path: SplashScreen.routeURL,
      builder: (context, state) => const SplashScreen(),
    ),

    /// 온보딩
    GoRoute(
      name: OnBoardingScreen.routeName,
      path: OnBoardingScreen.routeURL,
      builder: (context, state) => const OnBoardingScreen(),
    ),

    /// 로그인
    GoRoute(
      name: LoginScreen.routeName,
      path: LoginScreen.routeURL,
      builder: (context, state) => const LoginScreen(),
    ),

    /// 홈
    GoRoute(
      name: HomeScreen.routeName,
      path: HomeScreen.routeURL,
      builder: (context, state) => const HomeScreen(),
    ),

    /// 접근 권한 안내
    GoRoute(
      name: PermissionScreen.routeName,
      path: PermissionScreen.routeURL,
      builder: (context, state) => const PermissionScreen(),
    ),

    /// 이용약관
    GoRoute(
      name: TermScreen.routeName,
      path: TermScreen.routeURL,
      builder: (context, state) => const TermScreen(),
    ),

    /// 미동의 이용약관
    GoRoute(
      name: CMTermScreen.routeName,
      path: CMTermScreen.routeURL,
      builder: (context, state) => const CMTermScreen(),
    ),

    /// 이용약관 상세
    GoRoute(
      name: TermDetailScreen.routeName,
      path: TermDetailScreen.routeURL,
      builder: (context, state) {
        final params = state.uri.queryParameters;
        final int trmSq = int.parse(params["trmSq"]!);
        final bool isAgreeButtonEnabled = params["isAgreeButtonEnabled"] != null ? bool.parse(params["isAgreeButtonEnabled"]!) : true;
        return TermDetailScreen(trmSq: trmSq, isAgreeButtonEnabled: isAgreeButtonEnabled);
      },
    ),

    /// 본인인증 확인
    GoRoute(
      name: PhoneVerifyScreen.routeName,
      path: PhoneVerifyScreen.routeURL,
      builder: (context, state) {
        final List<AgreeTerm> agreeTermList = state.extra as List<AgreeTerm>;
        return PhoneVerifyScreen(agreeTermList: agreeTermList);
      },
    ),

    /// 초기 차량정보 등록
    GoRoute(
      name: RegisterCarScreen.routeName,
      path: RegisterCarScreen.routeURL,
      builder: (context, state) => const RegisterCarScreen(),
    ),

    /// 정지 회원 안내
    GoRoute(
      name: NoPermissionScreen.routeName,
      path: NoPermissionScreen.routeURL,
      builder: (context, state) => const NoPermissionScreen(),
    ),

    /// 운행불가 차량안내
    GoRoute(
      name: DriverTermScreen.routeName,
      path: DriverTermScreen.routeURL,
      builder: (context, state) => const DriverTermScreen(),
    ),
  ],
);
