import 'package:dio/dio.dart';
import 'package:edzo/core/network/api_result.dart';
import 'package:edzo/core/network/main_api.dart';

class AppSettingsRepo {
  MainApi mainApi;

  AppSettingsRepo(this.mainApi);

  Future<ApiResult<String>> getAppVersion() async {
    try {
      var res = await mainApi.getAppVersion();
      return ApiResult<String>(
        status: true,
        message: "تم الحصول على المستخدمين بنجاح",
        data: res.version,
      );
    }on DioException catch (e) {
      
      return ApiResult(
        data: null,
        status: false,
        message: e.response?.data["message"] ?? "حدث خطأ في الاتصال",
      );
    }
  }
}