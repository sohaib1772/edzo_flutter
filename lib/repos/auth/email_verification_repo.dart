import 'package:dio/dio.dart';
import 'package:Edzo/core/network/api_result.dart';
import 'package:Edzo/core/network/error_handler.dart';
import 'package:Edzo/core/network/main_api.dart';
import 'package:Edzo/models/auth/email_verification_model.dart';

class EmailVerificationRepo {
  MainApi mainApi;

  EmailVerificationRepo(this.mainApi);


  Future<ApiResult> emailVerification(EmailVerificationModel emailVerificationModel) async {
    try {
      await mainApi.emailVerification(emailVerificationModel);
      return ApiResult(
        data: null,
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

}