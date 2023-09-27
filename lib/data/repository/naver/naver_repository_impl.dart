import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:kdmp_cm_app/common/network/dio_exceptions.dart';
import 'package:kdmp_cm_app/data/constant/url.dart';
import 'package:kdmp_cm_app/data/model/common/bad_response.dart';
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
    const url = '$baseNaverAPIUrl$api';

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
      switch (response.statusCode) {
        case 200:
          {
            final responseObject = ReverseGeocodingResponse.fromJson(response.data);
            if (responseObject.status.code == 0) {
              final StateAPI state = Success(responseObject);
              debugPrint("state: $state");
              return state;
            } else {
              return Fail();
            }
          }
        default:
          {
            final badResponse = BadResponse.fromJson(response.data);
            final StateAPI state = Bad(badResponse);
            debugPrint("state: $state");
            return state;
          }
      }
    } on DioException catch (e) {
      try {
        if (e.response != null) {
          final badResponse = BadResponse.fromJson(e.response?.data);
          final StateAPI state = Bad(badResponse);
          debugPrint("state: $state");
          return state;
        }
        return Fail(errorMessage: DioExceptions.fromDioError(e).toString());
      } catch (e2) {
        return Fail(errorMessage: DioExceptions.fromDioError(e).toString());
      }
    }
  }

  @override
  Future<StateAPI> getAddressInfo({required String clientId, required String clientSecret, required GeocodingRequest geocodingRequest}) async {
    const api = '/map-geocode/v2/geocode';
    const url = '$baseNaverAPIUrl$api';

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
      switch (response.statusCode) {
        case 200:
          {
            final responseObject = GeocodingResponse.fromJson(response.data);
            final StateAPI state = Success(responseObject);
            debugPrint("state: $state");
            return state;
          }
        default:
          {
            final badResponse = BadResponse.fromJson(response.data);
            final StateAPI state = Bad(badResponse);
            debugPrint("state: $state");
            return state;
          }
      }
    } on DioException catch (e) {
      try {
        if (e.response != null) {
          final badResponse = BadResponse.fromJson(e.response?.data);
          final StateAPI state = Bad(badResponse);
          debugPrint("state: $state");
          return state;
        }
        return Fail(errorMessage: DioExceptions.fromDioError(e).toString());
      } catch (e2) {
        return Fail(errorMessage: DioExceptions.fromDioError(e).toString());
      }
    }
  }

  @override
  Future<StateAPI> getPrice({required String clientId, required String clientSecret, required DirectionsRequest directionsRequest}) async {
    const api = '/map-direction-15/v1/driving';
    const url = '$baseNaverAPIUrl$api';

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
      switch (response.statusCode) {
        case 200:
          {
            final responseObject = DirectionsResponse.fromJson(response.data);
            if (responseObject.code == 0) {
              final StateAPI state = Success(responseObject);
              debugPrint("state: $state");
              return state;
            } else {
              return Fail();
            }
          }
        default:
          {
            final badResponse = BadResponse.fromJson(response.data);
            final StateAPI state = Bad(badResponse);
            debugPrint("state: $state");
            return state;
          }
      }
    } on DioException catch (e) {
      try {
        if (e.response != null) {
          final badResponse = BadResponse.fromJson(e.response?.data);
          final StateAPI state = Bad(badResponse);
          debugPrint("state: $state");
          return state;
        }
        return Fail(errorMessage: DioExceptions.fromDioError(e).toString());
      } catch (e2) {
        return Fail(errorMessage: DioExceptions.fromDioError(e).toString());
      }
    }
  }
}
