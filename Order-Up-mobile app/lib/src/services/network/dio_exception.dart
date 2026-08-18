import 'package:dio/dio.dart';

class DioExceptions implements Exception {
  DioExceptions.fromDioError(DioException dioError) {
    switch (dioError.type) {
      case DioExceptionType.cancel:
        message = 'Request to API server was cancelled';
        break;
      case DioExceptionType.connectionTimeout:
        message = 'Facing slow internet connection.';
        break;
      case DioExceptionType.receiveTimeout:
        message = 'Facing slow internet connection.';
        break;
      case DioExceptionType.badResponse:
        message = _handleError(
          dioError.response?.statusCode,
          dioError.response?.data,
        );
        break;
      case DioExceptionType.sendTimeout:
        message = 'Send timeout in connection with API server';
        break;
      case DioExceptionType.unknown:
        if (dioError.message?.contains('SocketException') ?? false) {
          message = 'No internet connection';
          break;
        }
        message = 'Unexpected error occurred';
        break;
      default:
        message = 'Something went wrong';
        break;
    }
  }
  late String message;

  String _handleError(int? statusCode, dynamic error) {
    switch (statusCode) {
      case 400:
        if (error['message'] == 'Invalid Token') {
          return 'Pull down to refresh the page...';
        } else {
          return 'Bad Request';
        }
      case 401:
        return 'Unauthorized';
      case 403:
        return 'Forbidden';
      case 404:
        return error.toString();
      case 500:
        return 'Internal server error';
      case 502:
        return 'Bad gateway';
      default:
        return 'Oops something went wrong';
    }
  }

  @override
  String toString() => message;
}
