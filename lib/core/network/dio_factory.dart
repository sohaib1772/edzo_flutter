
import 'package:dio/dio.dart';
import 'package:edzo/core/helpers/local_storage.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class DioFactory {
  static Dio? dio;

  static Future<Dio> getInstance() async {
    DioFactory.dio ??= Dio(
      BaseOptions(
        connectTimeout: const Duration(seconds: 60), // وقت الاتصال
        receiveTimeout: const Duration(seconds: 60), // استقبال الرد
        sendTimeout: const Duration(seconds: 60),    // إرسال البيانات
        headers: {
          'Accept': 'application/json',
        },
      ),
    );
    _setUpDio(DioFactory.dio!);
    return DioFactory.dio!;
  }

  static _setUpDio(Dio dio) {
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await LocalStorage.getToken();
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
      ),
    );
    dio.interceptors.add(RetryInterceptor(dio: dio));
    dio.interceptors.add(
      PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseBody: true,
        responseHeader: false,
      ),
    );
  }
}
class RetryInterceptor extends Interceptor {
  final Dio dio;
  final int retries;
  final Duration retryDelay;

  RetryInterceptor({
    required this.dio,
    this.retries = 3,
    this.retryDelay = const Duration(seconds: 2),
  });

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (!_shouldRetry(err)) {
      return handler.next(err);
    }

    for (int attempt = 1; attempt <= retries; attempt++) {
      print('[RetryInterceptor] محاولة $attempt بسبب: ${err.type}');
      await Future.delayed(retryDelay);

      try {
        final response = await dio.fetch(
          err.requestOptions.copyWith(extra: Map.from(err.requestOptions.extra)),
        );
        return handler.resolve(response);
      } catch (e) {
        if (attempt == retries) {
          print('[RetryInterceptor] جميع المحاولات فشلت');
          return handler.next(err);
        }
      }
    }
  }

  bool _shouldRetry(DioException err) {
    return err.type == DioExceptionType.connectionTimeout ||
           err.type == DioExceptionType.receiveTimeout ||
           err.type == DioExceptionType.connectionError;
  }
}