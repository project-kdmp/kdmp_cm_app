import "package:dio/dio.dart";
import "package:flutter/cupertino.dart";

class DioExceptions implements Exception {
  String? message;

  DioExceptions.fromDioError(DioException dioException) {
    debugPrint("${dioException.message}");
    switch (dioException.type) {
      case DioExceptionType.connectionTimeout:
        message = "connection timeout";
        break;
      case DioExceptionType.sendTimeout:
        message = "send timeout";
        break;
      case DioExceptionType.receiveTimeout:
        message = "receive timeout";
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
        message = "connection error";
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
      case 401:
        return "로그인 실패";
      case 404:
        return "statusCode: $statusCode\nerrorMessage: ${error["message"]}";
      case 500:
        return "statusCode: $statusCode\nerrorMessage: Internal server error";
      default:
        return "statusCode: $statusCode\nerrorMessage: Oops something went wrongr";
    }
  }

  @override
  String toString() => "$message";
}
