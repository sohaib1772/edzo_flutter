import 'package:dio/dio.dart';
import 'package:edzo/core/network/api_result.dart';
import 'package:edzo/core/network/error_handler.dart';
import 'package:edzo/core/network/main_api.dart';
import 'package:edzo/models/auth/email_verification_model.dart';
import 'package:edzo/models/auth/reset_password_model.dart';

class ForgotPasswordRepo {
  MainApi mainApi;

  ForgotPasswordRepo(this.mainApi);


  Future<ApiResult> forgotPasswordRequest(String email) async {
    try {
      await mainApi.forgotPassword({"email": email});
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

  Future<ApiResult> resetPassword(ResetPasswordModel resetPasswordModel)async{
    try {
      await mainApi.resetPassword(resetPasswordModel);
      return ApiResult(
        data: null,
        status: true,
        message: "تم تغيير كلمة المرور بنجاح",
      );
    } on DioException catch (e) {
      return ApiResult(
        data: null,
        status: false,
        message: e.response?.data["message"] ?? "خطاء في تغيير كلمة المرور",
        error: e,
        errorHandler: ErrorHandler.fromJson(e.response?.data),
      );
    }
  }

  Future<ApiResult> resendForgotPasswordRequest(String email) async {
    try {
      await mainApi.resendForgotPassword({"email": email});
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