import 'package:dio/dio.dart';
import 'package:edzo/core/network/api_result.dart';
import 'package:edzo/core/network/error_handler.dart';
import 'package:edzo/core/network/main_api.dart';
import 'package:edzo/models/auth/register_model.dart';

class RegisterRepo {
  MainApi mainApi;

  RegisterRepo(this.mainApi);

  Future<ApiResult> register(RegisterModel registerModel) async {
    try {
      await mainApi.register(registerModel);
      return ApiResult(
        data: null,
        status: true,
        message: "تم تسجيل الدخول بنجاح",
      );
    }on DioException catch (e) {
      return ApiResult(
        data: null,
        status: false,
        message: e.response?.data["message"] ?? "خطاء في تسجيل الدخول",
        error: e,
        errorHandler: ErrorHandler.fromJson(e.response?.data),
      );
    }
  }
}