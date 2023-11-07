import "package:dio/dio.dart";
import "package:flutter/cupertino.dart";

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
        message = "statusCode: ${dioException.response?.statusCode}";
        break;
      case DioExceptionType.cancel:
        message = "request cancelled";
        break;
      case DioExceptionType.connectionError:
        message = "connection error";
        break;
      case DioExceptionType.unknown:
        message = "unknown";
        break;
      default:
        message = dioException.message;
    }
  }

  @override
  String toString() => "$message";
}
