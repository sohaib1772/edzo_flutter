import 'package:dio/dio.dart';
import 'package:edzo/core/network/api_result.dart';
import 'package:edzo/core/network/error_handler.dart';
import 'package:edzo/core/network/main_api.dart';
import 'package:edzo/models/teacher_info_model.dart';
import 'package:edzo/models/teachers_response_model.dart';

class TeacherRepo {
  MainApi mainApi;
  TeacherRepo(this.mainApi);

  Future<ApiResult<TeacherInfoModel>> addTeacherInfo(
    String bio,
    MultipartFile? image,
    String? telegram,
  ) async {
    try {
      final res = await mainApi.addTeacherInfo(bio, telegram ?? "", image);
      return ApiResult(
        status: true,
        message: "تم انشاء المعلومات بنجاح",

        data: res,
      );
    } on DioException catch (e) {
      return ApiResult(
        status: false,
        message: e.response?.data["message"] ?? "حدث خطاء في الانشاء الدخول",
        error: e,
        data: null,
        errorHandler: ErrorHandler.fromJson(e.response?.data ?? {}),
      );
    }
  }

  Future<ApiResult<void>> updateUserName(String name) async {
    try {
      await mainApi.updateUserName({"name": name});
      return ApiResult(
        data: null,
        status: true,
        message: "تم تحديث الاسم بنجاح",
      );
    } on DioException catch (e) {
      return ApiResult(
        data: null,
        status: false,
        message: e.response?.data["message"] ?? "حدث خطاء في تحديث الاسم",
        error: e,
        errorHandler: ErrorHandler.fromJson(e.response?.data ?? {}),
      );
    }
  }

  Future<ApiResult<TeachersResponseModel>> getTeachers(int? count) async {
    try {
      final res = await mainApi.getTeachers(count);
      return ApiResult(
        status: true,
        message: "تم جلب المدرسين بنجاح",
        data: res,
      );
    } on DioException catch (e) {
      return ApiResult(
        status: false,
        message: e.response?.data["message"] ?? "حدث خطاء في جلب المدرسين",
        error: e,
        data: null,
        errorHandler: ErrorHandler.fromJson(e.response?.data ?? {}),
      );
    }
  }

  Future<ApiResult<TeachersResponseModel>> getPinnedTeachers() async {
    try {
      final res = await mainApi.getPinnedTeachers();
      return ApiResult(
        status: true,
        message: "تم جلب المدرسين المثبتين بنجاح",
        data: res,
      );
    } on DioException catch (e) {
      return ApiResult(
        status: false,
        message: e.response?.data["message"] ?? "حدث خطاء في جلب المدرسين المثبتين",
        error: e,
        data: null,
        errorHandler: ErrorHandler.fromJson(e.response?.data ?? {}),
      );
    }
  }
}
