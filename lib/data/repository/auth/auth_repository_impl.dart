import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../../../domain/repository/auth/auth_repository.dart';
import '../../constant/url.dart';
import '../../model/auth/auth_request_model.dart';
import '../../model/auth/auth_response_model.dart';
import '../../model/auth/auth_state.dart';

class AuthRepositoryImpl extends AuthRepository {

  final Dio _dio;

  AuthRepositoryImpl(this._dio);

  @override
  Future<AuthState> signIn({required AuthRequestModel authRequestModel}) async {
    const api = 'v1/signin/login';
    const url = '$baseUrl$api';

    try {
      final response = await _dio.post(
        url,
        data: authRequestModel.toJson(),
      );

      // TODO : 추후 서버 준비되면 code가 200인지, 201인지 확인하여 1개는 제거
      if (response.statusCode == 200 || response.statusCode == 201) {
        final authResponseModel = AuthResponseModel.fromJson(response.data);
        final AuthState state = Success(authResponseModel);

        debugPrint("state : $state");

        return state;
      }
      return Fail();
    } catch (e) {
      return Fail();
    }
  }

}
