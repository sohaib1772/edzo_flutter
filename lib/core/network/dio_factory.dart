
import 'package:dio/dio.dart';
import 'package:edzo/core/helpers/local_storage.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class DioFactory {
 static Dio? dio;


  static Future<Dio> getInstance() async{
    DioFactory.dio ??= Dio(
       
      );
    _setUpDio(DioFactory.dio!);
    return DioFactory.dio!;
  }

  static _setUpDio(Dio dio){
    dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await LocalStorage.getToken();
        options.headers['Authorization'] = 'Bearer $token';
        options.headers['Accept'] = 'application/json';
        return handler.next(options);
      },
    ),
  );
    dio.interceptors.add(PrettyDioLogger(
      requestHeader: true,
      requestBody: true,
      responseBody: true,
      responseHeader: false,
    ));
  }


}