import 'package:dio/dio.dart';
import 'package:Edzo/core/network/api_result.dart';
import 'package:Edzo/core/network/error_handler.dart';
import 'package:Edzo/core/network/main_api.dart';
import 'package:Edzo/models/add_course_model.dart';
import 'package:Edzo/models/code_model.dart';
import 'package:Edzo/models/course_model.dart';
import 'package:Edzo/models/upload_video_model.dart';
import 'package:Edzo/models/video_model.dart';

class PublicCoursesRepo {
  MainApi mainApi;
  PublicCoursesRepo(this.mainApi);

  Future<ApiResult> getCourses() async {
    try {
      var res = await mainApi.getPublicCourses();

      return ApiResult<List<CourseModel>>(
        status: true,
        message: "تم الحصول على الدورات بنجاح",
        data: res.data,
      );
    } on DioException catch (e) {
      return ApiResult(
        status: false,
        message: e.response?.data["message"] ?? "حدث خطأ في جلب الدورات",
        error: e,
        data: null,
        errorHandler: ErrorHandler.fromJson(e.response?.data),
      );
    }
  }

  Future<ApiResult> getCoursesByTitle(String title) async {
    try {
      var res = await mainApi.getPublicCoursesByTitle(title);

      return ApiResult<List<CourseModel>>(
        status: true,
        message: "تم الحصول على الدورات بنجاح",
        data: res.data,
      );
    } on DioException catch (e) {
      return ApiResult(
        status: false,
        message: e.response?.data["message"] ?? "حدث خطأ في جلب الدورات",
        error: e,
        data: null,
        errorHandler: ErrorHandler.fromJson(e.response?.data),
      );
    }
  }

 
  
  

  Future<ApiResult> getTeacherCoursesById(int id) async {
    try {
      var res = await mainApi.getPublicTeacherCoursesById(id);

      return ApiResult(
        status: true,
        message: "تم الحصول على دورات المدرس بنجاح",
        data: res.data,
      );
    } on DioException catch (e) {
      return ApiResult(
        status: false,
        message:
            e.response?.data["message"] ??
            "حدث خطاء في جلب الدورات المشترك بها",
        error: e,
        data: null,
        errorHandler: ErrorHandler.fromJson(e.response?.data),
      );
    }
  }

  

  Future<ApiResult<List<VideoModel>>> getCourseVideos(int id) async {
    try {
      var res = await mainApi.getPublicCourseVideos(id);
      return ApiResult<List<VideoModel>>(
        status: true,
        message: "تم الحصول على الفيديو بنجاح",
        data: res.data,
      );
    } on DioException catch (e) {
      return ApiResult(
        status: false,
        message: e.response?.data["message"] ?? "حدث خطاء في جلب الفيديو",
        error: e,
        data: null,
        errorHandler: ErrorHandler.fromJson(e.response?.data ?? {}),
      );
    }
  }

  Future<ApiResult> getVideo(int courseId, int videoId)async{
    try {
      var res = await mainApi.getPublicVideo(
        courseId,
        videoId,
      );
      return ApiResult<VideoModel>(
        status: true,
        message: "تم الحصول على الفيديو بنجاح",
        data: res,
      );
    } on DioException catch (e) {
      return ApiResult(
        status: false,
        message: e.response?.data["message"] ?? "حدث خطاء في جلب الفيديو",
        error: e,
        data: null,
        errorHandler: ErrorHandler.fromJson(e.response?.data ?? {}),
      );
    }
  }

}
