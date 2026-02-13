import 'package:dio/dio.dart';

String getErrorMessage(dynamic error) {
  if (error is DioException) {
    if (error.response?.data != null) {
      final data = error.response!.data;
      if (data is Map<String, dynamic>) {
        return data['message'] ?? data['title'] ?? 'An error occurred';
      }
    }
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return 'Connection timeout. Please try again.';
      case DioExceptionType.connectionError:
        return 'No internet connection';
      case DioExceptionType.badResponse:
        return 'Server error. Please try again later.';
      default:
        return 'Network error. Please try again.';
    }
  }
  return error.toString();
}
