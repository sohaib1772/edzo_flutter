import 'package:dio/dio.dart';
import 'package:edzo/core/constance/app_constance.dart';
import 'package:edzo/models/add_course_model.dart';
import 'package:edzo/models/app_settings_model.dart';
import 'package:edzo/models/auth/email_verification_model.dart';
import 'package:edzo/models/auth/login_model.dart';
import 'package:edzo/models/auth/register_model.dart';
import 'package:edzo/models/auth/reset_password_model.dart';
import 'package:edzo/models/code_model.dart';
import 'package:edzo/models/course_model.dart';
import 'package:edzo/models/playlist_model.dart';
import 'package:edzo/models/teacher_info_model.dart';
import 'package:edzo/models/teachers_response_model.dart';
import 'package:edzo/models/user_model.dart';
import 'package:edzo/models/video_model.dart';
import 'package:retrofit/retrofit.dart';

part 'main_api.g.dart';

@RestApi(baseUrl: "${AppConstance.baseUrl}/api/")
abstract class MainApi {
  factory MainApi(Dio dio, {String baseUrl}) = _MainApi;

  @POST("get-course-code/{id}")
  Future<SingleCodesResponseModel> getCourseCode(@Path("id") int id);

  @GET("app-version")
  Future<AppSettingsModel> getAppVersion();

  @POST("register")
  Future<void> register(@Body() RegisterModel registerModel);

  //email verification
  @POST("user/verify")
  Future<LoginResponseModel> emailVerification(
    @Body() EmailVerificationModel emailVerificationModel,
  );

  @POST("user/resend-verify")
  Future<void> resendEmailVerification(@Body() Map<String, dynamic> email);

  @POST("user/verify-phone")
  Future<LoginResponseModel> phoneVerification(
    @Body() Map<String, dynamic> data,
  );

  @POST("user/resend-phone")
  Future<void> resendPhoneVerification(@Body() Map<String, dynamic> phone);

  @POST("user/add-phone")
  Future<void> addPhone(@Body() Map<String, dynamic> phone);

  @POST("user/add-email")
  Future<void> addEmail(@Body() Map<String, dynamic> email);

  @POST("user/forgot-password")
  Future<void> forgotPassword(@Body() Map<String, dynamic> data);

  @POST("user/resend-forgot-password")
  Future<void> resendForgotPassword(@Body() Map<String, dynamic> data);

  @POST("user/reset-password")
  Future<void> resetPassword(@Body() ResetPasswordModel resetPasswordModel);

  @POST("user/change-uid")
  Future<LoginResponseModel> changeUid(@Body() LoginModel loginModel);

  @GET("user/search")
  Future<UsersResponseModel> searchUser(@Query("name") String name);

  @POST("user/set-role")
  Future<void> setUserRole(@Body() Map<String, dynamic> data);

  @GET("teachers")
  Future<TeachersResponseModel> getTeachers(@Query("count") int? count);

  @GET("admin/teachers")
  Future<TeachersResponseModel> getAdminTeachers();

  @POST("user/pin-teacher")
  Future<void> pinTeacher(@Body() Map<String, dynamic> data);

  @GET("teachers/pinned")
  Future<TeachersResponseModel> getPinnedTeachers();

  @POST("login")
  Future<LoginResponseModel> login(@Body() LoginModel loginModel);

  @DELETE("logout")
  Future<void> logout();

  @GET("/user")
  Future<UserResponseModel> getUser();

  @DELETE("/user")
  Future<UserResponseModel> deleteUser(@Body() Map<String, dynamic> data);

  @GET("bunny/video/{guid}")
  Future<dynamic> getBunnyVideoUrl(@Path("guid") String guid);

  @GET("public/bunny/video/{guid}")
  Future<dynamic> getPublicBunnyVideoUrl(@Path("guid") String guid);

  // courses

  @GET("courses")
  Future<CoursesResponseModel> getCourses();

  @GET("courses/search")
  Future<CoursesResponseModel> getCoursesByTitle(@Query("title") String title);

  @GET("courses/subscribed")
  Future<CoursesResponseModel> getSubscribedCourses();

  @GET("courses/teacher")
  Future<CoursesResponseModel> getTeacherCourses();

  @GET("courses/teacher/{id}")
  Future<CoursesResponseModel> getTeacherCoursesById(@Path("id") int id);
  // public courses

  @GET("public/courses")
  Future<CoursesResponseModel> getPublicCourses();

  @GET("public/courses/search")
  Future<CoursesResponseModel> getPublicCoursesByTitle(
    @Query("title") String title,
  );

  @GET("public/courses/{id}/videos")
  Future<VideosResponseModel> getPublicCourseVideos(@Path("id") int id);

  @GET("public/courses/teacher/{id}")
  Future<CoursesResponseModel> getPublicTeacherCoursesById(@Path("id") int id);

  @POST('courses/{id}/pin')
  Future<void> pinCourse(@Path("id") int id);

  @DELETE('courses/{id}/pin')
  Future<void> unpinCourse(@Path("id") int id);

  @POST("courses")
  @MultiPart()
  Future<AddCourseResponseModel> addCourse(
    @Part() String title,
    @Part() String description,
    @Part() int price,
    @Part() MultipartFile? image,
    @Part() String? telegramUrl,
  );
  @POST("courses/{id}")
  @MultiPart()
  Future<AddCourseResponseModel> editCourse(
    @Path("id") int id,
    @Part() String title,
    @Part() String description,
    @Part() int price,
    @Part() MultipartFile? image,
    @Part() String? telegramUrl,
  );

  //old add video
  // @POST("courses/videos")
  // @MultiPart()
  // Future<void> uploadVideo(
  //   @Part(name: "course_id") int courseId,
  //   @Part(name: "title") String title,
  //   @Part(name: "is_paid") bool isPaid,
  //   @Part(name: "file") MultipartFile file,
  //   @Part(name: "resumableChunkNumber") int chunkNumber,
  //   @Part(name: "resumableTotalChunks") int totalChunks,
  //   @Part(name: "resumableFilename") String filename,
  //   @Part(name: "resumableIdentifier") String identifier,
  //   @Part(name: "resumableTotalSize") int totalSize,
  //   @Part(name: "resumableChunkSize") int chunkSize,
  // );

  // new add video
  @POST("courses/videos")
  Future<void> uploadVideo(@Body() Map<String, dynamic> data);

  @GET("/get-video/{course_id}/{video_id}")
  Future<VideoModel> getVideo(
    @Path("course_id") int courseId,
    @Path("video_id") int videoId,
  );

  @GET("public/get-video/{course_id}/{video_id}")
  Future<VideoModel> getPublicVideo(
    @Path("course_id") int courseId,
    @Path("video_id") int videoId,
  );

  @DELETE("courses/{id}")
  Future<void> deleteCourse(@Path("id") int id);

  @GET("courses/{id}/videos")
  Future<VideosResponseModel> getCourseVideos(@Path("id") int id);

  @DELETE("courses/{id}/videos")
  Future<void> deleteCourseVideo(@Path("id") int id);

  @PUT("courses/videos/{id}")
  Future<void> updateVideoTitle(
    @Path("id") int id,
    @Body() Map<String, dynamic> data,
  );

  @GET("courses/{id}/codes")
  Future<CodesResponseModel> getCourseCodes(@Path("id") int id);

  @POST("courses/add-codes/{id}")
  Future<CodesResponseModel> addNewCodes(@Path("id") int id);

  @POST("courses/codes/{id}/mark-as-copied")
  Future<void> markAsCopied(@Path("id") int id);

  @POST("subscriptions")
  Future<CoursesResponseModel> subscribe(@Body() Map<String, dynamic> data);

  @POST("courses/bunny-video")
  Future<dynamic> prepareBunnyUpload(
    @Body() Map<String, dynamic> data, {
    @CancelRequest() CancelToken? cancelToken,
  });

  @POST("courses/vimeo-video")
  Future<dynamic> prepareVimeoUpload(
    @Body() Map<String, dynamic> data, {
    @CancelRequest() CancelToken? cancelToken,
  });

  @GET("vimeo/video/{id}")
  Future<dynamic> getVimeoVideoData(@Path("id") String id);

  @PUT("user/name")
  Future<void> updateUserName(@Body() Map<String, dynamic> data);

  @POST("/teacher-info")
  @MultiPart()
  Future<TeacherInfoModel> addTeacherInfo(
    @Part() String? bio,
    @Part() String? telegramUrl,
    @Part() MultipartFile? image,
  );

  @PUT("/teacher-info")
  @MultiPart()
  Future<void> updateTeacherInfo(
    @Part() String bio,
    @Part() MultipartFile image,
  );

  @PUT('/courses/update-video-order')
  Future<void> updateVideoOrder(@Body() Map<String, dynamic> data);

  @PUT('/courses/update-playlist-order')
  Future<void> updatePlaylistOrder(@Body() Map<String, dynamic> data);

  @POST("/playlist")
  Future<PlaylistModel> addPlaylist(@Body() AddPlaylistModel data);
  @PUT("/playlist/{id}")
  Future<PlaylistModel> updatePlaylist(
    @Path("id") int id,
    @Body() AddPlaylistModel data,
  );
  @DELETE("/playlist/{id}")
  Future<void> deletePlaylist(@Path("id") int id);

  @GET("/playlist/{course_id}")
  Future<List<PlaylistModel>> getPlaylistByCourseId(
    @Path("course_id") int courseId,
  );

  @GET("courses/pending")
  Future<VideosResponseModel> getPendingVideos();
}
