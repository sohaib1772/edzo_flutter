import 'package:dio/dio.dart';
import 'package:Edzo/core/helpers/local_storage.dart';
import 'package:Edzo/core/helpers/role_helper.dart';
import 'package:Edzo/core/helpers/session_helper.dart';
import 'package:Edzo/core/network/api_result.dart';
import 'package:Edzo/core/network/error_handler.dart';
import 'package:Edzo/core/network/main_api.dart';
import 'package:Edzo/core/services/app_services.dart';
import 'package:Edzo/models/auth/login_model.dart';
import 'package:Edzo/models/user_model.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class LoginRepo {
  MainApi mainApi;
  LoginRepo(this.mainApi);

  Future<ApiResult> login(LoginModel loginModel) async {
    try {
      final res = await mainApi.login(loginModel);

      await LocalStorage.saveToken(res.token!);
      RoleHelper.setRole(res.data!.role!);
      SessionHelper.user = res.data;
      return ApiResult(
        data: res,
        status: true,
        message: "تم تسجيل الدخول بنجاح",
      );
    } on DioException catch (e) {
      if (e.response?.statusCode == 401 &&
          e.response?.data["email_status"] == "false") {
        await LocalStorage.removeToken();
        return ApiResult(
          data: "notVerified",
          status: false,
          message: e.response?.data["message"] ?? "خطأ في تسجيل الدخول",
          error: e,
          errorHandler: ErrorHandler.fromJson(e.response?.data),
        );
      }

      return ApiResult(
        data: null,
        status: false,
        message: e.response?.data["message"] ?? "خطأ في تسجيل الدخول",
        error: e,
        errorHandler: ErrorHandler.fromJson(e.response?.data),
      );
    }
  }

  Future<ApiResult> changeUid(LoginModel loginModel) async {
    try {
      final res = await mainApi.changeUid(loginModel);

      return ApiResult(
        data: res,
        status: true,
        message: "تم تغيير الجهاز بنجاح",
      );
    } on DioException catch (e) {
      return ApiResult(
        data: null,
        status: false,
        message: e.response?.data["message"] ?? "خطأ في تغيير الجهاز",
        error: e,
        errorHandler: ErrorHandler.fromJson(e.response?.data),
      );
    }
  }

  Future<ApiResult<UserModel>> getUser() async {
    try {
      final res = await mainApi.getUser();
      await LocalStorage.saveRole(res.data?.role ?? "student");
      RoleHelper.setRole(res.data!.role!);
      SessionHelper.user = res.data;
      return ApiResult(
        data: res.data,
        status: true,
        message: "تم الحصول على بيانات المستخدم بنجاح",
      );
    } on DioException catch (e) {
      return ApiResult(
        data: null,
        status: false,
        message: e.response?.data["message"] ?? "خطأ في تسجيل الدخول",
        error: e,
        errorHandler: ErrorHandler.fromJson(e.response?.data ?? {}),
      );
    }
  }

}
