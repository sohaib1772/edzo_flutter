import 'package:dio/dio.dart';
import 'package:edzo/core/network/error_handler.dart';

class ApiResult<T> {
  final bool status;
  final String message;
  final T? data;
  final DioException? error;
  final ErrorHandler? errorHandler;

  ApiResult({
    required this.status,
    required this.message,
    required this.data,
    this.error,
    this.errorHandler,
  });

}