
import 'package:dio/dio.dart';
import 'package:edzo/core/network/api_result.dart';
import 'package:edzo/core/network/error_handler.dart';
import 'package:edzo/core/network/main_api.dart';
import 'package:edzo/models/teacher_info_model.dart';

class TeacherRepo {
  MainApi mainApi;
  TeacherRepo(this.mainApi);

  Future<ApiResult<TeacherInfoModel>> addTeacherInfo( String bio, MultipartFile? image,String? telegram) async{
    try {
    final res =  await mainApi.addTeacherInfo(bio, telegram ?? "", image);
      return ApiResult(
        status: true,
        message: "تم انشاء المعلومات بنجاح",

        data: res,
      );
    }on DioException catch (e) {
      return ApiResult(
        status: false,
        message: e.response?.data["message"] ?? "حدث خطاء في الانشاء الدخول",
        error: e,
        data: null,
        errorHandler: ErrorHandler.fromJson(e.response?.data ?? {}),
      );
    }
  }
  
}