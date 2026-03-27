import 'package:dio/dio.dart';
import 'package:edzo/core/helpers/local_storage.dart';
import 'package:edzo/core/helpers/role_helper.dart';
import 'package:edzo/core/helpers/session_helper.dart';
import 'package:edzo/core/network/api_result.dart';
import 'package:edzo/core/network/error_handler.dart';
import 'package:edzo/core/network/main_api.dart';

class PhoneVerificationRepo {
  MainApi mainApi;

  PhoneVerificationRepo(this.mainApi);

  Future<ApiResult> phoneVerification(Map<String, dynamic> data) async {
    try {
      final res = await mainApi.phoneVerification(data);
      await LocalStorage.saveToken(res.token!);

      final userRes = await mainApi.getUser();
      await LocalStorage.saveRole(userRes.data?.role ?? "student");
      RoleHelper.setRole(userRes.data!.role!);
      SessionHelper.user = userRes.data;

      return ApiResult(
        data: res,
        status: true,
        message: "تم تأكيد رقم الهاتف بنجاح",
      );
    } on DioException catch (e) {
      return ApiResult(
        data: null,
        status: false,
        message: e.response?.data["message"] ?? "خطأ في تأكيد رقم الهاتف",
        error: e,
        errorHandler: ErrorHandler.fromJson(e.response?.data),
      );
    }
  }

  Future<ApiResult> resendPhoneVerification(String phone) async {
    try {
      await mainApi.resendPhoneVerification({"phone": phone});
      return ApiResult(
        data: null,
        status: true,
        message: "تم ارسال الكود بنجاح",
      );
    } on DioException catch (e) {
      return ApiResult(
        data: null,
        status: false,
        message: e.response?.data["message"] ?? "خطأ في ارسال الكود",
        error: e,
        errorHandler: ErrorHandler.fromJson(e.response?.data),
      );
    }
  }

  Future<ApiResult> addPhone(String phone) async {
    try {
      await mainApi.addPhone({"phone": phone});
      return ApiResult(
        data: null,
        status: true,
        message: "تم حفظ رقم الهاتف وارسال كود التفعيل بنجاح",
      );
    } on DioException catch (e) {
      return ApiResult(
        data: null,
        status: false,
        message: e.response?.data["message"] ?? "خطأ في حفظ رقم الهاتف",
        error: e,
        errorHandler: ErrorHandler.fromJson(e.response?.data),
      );
    }
  }
}
