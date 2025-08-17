import 'package:dio/dio.dart';
import 'package:Edzo/core/network/api_result.dart';
import 'package:Edzo/core/network/main_api.dart';
import 'package:Edzo/models/teachers_response_model.dart';
import 'package:Edzo/models/user_model.dart';

class AdminRepo{
  MainApi mainApi;

  AdminRepo(this.mainApi);


  Future<ApiResult<List<UserModel>>> getUsersByName(String name)async{
    try {
      var res = await mainApi.searchUser(name);
      return ApiResult<List<UserModel>>(
        status: true,
        message: "تم الحصول على المستخدمين بنجاح",
        data: res.data,
      );
    }on DioException catch (e) {
      
      return ApiResult(
        data: null,
        status: false,
        message: e.response?.data["message"] ?? "حدث خطاء في جلب المستخدمين",
      );
    }
  
    
  } 
  Future<ApiResult> setUserRole(String role,int id)async{
    try {
      await mainApi.setUserRole(
        {
          "role":role,
          "user_id":id
        }
      );
      return ApiResult<List<UserModel>>(
        status: true,
        message: "تم تعديل المستخدم بنجاح",
        data: null,
      );
    }on DioException catch (e) {
      
      return ApiResult(
        data: null,
        status: false,
        message: e.response?.data["message"] ?? "حدث خطاء في تحديث المستخدم",
      );
    }
  
    
  } 

  Future<ApiResult<List<TeachersInfoModel>>> getTeachers()async{
    try {
      var res = await mainApi.getTeachers();
      return ApiResult<List<TeachersInfoModel>>(
        status: true,
        message: "تم الحصول على المعلمين بنجاح",
        data: res.data,
      );
    }on DioException catch (e) {
      
      return ApiResult(
        data: null,
        status: false,
        message: e.response?.data["message"] ?? "حدث خطاء في جلب المعلمين",
      );
    }
  }
  
}