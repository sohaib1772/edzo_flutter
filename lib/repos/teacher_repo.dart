
import 'package:dio/dio.dart';
import 'package:Edzo/core/network/api_result.dart';
import 'package:Edzo/core/network/error_handler.dart';
import 'package:Edzo/core/network/main_api.dart';
import 'package:Edzo/models/teacher_info_model.dart';

class TeacherRepo {
  MainApi mainApi;
  TeacherRepo(this.mainApi);

  Future<ApiResult<TeacherInfoModel>> addTeacherInfo( String bio, MultipartFile? image) async{
    try {
    final res =  await mainApi.addTeacherInfo(bio, image);
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