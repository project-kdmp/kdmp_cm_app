import "package:dio/dio.dart";
import "package:flutter/cupertino.dart";
import "package:kdmp_cm_app/presentation/values/strings.dart";

class DioExceptions implements Exception {
  String? message;

  DioExceptions.fromDioError(DioException dioException) {
    debugPrint("${dioException.message}");
    switch (dioException.type) {
      case DioExceptionType.connectionTimeout:
        message = "서버와의 통신이 원활하지 않습니다.\n네트워크 상태를 확인해주세요.";
        break;
      case DioExceptionType.sendTimeout:
        message = "서버와의 통신이 원활하지 않습니다.\n네트워크 상태를 확인해주세요.";
        break;
      case DioExceptionType.receiveTimeout:
        message = "서버와의 통신이 원활하지 않습니다.\n네트워크 상태를 확인해주세요.";
        break;
      case DioExceptionType.badCertificate:
        message = "bad certificate";
        break;
      case DioExceptionType.badResponse:
        message = _handleError(dioException.response!.statusCode, dioException.response!.statusMessage);
        break;
      case DioExceptionType.cancel:
        message = "request cancelled";
        break;
      case DioExceptionType.connectionError:
        message = "서버와의 통신이 원활하지 않습니다.\n네트워크 상태를 확인해주세요.";
        break;
      case DioExceptionType.unknown:
        message = "unknown";
        break;
      default:
        message = dioException.message;
    }
  }

  //
  String _handleError(int? statusCode, dynamic error) {
    switch (statusCode) {
      case 500:
        return "statusCode: $statusCode\nerrorMessage: Internal server error";
      default:
        return "statusCode: $statusCode\nerrorMessage: ${error["message"]}";
    }
  }

  @override
  String toString() => "$message";
}
