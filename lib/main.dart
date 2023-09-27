import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:get_it/get_it.dart';
import 'package:kdmp_cm_app/common/network/dio_singleton.dart';
import 'package:kdmp_cm_app/common/network/interceptor/token_interceptor.dart';
import 'package:kdmp_cm_app/data/repository/auth/auth_repository_impl.dart';
import 'package:kdmp_cm_app/data/repository/mypage/mypage_repository_impl.dart';
import 'package:kdmp_cm_app/data/repository/naver/naver_repository_impl.dart';
import 'package:kdmp_cm_app/data/repository/register/register_repository_impl.dart';
import 'package:kdmp_cm_app/data/repository/secure_storage/secure_storage_repository_impl.dart';
import 'package:kdmp_cm_app/data/repository/term/term_repository_impl.dart';
import 'package:kdmp_cm_app/data/repository/work/work_repository_impl.dart';
import 'package:kdmp_cm_app/domain/usecase/auth/login/get_login_usecase.dart';
import 'package:kdmp_cm_app/domain/usecase/auth/logout/set_logout_usecase.dart';
import 'package:kdmp_cm_app/domain/usecase/mypage/get_call_detail_usecase.dart';
import 'package:kdmp_cm_app/domain/usecase/mypage/get_call_list_usecase.dart';
import 'package:kdmp_cm_app/domain/usecase/mypage/get_called_detail_usecase.dart';
import 'package:kdmp_cm_app/domain/usecase/mypage/get_called_list_usecase.dart';
import 'package:kdmp_cm_app/domain/usecase/mypage/get_car_list_usecase.dart';
import 'package:kdmp_cm_app/domain/usecase/mypage/get_place_list_usecase.dart';
import 'package:kdmp_cm_app/domain/usecase/mypage/get_profile_detail_usecase.dart';
import 'package:kdmp_cm_app/domain/usecase/mypage/set_called_delete_usecase.dart';
import 'package:kdmp_cm_app/domain/usecase/mypage/set_car_add_usecase.dart';
import 'package:kdmp_cm_app/domain/usecase/mypage/set_car_delete_usecase.dart';
import 'package:kdmp_cm_app/domain/usecase/mypage/set_car_modify_usecase.dart';
import 'package:kdmp_cm_app/domain/usecase/mypage/set_place_add_usecase.dart';
import 'package:kdmp_cm_app/domain/usecase/mypage/set_place_delete_usecase.dart';
import 'package:kdmp_cm_app/domain/usecase/mypage/set_place_modify_usecase.dart';
import 'package:kdmp_cm_app/domain/usecase/mypage/set_withdrawal_member_usecase.dart';
import 'package:kdmp_cm_app/domain/usecase/naver/get_naver_address_info_usecase.dart';
import 'package:kdmp_cm_app/domain/usecase/naver/get_naver_address_usecase.dart';
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
import 'package:kdmp_cm_app/domain/usecase/term/set_my_term_usecase.dart';
import 'package:kdmp_cm_app/domain/usecase/work/get_call_info_usecase.dart';
import 'package:kdmp_cm_app/domain/usecase/work/get_reservation_info_usecase.dart';
import 'package:kdmp_cm_app/domain/usecase/work/set_call_cancel_usecase.dart';
import 'package:kdmp_cm_app/domain/usecase/work/set_call_fee_change_usecase.dart';
import 'package:kdmp_cm_app/domain/usecase/work/set_call_request_usecase.dart';
import 'package:kdmp_cm_app/domain/usecase/work/set_confirm_call_cancel_usecase.dart';
import 'package:kdmp_cm_app/domain/usecase/work/set_pay_usecase.dart';
import 'package:kdmp_cm_app/domain/usecase/work/set_reservation_request_usecase.dart';
import 'package:kdmp_cm_app/presentation/theme/custom_text_mode.dart';
import 'package:kdmp_cm_app/presentation/theme/custom_theme_data.dart';
import 'package:kdmp_cm_app/presentation/theme/custom_theme_mode.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import 'domain/usecase/secure_storage/jwt/get_jwt_usecase.dart';
import 'domain/usecase/secure_storage/jwt/set_jwt_usecase.dart';
import 'presentation/router/router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  /// 키 관리 파일 가져오기
  await dotenv.load(fileName: ".env");

  /// 네이버 지도
  await NaverMapSdk.instance.initialize(
    clientId: dotenv.get("NAVER_MAP_CLIENT_ID"),
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
  CustomThemeMode.instance;
  CustomTextMode.instance;
  var mThemeMode = themeMode == "light" ? ThemeMode.light : ThemeMode.dark;
  CustomThemeMode.change(mThemeMode);

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
  final setMyTermUseCase = SetMyTermUseCase(termRepository: termRepository);
  getIt.registerSingleton<SetMyTermUseCase>(setMyTermUseCase);

  /// 회원가입
  final registerRepository = RegisterRepositoryImpl(dio);
  final getRegisterUseCase = SetRegisterUseCase(registerRepository: registerRepository);
  getIt.registerSingleton<SetRegisterUseCase>(getRegisterUseCase);

  /// 내정보
  final myPageRepository = MyPageRepositoryImpl(dio);
  final getProfileDetailUseCase = GetProfileDetailUseCase(myPageRepository: myPageRepository);
  getIt.registerSingleton<GetProfileDetailUseCase>(getProfileDetailUseCase);
  final setWithdrawalMemberUseCase = SetWithdrawalMemberUseCase(myPageRepository: myPageRepository);
  getIt.registerSingleton<SetWithdrawalMemberUseCase>(setWithdrawalMemberUseCase);
  final getCallListUseCase = GetCallListUseCase(myPageRepository: myPageRepository);
  getIt.registerSingleton<GetCallListUseCase>(getCallListUseCase);
  final getCallDetailUseCase = GetCallDetailUseCase(myPageRepository: myPageRepository);
  getIt.registerSingleton<GetCallDetailUseCase>(getCallDetailUseCase);
  final getCalledListUseCase = GetCalledListUseCase(myPageRepository: myPageRepository);
  getIt.registerSingleton<GetCalledListUseCase>(getCalledListUseCase);
  final getCalledDetailUseCase = GetCalledDetailUseCase(myPageRepository: myPageRepository);
  getIt.registerSingleton<GetCalledDetailUseCase>(getCalledDetailUseCase);
  final setCalledDeleteUseCase = SetCalledDeleteUseCase(myPageRepository: myPageRepository);
  getIt.registerSingleton<SetCalledDeleteUseCase>(setCalledDeleteUseCase);
  final getCarListUseCase = GetCarListUseCase(myPageRepository: myPageRepository);
  getIt.registerSingleton<GetCarListUseCase>(getCarListUseCase);
  final setCarAddUseCase = SetCarAddUseCase(myPageRepository: myPageRepository);
  getIt.registerSingleton<SetCarAddUseCase>(setCarAddUseCase);
  final setCarDeleteUseCase = SetCarDeleteUseCase(myPageRepository: myPageRepository);
  getIt.registerSingleton<SetCarDeleteUseCase>(setCarDeleteUseCase);
  final setCarModifyUseCase = SetCarModifyUseCase(myPageRepository: myPageRepository);
  getIt.registerSingleton<SetCarModifyUseCase>(setCarModifyUseCase);
  final getPlaceListUseCase = GetPlaceListUseCase(myPageRepository: myPageRepository);
  getIt.registerSingleton<GetPlaceListUseCase>(getPlaceListUseCase);
  final setPlaceAddUseCase = SetPlaceAddUseCase(myPageRepository: myPageRepository);
  getIt.registerSingleton<SetPlaceAddUseCase>(setPlaceAddUseCase);
  final setPlaceDeleteUseCase = SetPlaceDeleteUseCase(myPageRepository: myPageRepository);
  getIt.registerSingleton<SetPlaceDeleteUseCase>(setPlaceDeleteUseCase);
  final setPlaceModifyUseCase = SetPlaceModifyUseCase(myPageRepository: myPageRepository);
  getIt.registerSingleton<SetPlaceModifyUseCase>(setPlaceModifyUseCase);

  /// 기사요청
  final workRepository = WorkRepositoryImpl(dio);
  final getCallInfoUseCase = GetCallInfoUseCase(workRepository: workRepository);
  getIt.registerSingleton<GetCallInfoUseCase>(getCallInfoUseCase);
  final getReservationInfoUseCase = GetReservationInfoUseCase(workRepository: workRepository);
  getIt.registerSingleton<GetReservationInfoUseCase>(getReservationInfoUseCase);
  final setCallCancelUseCase = SetCallCancelUseCase(workRepository: workRepository);
  getIt.registerSingleton<SetCallCancelUseCase>(setCallCancelUseCase);
  final setCallFeeChangeUseCase = SetCallFeeChangeUseCase(workRepository: workRepository);
  getIt.registerSingleton<SetCallFeeChangeUseCase>(setCallFeeChangeUseCase);
  final setCallRequestUseCase = SetCallRequestUseCase(workRepository: workRepository);
  getIt.registerSingleton<SetCallRequestUseCase>(setCallRequestUseCase);
  final setConfirmCallCancelUseCase = SetConfirmCallCancelUseCase(workRepository: workRepository);
  getIt.registerSingleton<SetConfirmCallCancelUseCase>(setConfirmCallCancelUseCase);
  final setPayUseCase = SetPayUseCase(workRepository: workRepository);
  getIt.registerSingleton<SetPayUseCase>(setPayUseCase);
  final setReservationRequestUseCase = SetReservationRequestUseCase(workRepository: workRepository);
  getIt.registerSingleton<SetReservationRequestUseCase>(setReservationRequestUseCase);

  /// 네이버 API
  final naverRepository = NaverRepositoryImpl(dio);
  final getNaverAddressUseCase = GetNaverAddressUseCase(naverRepository: naverRepository);
  getIt.registerSingleton<GetNaverAddressUseCase>(getNaverAddressUseCase);
  final getNaverAddressInfoUseCase = GetNaverAddressInfoUseCase(naverRepository: naverRepository);
  getIt.registerSingleton<GetNaverAddressInfoUseCase>(getNaverAddressInfoUseCase);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: CustomThemeMode.themeMode,
      builder: (context, themeMode, child) {
        return ValueListenableBuilder<TextTheme>(
          valueListenable: CustomTextMode.textTheme,
          builder: (context, textTheme, child) {
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
              theme: CustomThemeData.light(textTheme),
              darkTheme: CustomThemeData.dark(textTheme),
              themeMode: themeMode,
              builder: (context, child) {
                return MediaQuery(
                  data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
                  child: child!,
                );
              },
            );
          },
        );
      },
    );
  }
}
