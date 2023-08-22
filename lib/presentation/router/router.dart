import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

import '../../domain/usecase/auth/secure_storage/jwt/get_jwt_usecase.dart';
import '../view/screen/auth/terms/terms_screen.dart';
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
    debugPrint("GoRouter jwt : $jwt");

    /// JWT를 보유중 == 로그인된 상태, 홈 화면으로 이동
    /// JWT가 없음 == 로그아웃된 상태, 로그인 화면(이용약관)으로 이동
    final isSignedIn = jwt.isNotEmpty;
    if (!isSignedIn) {
      if (state.location != TermsScreen.routeURL) {
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

    /// 홈
    GoRoute(
      name: HomeScreen.routeName,
      path: HomeScreen.routeURL,
      builder: (context, state) => const HomeScreen(),
    ),

  ],
);