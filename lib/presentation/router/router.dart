import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

import '../../domain/usecase/auth/get_jwt_usecase.dart';
import '../view/screen/auth/auth_screen.dart';
import '../view/screen/home/home_screen.dart';

final GoRouter router = GoRouter(
  initialLocation: HomeScreen.routeURL,

  /// Default
  redirect: (context, state) async {
    String jwt = await GetIt.instance<GetJwtUseCase>().execute();
    debugPrint("GoRouter jwt : $jwt");

    /// JWT를 보유중 == 로그인된 상태, 홈 화면으로 이동
    /// JWT가 없음 == 로그아웃된 상태, 로그인 화면으로 이동
    final isSignedIn = jwt.isNotEmpty;
    if (!isSignedIn) {
      if (state.location != AuthScreen.routeURL) {
        return AuthScreen.routeURL;
      }
    }
    return null;
  },
  routes: <RouteBase>[

    /// 회원가입 & 로그인
    GoRoute(
      name: AuthScreen.routeName,
      path: AuthScreen.routeURL,
      builder: (context, state) => const AuthScreen(),
    ),

    /// 홈
    GoRoute(
      name: HomeScreen.routeName,
      path: HomeScreen.routeURL,
      builder: (context, state) => const HomeScreen(),
    ),

  ],
);