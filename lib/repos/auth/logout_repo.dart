import 'package:dio/dio.dart';
import 'package:edzo/core/helpers/local_storage.dart';
import 'package:edzo/core/network/api_result.dart';
import 'package:edzo/core/network/error_handler.dart';
import 'package:edzo/core/network/main_api.dart';
import 'package:edzo/models/auth/login_model.dart';

class LogoutRepo {
  MainApi mainApi;
  LogoutRepo(this.mainApi);

  Future<ApiResult> logout() async {
    try {
      await mainApi.logout();
      await LocalStorage.removeToken();
      return ApiResult(
        data: null,
        status: true,
        message: "تم تسجيل الخروج بنجاح",
      );
    } on DioException catch (e) {
      return ApiResult(
        data: null,
        status: false,
        message: e.response?.data["message"] ?? "خطاء في تسجيل الدخول",
        error: e,
        errorHandler: ErrorHandler.fromJson(e.response?.data),
      );
    }
  }

  Future<ApiResult> deleteAccount(String confirmed)async{
    try {
      await mainApi.deleteUser({
        "confirmed":confirmed
      });
      await LocalStorage.removeToken();
      return ApiResult(
        data: null,
        status: true,
        message: "تم حذف الحساب بنجاح",
      );
    } on DioException catch (e) {
      return ApiResult(
        data: null,
        status: false,
        message: e.response?.data["message"] ?? "خطاء في حذف الحساب",
        error: e,
        errorHandler: ErrorHandler.fromJson(e.response?.data),
      );
    }
  }
  
}