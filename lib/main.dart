import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:get_it/get_it.dart';
import 'package:kdmp_cm_app/common/network/dio_singleton.dart';
import 'package:kdmp_cm_app/common/network/interceptor/token_interceptor.dart';
import 'package:kdmp_cm_app/data/repository/auth/auth_repository_impl.dart';
import 'package:kdmp_cm_app/data/repository/register/register_repository_impl.dart';
import 'package:kdmp_cm_app/data/repository/secure_storage/secure_storage_repository_impl.dart';
import 'package:kdmp_cm_app/data/repository/term/term_repository_impl.dart';
import 'package:kdmp_cm_app/domain/usecase/auth/login/get_login_usecase.dart';
import 'package:kdmp_cm_app/domain/usecase/auth/logout/set_logout_usecase.dart';
import 'package:kdmp_cm_app/domain/usecase/register/set_register_usecase.dart';
import 'package:kdmp_cm_app/domain/usecase/secure_storage/jwt/get_auto_refresh_usecase.dart';
import 'package:kdmp_cm_app/domain/usecase/secure_storage/jwt/set_auto_refresh_usecase.dart';
import 'package:kdmp_cm_app/domain/usecase/secure_storage/mbr/delete_storage_user_data_usecase.dart';
import 'package:kdmp_cm_app/domain/usecase/secure_storage/mbr/get_firstlogin_usecase.dart';
import 'package:kdmp_cm_app/domain/usecase/secure_storage/mbr/get_mbrid_usecase.dart';
import 'package:kdmp_cm_app/domain/usecase/secure_storage/mbr/get_mbrpw_usecase.dart';
import 'package:kdmp_cm_app/domain/usecase/secure_storage/mbr/get_mbrsq_usecase.dart';
import 'package:kdmp_cm_app/domain/usecase/secure_storage/mbr/get_onboarding_check_usecase.dart';
import 'package:kdmp_cm_app/domain/usecase/secure_storage/mbr/set_firstlogin_usecase.dart';
import 'package:kdmp_cm_app/domain/usecase/secure_storage/mbr/set_mbrid_usecase.dart';
import 'package:kdmp_cm_app/domain/usecase/secure_storage/mbr/set_mbrpw_usecase.dart';
import 'package:kdmp_cm_app/domain/usecase/secure_storage/mbr/set_mbrsq_usecase.dart';
import 'package:kdmp_cm_app/domain/usecase/secure_storage/mbr/set_onboarding_check_usecase.dart';
import 'package:kdmp_cm_app/domain/usecase/secure_storage/setup/setup_usecase.dart';
import 'package:kdmp_cm_app/domain/usecase/term/get_term_list_usecase.dart';
import 'package:kdmp_cm_app/presentation/theme/text_provider.dart';
import 'package:kdmp_cm_app/presentation/theme/theme_provider.dart';
import 'package:kdmp_cm_app/presentation/values/colors.dart';
import 'package:kdmp_cm_app/presentation/viewmodel/menu/setup_viewmodel.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:provider/provider.dart';

import 'domain/usecase/secure_storage/jwt/get_jwt_usecase.dart';
import 'domain/usecase/secure_storage/jwt/set_jwt_usecase.dart';
import 'presentation/router/router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  /// 키 관리 파일 가져오기
  await dotenv.load(fileName: ".env");

  /// 네이버 지도
  await NaverMapSdk.instance.initialize(
    clientId: dotenv.get("NAVER_CLIENT_ID"),
    onAuthFailed: (ex) => debugPrint("********* 네이버맵 인증오류 : $ex *********"),
  );

  /// 화면 세로 방향 고정
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  final getIt = GetIt.instance;

  /// 로컬 저장소
  final secureStorageRepository = SecureStorageRepositoryImpl();
  final getJwtUseCase = GetJwtUseCase(secureStorageRepository: secureStorageRepository);
  getIt.registerSingleton<GetJwtUseCase>(getJwtUseCase);
  final setJwtUseCase = SetJwtUseCase(secureStorageRepository: secureStorageRepository);
  getIt.registerSingleton<SetJwtUseCase>(setJwtUseCase);
  final getAutoRefreshUseCase = GetAutoRefreshUseCase(secureStorageRepository: secureStorageRepository);
  getIt.registerSingleton<GetAutoRefreshUseCase>(getAutoRefreshUseCase);
  final setAutoRefreshUseCase = SetAutoRefreshUseCase(secureStorageRepository: secureStorageRepository);
  getIt.registerSingleton<SetAutoRefreshUseCase>(setAutoRefreshUseCase);
  final getMbrSqUseCase = GetMbrSqUseCase(secureStorageRepository: secureStorageRepository);
  getIt.registerSingleton<GetMbrSqUseCase>(getMbrSqUseCase);
  final setMbrSqUseCase = SetMbrSqUseCase(secureStorageRepository: secureStorageRepository);
  getIt.registerSingleton<SetMbrSqUseCase>(setMbrSqUseCase);
  final getMbrIdUseCase = GetMbrIdUseCase(secureStorageRepository: secureStorageRepository);
  getIt.registerSingleton<GetMbrIdUseCase>(getMbrIdUseCase);
  final setMbrIdUseCase = SetMbrIdUseCase(secureStorageRepository: secureStorageRepository);
  getIt.registerSingleton<SetMbrIdUseCase>(setMbrIdUseCase);
  final getMbrPwUseCase = GetMbrPwUseCase(secureStorageRepository: secureStorageRepository);
  getIt.registerSingleton<GetMbrPwUseCase>(getMbrPwUseCase);
  final setMbrPwUseCase = SetMbrPwUseCase(secureStorageRepository: secureStorageRepository);
  getIt.registerSingleton<SetMbrPwUseCase>(setMbrPwUseCase);
  final setupUseCase = SetupUseCase(secureStorageRepository: secureStorageRepository);
  getIt.registerSingleton<SetupUseCase>(setupUseCase);
  final getFirstLoginUseCase = GetFirstLoginUseCase(secureStorageRepository: secureStorageRepository);
  getIt.registerSingleton<GetFirstLoginUseCase>(getFirstLoginUseCase);
  final setFirstLoginUseCase = SetFirstLoginUseCase(secureStorageRepository: secureStorageRepository);
  getIt.registerSingleton<SetFirstLoginUseCase>(setFirstLoginUseCase);
  final deleteStorageUserDataUseCase = DeleteStorageUserDataUseCase(secureStorageRepository: secureStorageRepository);
  getIt.registerSingleton<DeleteStorageUserDataUseCase>(deleteStorageUserDataUseCase);
  final setOnBoardingCheckUseCase = SetOnBoardingCheckUseCase(secureStorageRepository: secureStorageRepository);
  getIt.registerSingleton<SetOnBoardingCheckUseCase>(setOnBoardingCheckUseCase);
  final getOnBoardingCheckUseCase = GetOnBoardingCheckUseCase(secureStorageRepository: secureStorageRepository);
  getIt.registerSingleton<GetOnBoardingCheckUseCase>(getOnBoardingCheckUseCase);

  /// 환경설정값
  final themeMode = await setupUseCase.getThemeMode();

  final mThemeMode = themeMode == "light" ? ThemeMode.light : ThemeMode.dark;

  /// Dio Singleton
  final Dio dio = DioSingleton.getInstance();

  /// Dio Token Interceptor
  /// 로컬에 저장된 JWT를 가져온 다음, Dio header에 Bearer로 추가해주는 Interceptor
  dio.interceptors.add(TokenInterceptor(
    dio: dio,
    getJwtUseCase: getJwtUseCase,
    getAutoRefreshUseCase: getAutoRefreshUseCase,
    getMbrIdUseCase: getMbrIdUseCase,
    setMbrIdUseCase: setMbrIdUseCase,
    setMbrPwUseCase: setMbrPwUseCase,
    setJwtUseCase: setJwtUseCase,
    setAutoRefreshUseCase: setAutoRefreshUseCase,
  ));

  /// Dio Log Interceptor
  /// 디버그 모드에서만 Dio 인스턴스의 모든 로그를 출력
  if (kDebugMode) {
    dio.interceptors.add(PrettyDioLogger(
      requestHeader: true,
      requestBody: true,
      responseBody: true,
      responseHeader: true,
      compact: true,
    ));
  }

  /// 로그인, 로그아웃
  final authRepository = AuthRepositoryImpl(dio);
  final getLoginUseCase = GetLoginUseCase(authRepository: authRepository);
  getIt.registerSingleton<GetLoginUseCase>(getLoginUseCase);
  final setLogoutUseCase = SetLogoutUseCase(authRepository: authRepository);
  getIt.registerSingleton<SetLogoutUseCase>(setLogoutUseCase);

  /// 이용약관
  final termRepository = TermRepositoryImpl(dio);
  final getTermUseCase = GetTermUseCase(termRepository: termRepository);
  getIt.registerSingleton<GetTermUseCase>(getTermUseCase);

  /// 회원가입
  final registerRepository = RegisterRepositoryImpl(dio);
  final getRegisterUseCase = SetRegisterUseCase(registerRepository: registerRepository);
  getIt.registerSingleton<SetRegisterUseCase>(getRegisterUseCase);

  runApp(MyApp(themeMode: mThemeMode));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, this.themeMode = ThemeMode.light});

  final ThemeMode themeMode;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => ThemeProvider(themeMode: themeMode),
        ),
        ChangeNotifierProvider(
          create: (context) => TextProvider(textMode: TextMode.medium),
        ),
      ],
      builder: (context, child) {
        return MaterialApp.router(
          routerConfig: router,
          localizationsDelegates: const [
            // 다언어 설정
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('ko', 'KR'), // 한국어
            Locale('en', 'US'), // 영어
          ],
          theme: ThemeData(
            /// PageTransitionsTheme로 화면이 열리고 닫힐 때 iOS 같은 애니메이션 효과를 적용
            pageTransitionsTheme: const PageTransitionsTheme(
              builders: {
                TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
                TargetPlatform.android: CupertinoPageTransitionsBuilder(),
              },
            ),
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            canvasColor: Colors.transparent,

            /// 기본 테마
            scaffoldBackgroundColor: ColorLight.background,
            disabledColor: ColorLight.gray3,
            dividerColor: ColorLight.gray6,
            cardColor: ColorLight.gray5,
            colorScheme: const ColorScheme.light(
              primary: ColorLight.primary,
              secondary: ColorLight.icon,
            ),
            appBarTheme: AppBarTheme.of(context).copyWith(
              backgroundColor: ColorLight.background,
              iconTheme: const IconThemeData(color: ColorLight.gray1),
            ),
            iconTheme: const IconThemeData(color: ColorLight.gray1),
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                minimumSize: const Size(double.infinity, double.minPositive),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 0,
                backgroundColor: ColorLight.primary,
                textStyle: TextStyle(
                  color: ColorLight.background,
                  fontWeight: FontWeight.w400,
                  fontSize: Provider.of<TextProvider>(context).text16,
                  letterSpacing: 0.0,
                  wordSpacing: 0.0,
                  height: 0.0,
                ),
              ),
            ),
            toggleButtonsTheme: ToggleButtonsThemeData(
              color: ColorLight.gray4,
              borderColor: ColorLight.gray6,
              selectedColor: ColorLight.icon,
              selectedBorderColor: ColorLight.icon,
              fillColor: ColorLight.btn,
              borderRadius: BorderRadius.circular(4),
            ),
            textTheme: TextTheme(
              bodyLarge: TextStyle(
                color: ColorLight.gray1,
                fontWeight: FontWeight.w400,
                fontSize: Provider.of<TextProvider>(context).text16,
                letterSpacing: 0.0,
                wordSpacing: 0.0,
                height: 0.0,
              ),
              // 기본 적용 텍스트
              bodyMedium: TextStyle(
                color: ColorLight.gray1,
                fontWeight: FontWeight.w400,
                fontSize: Provider.of<TextProvider>(context).text14,
                letterSpacing: 0.0,
                wordSpacing: 0.0,
                height: 0.0,
              ),
              bodySmall: TextStyle(
                color: ColorLight.gray1,
                fontWeight: FontWeight.w400,
                fontSize: Provider.of<TextProvider>(context).text12,
                letterSpacing: 0.0,
                wordSpacing: 0.0,
                height: 0.0,
              ),
              titleLarge: TextStyle(
                color: ColorLight.gray1,
                fontWeight: FontWeight.w600,
                fontSize: Provider.of<TextProvider>(context).text16,
                letterSpacing: 0.0,
                wordSpacing: 0.0,
                height: 0.0,
              ),
              titleMedium: TextStyle(
                color: ColorLight.gray1,
                fontWeight: FontWeight.w600,
                fontSize: Provider.of<TextProvider>(context).text14,
                letterSpacing: 0.0,
                wordSpacing: 0.0,
                height: 0.0,
              ),
              titleSmall: TextStyle(
                color: ColorLight.gray1,
                fontWeight: FontWeight.w600,
                fontSize: Provider.of<TextProvider>(context).text12,
                letterSpacing: 0.0,
                wordSpacing: 0.0,
                height: 0.0,
              ),
              displaySmall: TextStyle(
                color: ColorLight.gray1,
                fontWeight: FontWeight.w600,
                fontSize: Provider.of<TextProvider>(context).text20,
                letterSpacing: 0.0,
                wordSpacing: 0.0,
                height: 0.0,
              ),
              displayMedium: TextStyle(
                color: ColorLight.gray1,
                fontWeight: FontWeight.w600,
                fontSize: Provider.of<TextProvider>(context).text22,
                letterSpacing: 0.0,
                wordSpacing: 0.0,
                height: 0.0,
              ),
              displayLarge: TextStyle(
                color: ColorLight.gray1,
                fontWeight: FontWeight.w600,
                fontSize: Provider.of<TextProvider>(context).text24,
                letterSpacing: 0.0,
                wordSpacing: 0.0,
                height: 0.0,
              ),
            ),
            sliderTheme: const SliderThemeData(
              activeTrackColor: ColorLight.icon,
              activeTickMarkColor: ColorLight.icon,
              inactiveTrackColor: ColorLight.gray6,
              inactiveTickMarkColor: ColorLight.gray6,
              thumbColor: ColorLight.icon,
            ),
          ),
          darkTheme: ThemeData.dark().copyWith(
            /// 다크 모드 테마
            scaffoldBackgroundColor: ColorNight.background,
            disabledColor: ColorNight.gray3,
            dividerColor: ColorNight.gray6,
            cardColor: ColorNight.gray5,
            colorScheme: const ColorScheme.dark(
              primary: ColorNight.primary,
              secondary: ColorNight.icon,
            ),
            appBarTheme: AppBarTheme.of(context).copyWith(
              backgroundColor: ColorNight.background,
              iconTheme: const IconThemeData(color: ColorNight.gray1),
            ),
            iconTheme: const IconThemeData(color: ColorNight.gray1),
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                minimumSize: const Size(double.infinity, double.minPositive),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 0,
                backgroundColor: ColorNight.primary,
                textStyle: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w400,
                  fontSize: Provider.of<TextProvider>(context).text16,
                  letterSpacing: 0.0,
                  wordSpacing: 0.0,
                  height: 0.0,
                ),
              ),
            ),
            toggleButtonsTheme: ToggleButtonsThemeData(
              color: ColorNight.gray4,
              borderColor: ColorNight.gray6,
              selectedColor: ColorNight.icon,
              selectedBorderColor: ColorNight.icon,
              fillColor: ColorNight.btn,
              borderRadius: BorderRadius.circular(4),
            ),
            textTheme: TextTheme(
              bodyLarge: TextStyle(
                color: ColorNight.gray1,
                fontWeight: FontWeight.w400,
                fontSize: Provider.of<TextProvider>(context).text16,
                letterSpacing: 0.0,
                wordSpacing: 0.0,
                height: 0.0,
              ),
              // 기본 적용 텍스트
              bodyMedium: TextStyle(
                color: ColorNight.gray1,
                fontWeight: FontWeight.w400,
                fontSize: Provider.of<TextProvider>(context).text14,
                letterSpacing: 0.0,
                wordSpacing: 0.0,
                height: 0.0,
              ),
              bodySmall: TextStyle(
                color: ColorNight.gray1,
                fontWeight: FontWeight.w400,
                fontSize: Provider.of<TextProvider>(context).text12,
                letterSpacing: 0.0,
                wordSpacing: 0.0,
                height: 0.0,
              ),
              titleLarge: TextStyle(
                color: ColorNight.gray1,
                fontWeight: FontWeight.w600,
                fontSize: Provider.of<TextProvider>(context).text16,
                letterSpacing: 0.0,
                wordSpacing: 0.0,
                height: 0.0,
              ),
              titleMedium: TextStyle(
                color: ColorNight.gray1,
                fontWeight: FontWeight.w600,
                fontSize: Provider.of<TextProvider>(context).text14,
                letterSpacing: 0.0,
                wordSpacing: 0.0,
                height: 0.0,
              ),
              titleSmall: TextStyle(
                color: ColorNight.gray1,
                fontWeight: FontWeight.w600,
                fontSize: Provider.of<TextProvider>(context).text12,
                letterSpacing: 0.0,
                wordSpacing: 0.0,
                height: 0.0,
              ),
              displaySmall: TextStyle(
                color: ColorNight.gray1,
                fontWeight: FontWeight.w600,
                fontSize: Provider.of<TextProvider>(context).text20,
                letterSpacing: 0.0,
                wordSpacing: 0.0,
                height: 0.0,
              ),
              displayMedium: TextStyle(
                color: ColorNight.gray1,
                fontWeight: FontWeight.w600,
                fontSize: Provider.of<TextProvider>(context).text22,
                letterSpacing: 0.0,
                wordSpacing: 0.0,
                height: 0.0,
              ),
              displayLarge: TextStyle(
                color: ColorNight.gray1,
                fontWeight: FontWeight.w600,
                fontSize: Provider.of<TextProvider>(context).text24,
                letterSpacing: 0.0,
                wordSpacing: 0.0,
                height: 0.0,
              ),
            ),
            sliderTheme: const SliderThemeData(
              activeTrackColor: ColorNight.icon,
              activeTickMarkColor: ColorNight.icon,
              inactiveTrackColor: ColorNight.gray6,
              inactiveTickMarkColor: ColorNight.gray6,
              thumbColor: ColorNight.icon,
            ),
          ),
          themeMode: Provider.of<ThemeProvider>(context).themeMode,
          // builder: (context, child) {
          //   return MediaQuery(
          //     data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
          //     child: child!,
          //   );
          // },
        );
      },
    );
  }
}
