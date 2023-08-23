import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

import '../../domain/usecase/auth/secure_storage/jwt/get_jwt_usecase.dart';
import '../view/screen/auth/permission/permission_screen.dart';
import '../view/screen/auth/terms/terms_detail_screen.dart';
import '../view/screen/auth/terms/terms_location_screen.dart';
import '../view/screen/auth/terms/terms_screen.dart';
import '../view/screen/auth/verification/verification_screen.dart';
import '../view/screen/home/home_screen.dart';

final GoRouter router = GoRouter(
  /// 기본 화면
  /// 아래 redirect 에서 걸리지 않는다면, 이 기본 화면으로 이동
  initialLocation: HomeScreen.routeURL,

  /// Redirect
  /// 앱 기동 & 화면 이동할 때, 아래 로직을 검증
  /// 검증을 통과하지 못하면, TermsScreen로 이동
  redirect: (context, state) async {
    String jwt = await GetIt.instance<GetJwtUseCase>().execute();
    // debugPrint("GoRouter jwt : $jwt");

    /// JWT를 보유중 == 로그인된 상태, 홈 화면으로 이동
    /// JWT가 없음 == 로그아웃된 상태, 로그인 화면(이용약관)으로 이동
    final isSignedIn = jwt.isNotEmpty;
    if (!isSignedIn) {
      /// 회원가입 로직(온보딩) 진행 중일 때는, 리다이렉트를 하지 않음
      if (state.location != TermsScreen.routeURL &&
          state.location != TermsDetailScreen.routeURL &&
          state.location != TermsLocationScreen.routeURL &&
          state.location != PermissionScreen.routeURL &&
          state.location != VerificationScreen.routeURL
      ) {
        return TermsScreen.routeURL;
      }
    }
    return null;
  },
  routes: <RouteBase>[

    /// 이용약관
    GoRoute(
      name: TermsScreen.routeName,
      path: TermsScreen.routeURL,
      builder: (context, state) => const TermsScreen(),
    ),

    /// 서비스 이용약관 상세
    GoRoute(
      name: TermsDetailScreen.routeName,
      path: TermsDetailScreen.routeURL,
      builder: (context, state) => const TermsDetailScreen(),
    ),

    /// 위치 서비스 이용약관 상세
    GoRoute(
      name: TermsLocationScreen.routeName,
      path: TermsLocationScreen.routeURL,
      builder: (context, state) => const TermsLocationScreen(),
    ),

    /// 권한
    GoRoute(
      name: PermissionScreen.routeName,
      path: PermissionScreen.routeURL,
      builder: (context, state) => const PermissionScreen(),
    ),

    /// 휴대폰번호 본인인증
    GoRoute(
      name: VerificationScreen.routeName,
      path: VerificationScreen.routeURL,
      builder: (context, state) => const VerificationScreen(),
    ),

    /// 홈
    GoRoute(
      name: HomeScreen.routeName,
      path: HomeScreen.routeURL,
      builder: (context, state) => const HomeScreen(),
    ),

  ],
);