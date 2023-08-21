import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import 'data/networking/dio_singleton.dart';
import 'data/networking/interceptor/token_interceptor.dart';
import 'data/repository/secure_storage/secure_storage_repository_impl.dart';
import 'domain/usecase/auth/secure_storage/jwt/get_jwt_usecase.dart';
import 'domain/usecase/auth/secure_storage/jwt/set_jwt_usecase.dart';
import 'presentation/router/router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  /// 화면 세로 방향 고정
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  final getIt = GetIt.instance;

  /// 'SecureStorage'는 보안성이 더 높은 SharedPreferences라고 보시면 됩니다
  /// 로컬 저장소
  final secureStorageRepository = SecureStorageRepositoryImpl();
  final getJwtUseCase = GetJwtUseCase(secureStorageRepository: secureStorageRepository);
  getIt.registerSingleton<GetJwtUseCase>(getJwtUseCase);
  final setJwtUseCase = SetJwtUseCase(secureStorageRepository: secureStorageRepository);
  getIt.registerSingleton<SetJwtUseCase>(setJwtUseCase);

  /// Dio Singleton
  final Dio dio = DioSingleton.getInstance();
  /// Dio Token Interceptor
  /// 로컬에 저장된 JWT를 가져온 다음, Dio header에 Bearer로 추가해주는 Interceptor
  dio.interceptors.add(TokenInterceptor(getJwtUseCase: getJwtUseCase));

  /// Dio Log Interceptor
  /// 디버그 모드에서만 Dio 인스턴스의 모든 로그를 출력
  if (kDebugMode) {
    dio.interceptors.add(
        PrettyDioLogger(
          requestHeader: true,
          requestBody: true,
          responseBody: true,
          responseHeader: true,
          compact: true,
        )
    );
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: router,
      theme: ThemeData(
        /// PageTransitionsTheme로 화면이 열리고 닫힐 때 iOS 같은 애니메이션 효과를 적용
        ///
        /// 저는 개인적으로 이 iOS 효과가 제일 예뻐서 추가해놨습니다
        /// 혹시 이거말고 다른 애니메이션을 사용하고 싶으시면, 수정하셔도 괜찮습니다
        pageTransitionsTheme: const PageTransitionsTheme(
          builders: {
            TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
            TargetPlatform.android: CupertinoPageTransitionsBuilder(),
          },
        ),
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
      ),
    );
  }
}
