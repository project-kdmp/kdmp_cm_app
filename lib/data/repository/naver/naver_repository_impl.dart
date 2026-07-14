import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:kdmp_cm_app/common/network/dio_exceptions.dart';
import 'package:kdmp_cm_app/data/constant/constants.dart';
import 'package:kdmp_cm_app/data/model/common/state.dart';
import 'package:kdmp_cm_app/data/model/naver/directions_request.dart';
import 'package:kdmp_cm_app/data/model/naver/directions_response.dart';
import 'package:kdmp_cm_app/data/model/naver/geocoding_request.dart';
import 'package:kdmp_cm_app/data/model/naver/geocoding_response.dart';
import 'package:kdmp_cm_app/data/model/naver/reverse_geocoding_request.dart';
import 'package:kdmp_cm_app/data/model/naver/reverse_geocoding_response.dart';
import 'package:kdmp_cm_app/domain/repository/naver/naver_repository.dart';

class NaverRepositoryImpl extends NaverRepository {
  final Dio _dio;

  NaverRepositoryImpl(this._dio);

  @override
  Future<StateAPI> getAddress({required String clientId, required String clientSecret, required ReverseGeocodingRequest reverseGeocodingRequest}) async {
    const api = '/map-reversegeocode/v2/gc';
    final url = '${AppConstants.NAVER_API}$api';

    try {
      final response = await _dio.get(
        url,
        queryParameters: reverseGeocodingRequest.toJson(),
        options: Options(
          contentType: Headers.jsonContentType,
          headers: Map.from(
            {
              "X-NCP-APIGW-API-KEY-ID": clientId,
              "X-NCP-APIGW-API-KEY": clientSecret,
            },
          ),
        ),
      );

      final responseObject = ReverseGeocodingResponse.fromJson(response.data);
      if (responseObject.status.code == 0) {
        final StateAPI state = Success(responseObject);
        debugPrint("state: $state");
        return state;
      } else {
        Fluttertoast.showToast(msg: responseObject.status.message);
        return Fail(errorMessage: responseObject.status.message);
      }
    } catch (e, stackTrace) {
      const errorMessage = "알 수 없는 오류가 발생했습니다.";
      debugPrint("[$runtimeType] error: $e\n$stackTrace");
      Fluttertoast.showToast(msg: errorMessage);
      return Fail(errorMessage: errorMessage);
    }
  }

  @override
  Future<StateAPI> getAddressInfo({required String clientId, required String clientSecret, required GeocodingRequest geocodingRequest}) async {
    const api = '/map-geocode/v2/geocode';
    final url = '${AppConstants.NAVER_API}$api';

    try {
      final response = await _dio.get(
        url,
        queryParameters: geocodingRequest.toJson(),
        options: Options(
          contentType: Headers.jsonContentType,
          headers: Map.from(
            {
              "X-NCP-APIGW-API-KEY-ID": clientId,
              "X-NCP-APIGW-API-KEY": clientSecret,
            },
          ),
        ),
      );

      final responseObject = GeocodingResponse.fromJson(response.data);
      final StateAPI state = Success(responseObject);
      debugPrint("state: $state");
      return state;
    } catch (e, stackTrace) {
      const errorMessage = "알 수 없는 오류가 발생했습니다.";
      debugPrint("[$runtimeType] error: $e\n$stackTrace");
      Fluttertoast.showToast(msg: errorMessage);
      return Fail(errorMessage: errorMessage);
    }
  }

  @override
  Future<StateAPI> getDriving({required String clientId, required String clientSecret, required DirectionsRequest directionsRequest}) async {
    const api = '/map-direction/v1/driving';
    final url = '${AppConstants.NAVER_API}$api';

    try {
      final response = await _dio.get(
        url,
        queryParameters: directionsRequest.toJson(),
        options: Options(
          contentType: Headers.jsonContentType,
          headers: Map.from(
            {
              "X-NCP-APIGW-API-KEY-ID": clientId,
              "X-NCP-APIGW-API-KEY": clientSecret,
            },
          ),
        ),
      );

      final responseObject = DirectionsResponse.fromJson(response.data);
      if (responseObject.code == 0) {
        final StateAPI state = Success(responseObject);
        debugPrint("state: $state");
        return state;
      } else {
        Fluttertoast.showToast(msg: responseObject.message);
        return Fail(errorMessage: responseObject.message);
      }
    } catch (e, stackTrace) {
      const errorMessage = "알 수 없는 오류가 발생했습니다.";
      debugPrint("[$runtimeType] error: $e\n$stackTrace");
      Fluttertoast.showToast(msg: errorMessage);
      return Fail(errorMessage: errorMessage);
    }
  }
}
