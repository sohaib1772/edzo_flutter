import 'package:dio/dio.dart';
import 'package:edzo/core/network/api_result.dart';
import 'package:edzo/core/network/error_handler.dart';
import 'package:edzo/core/network/main_api.dart';

class PinCourseRepo{
  MainApi mainApi;
  PinCourseRepo(this.mainApi);

  Future<ApiResult> pinCourse(int id) async {
    try {
      await mainApi.pinCourse(id);
      return ApiResult(
        status: true,
        message: "تم تثبيت الدورة بنجاح",
        data: null,
      );
    } on DioException catch (e) {
      return ApiResult(
        status: false,
        message: e.response?.data["message"] ?? "حدث خطأ في تثبيت الدورة",
        error: e,
        data: null,
        errorHandler: ErrorHandler.fromJson(e.response?.data),
      );
    }
  }

  Future<ApiResult> unpinCourse(int id) async {
    try {
      await mainApi.unpinCourse(id);
      return ApiResult(
        status: true,
        message: "تم إلغاء تثبيت الدورة بنجاح",
        data: null,
      );
    } on DioException catch (e) {
      return ApiResult(
        status: false,
        message: e.response?.data["message"] ?? "حدث خطأ في إلغاء تثبيت الدورة",
        error: e,
        data: null,
        errorHandler: ErrorHandler.fromJson(e.response?.data),
      );
    }
  }

}