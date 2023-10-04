import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:kdmp_cm_app/common/network/dio_exceptions.dart';
import 'package:kdmp_cm_app/data/constant/url.dart';
import 'package:kdmp_cm_app/data/model/common/bad_response.dart';
import 'package:kdmp_cm_app/data/model/common/default_request.dart';
import 'package:kdmp_cm_app/data/model/common/default_response.dart';
import 'package:kdmp_cm_app/data/model/common/drv_request.dart';
import 'package:kdmp_cm_app/data/model/common/state.dart';
import 'package:kdmp_cm_app/data/model/mypage/call_detail_response.dart';
import 'package:kdmp_cm_app/data/model/mypage/call_list_request.dart';
import 'package:kdmp_cm_app/data/model/mypage/call_list_response.dart';
import 'package:kdmp_cm_app/data/model/mypage/called_detail_response.dart';
import 'package:kdmp_cm_app/data/model/mypage/called_list_request.dart';
import 'package:kdmp_cm_app/data/model/mypage/called_list_response.dart';
import 'package:kdmp_cm_app/data/model/mypage/car_add_request.dart';
import 'package:kdmp_cm_app/data/model/mypage/car_delete_request.dart';
import 'package:kdmp_cm_app/data/model/mypage/car_list_response.dart';
import 'package:kdmp_cm_app/data/model/mypage/car_modify_request.dart';
import 'package:kdmp_cm_app/data/model/mypage/place_add_request.dart';
import 'package:kdmp_cm_app/data/model/mypage/place_delete_request.dart';
import 'package:kdmp_cm_app/data/model/mypage/place_list_response.dart';
import 'package:kdmp_cm_app/data/model/mypage/place_modify_request.dart';
import 'package:kdmp_cm_app/data/model/mypage/place_response.dart';
import 'package:kdmp_cm_app/data/model/mypage/profile_detail_response.dart';
import 'package:kdmp_cm_app/domain/repository/mypage/mypage_repository.dart';

class MyPageRepositoryImpl extends MyPageRepository {
  final Dio _dio;

  MyPageRepositoryImpl(this._dio);

  @override
  Future<StateAPI> getProfileDetail({required DefaultRequest getProfileRequest}) async {
    const api = '/v1/biztotal/cm/myinfo/getMyInfo';
    const url = '$baseBizUrl$api';

    try {
      final response = await _dio.get(
        url,
        queryParameters: getProfileRequest.toJson(),
        options: Options(contentType: Headers.jsonContentType),
      );
      switch (response.statusCode) {
        case 200:
          {
            final profileDetailResponse = ProfileDetailResponse.fromJson(response.data);
            final StateAPI state = Success(profileDetailResponse);
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
  Future<StateAPI> withdrawalMember({required DefaultRequest withdrawalMemberRequest}) async {
    const api = '/v1/biztotal/cm/myinfo/cancelMbr';
    const url = '$baseBizUrl$api';

    try {
      final response = await _dio.post(
        url,
        data: withdrawalMemberRequest.toJson(),
        options: Options(contentType: Headers.jsonContentType),
      );

      switch (response.statusCode) {
        case 200:
          {
            final responseObject = DefaultResponse.fromJson(response.data);
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
  Future<StateAPI> deletePlace({required PlaceDeleteRequest placeDeleteRequest}) async {
    const api = '/v1/biztotal/cm/myinfo/delFplace';
    const url = '$baseBizUrl$api';

    try {
      final response = await _dio.post(
        url,
        data: placeDeleteRequest.toJson(),
        options: Options(contentType: Headers.jsonContentType),
      );

      switch (response.statusCode) {
        case 200:
          {
            final responseObject = DefaultResponse.fromJson(response.data);
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
  Future<StateAPI> deleteCar({required CarDeleteRequest carDeleteRequest}) async {
    const api = '/v1/biztotal/cm/myinfo/delMycar';
    const url = '$baseBizUrl$api';

    try {
      final response = await _dio.post(
        url,
        data: carDeleteRequest.toJson(),
        options: Options(contentType: Headers.jsonContentType),
      );

      switch (response.statusCode) {
        case 200:
          {
            final responseObject = DefaultResponse.fromJson(response.data);
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
  Future<StateAPI> deleteCalled({required DrvRequest calledDeleteRequest}) async {
    const api = '/v1/biztotal/cm/myinfo/delUse';
    const url = '$baseBizUrl$api';

    try {
      final response = await _dio.post(
        url,
        data: calledDeleteRequest.toJson(),
        options: Options(contentType: Headers.jsonContentType),
      );

      switch (response.statusCode) {
        case 200:
          {
            final responseObject = DefaultResponse.fromJson(response.data);
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
  Future<StateAPI> addPlace({required PlaceAddRequest placeAddRequest}) async {
    const api = '/v1/biztotal/cm/myinfo/regFplace';
    const url = '$baseBizUrl$api';

    try {
      final response = await _dio.post(
        url,
        data: placeAddRequest.toJson(),
        options: Options(contentType: Headers.jsonContentType),
      );

      switch (response.statusCode) {
        case 200:
          {
            final responseObject = PlaceResponse.fromJson(response.data);
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
  Future<StateAPI> addCar({required CarAddRequest carAddRequest}) async {
    const api = '/v1/biztotal/cm/myinfo/regMycar';
    const url = '$baseBizUrl$api';

    try {
      final response = await _dio.post(
        url,
        data: carAddRequest.toJson(),
        options: Options(contentType: Headers.jsonContentType),
      );

      switch (response.statusCode) {
        case 200:
          {
            final responseObject = DefaultResponse.fromJson(response.data);
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
  Future<StateAPI> modifyPlace({required PlaceModifyRequest placeModifyRequest}) async {
    const api = '/v1/biztotal/cm/myinfo/setFplace';
    const url = '$baseBizUrl$api';

    try {
      final response = await _dio.post(
        url,
        data: placeModifyRequest.toJson(),
        options: Options(contentType: Headers.jsonContentType),
      );

      switch (response.statusCode) {
        case 200:
          {
            final responseObject = PlaceResponse.fromJson(response.data);
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
  Future<StateAPI> modifyCar({required CarModifyRequest carModifyRequest}) async {
    const api = '/v1/biztotal/cm/myinfo/setMycar';
    const url = '$baseBizUrl$api';

    try {
      final response = await _dio.post(
        url,
        data: carModifyRequest.toJson(),
        options: Options(contentType: Headers.jsonContentType),
      );

      switch (response.statusCode) {
        case 200:
          {
            final responseObject = DefaultResponse.fromJson(response.data);
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
  Future<StateAPI> getCallDetail({required DrvRequest callDetailRequest}) async {
    const api = '/v1/biztotal/cm/myinfo/getUse';
    const url = '$baseBizUrl$api';

    try {
      final response = await _dio.get(
        url,
        queryParameters: callDetailRequest.toJson(),
        options: Options(contentType: Headers.jsonContentType),
      );
      switch (response.statusCode) {
        case 200:
          {
            final responseObject = CallDetailResponse.fromJson(response.data);
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
  Future<StateAPI> getCalledDetail({required DrvRequest calledDetailRequest}) async {
    const api = '/v1/biztotal/cm/myinfo/getUseEnd';
    const url = '$baseBizUrl$api';

    try {
      final response = await _dio.get(
        url,
        queryParameters: calledDetailRequest.toJson(),
        options: Options(contentType: Headers.jsonContentType),
      );
      switch (response.statusCode) {
        case 200:
          {
            final responseObject = CalledDetailResponse.fromJson(response.data);
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
  Future<StateAPI> getCallList({required CallListRequest callListRequest}) async {
    const api = '/v1/biztotal/cm/myinfo/listUse';
    const url = '$baseBizUrl$api';

    try {
      final response = await _dio.get(
        url,
        queryParameters: callListRequest.toJson(),
        options: Options(contentType: Headers.jsonContentType),
      );
      switch (response.statusCode) {
        case 200:
          {
            final responseObject = CallListResponse.fromJson(response.data);
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
  Future<StateAPI> getCalledList({required CalledListRequest calledListRequest}) async {
    const api = '/v1/biztotal/cm/myinfo/listUseEnd';
    const url = '$baseBizUrl$api';

    try {
      final response = await _dio.get(
        url,
        queryParameters: calledListRequest.toJson(),
        options: Options(contentType: Headers.jsonContentType),
      );
      switch (response.statusCode) {
        case 200:
          {
            final responseObject = CalledListResponse.fromJson(response.data);
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
  Future<StateAPI> getPlaceList({required DefaultRequest getPlaceListRequest}) async {
    const api = '/v1/biztotal/cm/myinfo/listFplace';
    const url = '$baseBizUrl$api';

    try {
      final response = await _dio.get(
        url,
        queryParameters: getPlaceListRequest.toJson(),
        options: Options(contentType: Headers.jsonContentType),
      );
      switch (response.statusCode) {
        case 200:
          {
            final responseObject = PlaceListResponse.fromJson(response.data);
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
  Future<StateAPI> getCarList({required DefaultRequest getCarListRequest}) async {
    const api = '/v1/biztotal/cm/myinfo/listMycar';
    const url = '$baseBizUrl$api';

    try {
      final response = await _dio.get(
        url,
        queryParameters: getCarListRequest.toJson(),
        options: Options(contentType: Headers.jsonContentType),
      );
      switch (response.statusCode) {
        case 200:
          {
            final responseObject = CarListResponse.fromJson(response.data);
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
}
