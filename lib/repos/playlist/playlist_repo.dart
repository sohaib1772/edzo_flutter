import 'package:dio/dio.dart';
import 'package:edzo/core/network/api_result.dart';
import 'package:edzo/core/network/error_handler.dart';
import 'package:edzo/core/network/main_api.dart';
import 'package:edzo/models/playlist_model.dart';

class PlaylistRepo {
  MainApi mainApi;
  PlaylistRepo(this.mainApi);

  Future<ApiResult<List<PlaylistModel>>> getPlaylists(int courseId) async {
    try {
      var res = await mainApi.getPlaylistByCourseId(courseId);
      return ApiResult<List<PlaylistModel>>(
        status: true,
        message: "تم الحصول على المنشورات بنجاح",
        data: res,
      );
    } on DioException catch (e) {
      return ApiResult(
        status: false,
        message: e.response?.data["message"] ?? "حدث خطاء في جلب المنشورات",
        error: e,
        data: null,
        errorHandler: ErrorHandler.fromJson(e.response?.data ?? {}),
      );
    }
  }


  Future<ApiResult<PlaylistModel>> addPlaylist(
    AddPlaylistModel data,) async {
    try {
      var res = await mainApi.addPlaylist(data);
      return ApiResult<PlaylistModel>(
        status: true,
        message: "تم اضافة المنشور بنجاح",
        data: res,
      );
    } on DioException catch (e) {
      return ApiResult(
        status: false,
        message: e.response?.data["message"] ?? "حدث خطاء في اضافة المنشور",
        error: e,
        data: null,
        errorHandler: ErrorHandler.fromJson(e.response?.data ?? {}),
      );
    }
  }

  Future<ApiResult<PlaylistModel>> updatePlaylist(
    int id,
    AddPlaylistModel data,
  ) async {
    try {
      var res = await mainApi.updatePlaylist(id, data);
      return ApiResult<PlaylistModel>(
        status: true,
        message: "تم تعديل المنشور بنجاح",
        data: res,
      );
    } on DioException catch (e) {
      return ApiResult(
        status: false,
        message: e.response?.data["message"] ?? "حدث خطاء في تعديل المنشور",
        error: e,
        data: null,
        errorHandler: ErrorHandler.fromJson(e.response?.data ?? {}),
      );
    }
  }

  Future<ApiResult<void>> delete(int id)async{
    try {
     await  mainApi.deletePlaylist(id);
      return ApiResult<void>(
        status: true,
        message: "تم حذف المنشور بنجاح",
        data: null,
      );
  } on DioException catch (e) {
    return ApiResult(
      status: false,
      message: e.response?.data["message"] ?? "حدث خطاء في حذف المنشور",
      error: e,
      data: null,
      errorHandler: ErrorHandler.fromJson(e.response?.data ?? {}),
    );

  }
  }
}
