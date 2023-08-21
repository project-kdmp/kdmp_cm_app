import 'package:dio/dio.dart';

import '../../../domain/usecase/auth/secure_storage/jwt/get_jwt_usecase.dart';

class TokenInterceptor extends InterceptorsWrapper {
  final GetJwtUseCase getJwtUseCase;

  TokenInterceptor({required this.getJwtUseCase});

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final token = await getJwtUseCase.execute();
    options.headers['Authorization'] = 'Bearer $token'; // TODO : 추후 서버 준비됐을 때 Bearer가 아니라면, 수정해주세요
    super.onRequest(options, handler);
  }
}