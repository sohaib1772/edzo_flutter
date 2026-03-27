import 'package:dio/dio.dart';
import 'package:edzo/core/helpers/local_storage.dart';
import 'package:edzo/core/helpers/role_helper.dart';
import 'package:edzo/core/helpers/session_helper.dart';
import 'package:edzo/core/network/api_result.dart';
import 'package:edzo/core/network/error_handler.dart';
import 'package:edzo/core/network/main_api.dart';
import 'package:edzo/models/auth/email_verification_model.dart';

class EmailVerificationRepo {
  MainApi mainApi;

  EmailVerificationRepo(this.mainApi);

  Future<ApiResult> emailVerification(
    EmailVerificationModel emailVerificationModel,
  ) async {
    try {
      final res = await mainApi.emailVerification(emailVerificationModel);
      await LocalStorage.saveToken(res.token!);

      final userRes = await mainApi.getUser();
      await LocalStorage.saveRole(userRes.data?.role ?? "student");
      RoleHelper.setRole(userRes.data!.role!);
      SessionHelper.user = userRes.data;

      return ApiResult(
        data: res,
        status: true,
        message: "تم تسجيل الدخول بنجاح",
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

  Future<ApiResult> resendEmailVerification(String email) async {
    try {
      await mainApi.resendEmailVerification({"email": email});
      return ApiResult(
        data: null,
        status: true,
        message: "تم ارسال الكود بنجاح",
      );
    } on DioException catch (e) {
      return ApiResult(
        data: null,
        status: false,
        message: e.response?.data["message"] ?? "خطاء في ارسال الكود",
        error: e,
        errorHandler: ErrorHandler.fromJson(e.response?.data),
      );
    }
  }

  Future<ApiResult> addEmail(String email) async {
    try {
      await mainApi.addEmail({"email": email});
      return ApiResult(
        data: null,
        status: true,
        message: "تم حفظ البريد الإلكتروني بنجاح، يرجى التوجه للبريد لتأكيده",
      );
    } on DioException catch (e) {
      return ApiResult(
        data: null,
        status: false,
        message: e.response?.data["message"] ?? "خطأ في حفظ البريد الإلكتروني",
        error: e,
        errorHandler: ErrorHandler.fromJson(e.response?.data),
      );
    }
  }
}
