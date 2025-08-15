import 'package:dio/dio.dart';
import 'package:edzo/core/network/api_result.dart';
import 'package:edzo/core/network/error_handler.dart';
import 'package:edzo/core/network/main_api.dart';
import 'package:edzo/models/add_course_model.dart';
import 'package:edzo/models/code_model.dart';
import 'package:edzo/models/course_model.dart';
import 'package:edzo/models/upload_video_model.dart';
import 'package:edzo/models/video_model.dart';

class CoursesRepo {
  MainApi mainApi;
  CoursesRepo(this.mainApi);

  Future<ApiResult> getCourses() async {
    try {
      var res = await mainApi.getCourses();

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
      var res = await mainApi.getCoursesByTitle(title);

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

  Future<ApiResult> subscribe(String code, int courseId) async {
    try {
      var res = await mainApi.subscribe({"code": code, "course_id": courseId});

      return ApiResult(status: true, message: "تم الاشتراك بنجاح", data: null);
    } on DioException catch (e) {
      return ApiResult(
        status: false,
        message: e.response?.data["message"] ?? "حدث خطأ في الاشتراك",
        error: e,
        data: null,
        errorHandler: ErrorHandler.fromJson(e.response?.data),
      );
    }
  }

  Future<ApiResult> getMySupscriptions() async {
    try {
      var res = await mainApi.getSubscribedCourses();

      return ApiResult(
        status: true,
        message: "تم الحصول على الدورات المشترك بها",
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

  Future<ApiResult> getTeacherCourses() async {
    try {
      var res = await mainApi.getTeacherCourses();

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

  Future<ApiResult> getTeacherCoursesById(int id) async {
    try {
      var res = await mainApi.getTeacherCoursesById(id);

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

  Future<ApiResult<CourseModel>> addCourse(
    AddCourseModel addCourseModel,
  ) async {
    try {
      var res = await mainApi.addCourse(
        addCourseModel.title,
        addCourseModel.description,
        addCourseModel.price,
        addCourseModel.image,
      );
      return ApiResult<CourseModel>(
        status: true,
        message: "تم إضافة الدورة بنجاح",
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

  Future<ApiResult<CourseModel>> editCourse(
    EditCourseModel addCourseModel,
  ) async {
    try {
      var res = await mainApi.editCourse(
        addCourseModel.id,
        addCourseModel.title,
        addCourseModel.description,
        addCourseModel.price,
        addCourseModel.image,
      );
      return ApiResult<CourseModel>(
        status: true,
        message: "تم تعديل الدورة بنجاح",
        data: res.data,
      );
    } on DioException catch (e) {
      return ApiResult(
        status: false,
        message: e.response?.data["message"] ?? "حدث خطأ في تعديل الدورة",
        error: e,
        data: null,
        errorHandler: ErrorHandler.fromJson(e.response?.data),
      );
    }
  }

  Future<ApiResult> deleteCourse(int id) async {
    try {
      await mainApi.deleteCourse(id);
      return ApiResult<CourseModel>(
        status: true,
        message: "تم حذف الدورة بنجاح",
        data: null,
      );
    } on DioException catch (e) {
      return ApiResult(
        status: false,
        message: e.response?.data["message"] ?? "حدث خطأ في حذف الدورة",
        error: e,
        data: null,
        errorHandler: ErrorHandler.fromJson(e.response?.data),
      );
    }
  }

  Future<ApiResult> uploadVideo(UploadVideoModel uploadVideoModel) async {
    try {
      await mainApi.uploadVideo(
        uploadVideoModel.courseId,
        uploadVideoModel.title,
        uploadVideoModel.isPaid,
        uploadVideoModel.video,
        uploadVideoModel.chunkNumber,
        uploadVideoModel.totalChunks,
        uploadVideoModel.filename,
        uploadVideoModel.identifier,
        uploadVideoModel.totalSize,
        uploadVideoModel.chunkSize,
      );
      return ApiResult<CourseModel>(
        status: true,
        message: "تم رفع الفيديو بنجاح",
        data: null,
      );
    } on DioException catch (e) {
      return ApiResult(
        status: false,
        message: e.response?.data["message"] ?? "حدث خطاء في رفع الفيديو",
        error: e,
        data: null,
        errorHandler: ErrorHandler.fromJson(e.response?.data ?? {}),
      );
    }
  }

  Future<ApiResult<List<VideoModel>>> getCourseVideos(int id) async {
    try {
      var res = await mainApi.getCourseVideos(id);
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

  Future<ApiResult> deleteCourseVideo(int id)async{
    try {
      await mainApi.deleteCourseVideo(id);
      return ApiResult(
          status: true,
          message: "تم حذف الفيديو بنجاح",
          data: null,
      );
    } on DioException catch (e) {
      return ApiResult(
        status: false,
        message: e.response?.data["message"] ?? "حدث خطاء في حذف الفيديو",
        error: e,
        data: null,
        errorHandler: ErrorHandler.fromJson(e.response?.data ?? {}),
      );
    }
  }

  Future<ApiResult<List<CodeModel>>> getCourseCodes(int courseId)async{
    try {
      var res = await mainApi.getCourseCodes(courseId);
      return ApiResult<List<CodeModel>>(
        status: true,
        message: "تم الحصول على الكودات بنجاح",
        data: res.data,
      );
    } on DioException catch (e) {
      return ApiResult(
        status: false,
        message: e.response?.data["message"] ?? "حدث خطاء في جلب الكودات",
        error: e,
        data: null,
        errorHandler: ErrorHandler.fromJson(e.response?.data ?? {}),
      );
    }
  }
  Future<ApiResult<List<CodeModel>>> addNewCodes(int courseId)async{
    try {
      var res = await mainApi.addNewCodes(courseId);
      return ApiResult<List<CodeModel>>(
        status: true,
        message: "تم اضافة الاكواد بنجاح",
        data: res.data,
      );
    } on DioException catch (e) {
      return ApiResult(
        status: false,
        message: e.response?.data["message"] ?? "حدث خطاء في جلب الكودات",
        error: e,
        data: null,
        errorHandler: ErrorHandler.fromJson(e.response?.data ?? {}),
      );
    }
  }
}
