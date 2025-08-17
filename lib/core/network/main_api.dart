import 'package:dio/dio.dart';
import 'package:Edzo/core/constance/app_constance.dart';
import 'package:Edzo/models/add_course_model.dart';
import 'package:Edzo/models/auth/email_verification_model.dart';
import 'package:Edzo/models/auth/login_model.dart';
import 'package:Edzo/models/auth/register_model.dart';
import 'package:Edzo/models/auth/reset_password_model.dart';
import 'package:Edzo/models/code_model.dart';
import 'package:Edzo/models/course_model.dart';
import 'package:Edzo/models/teacher_info_model.dart';
import 'package:Edzo/models/teachers_response_model.dart';
import 'package:Edzo/models/user_model.dart';
import 'package:Edzo/models/video_model.dart';
import 'package:retrofit/retrofit.dart';

part 'main_api.g.dart';

@RestApi(baseUrl: "${AppConstance.baseUrl}/api/")
abstract class MainApi {
  factory MainApi(Dio dio, {String baseUrl}) = _MainApi;

  @POST("register")
  Future<void> register(@Body() RegisterModel registerModel);

  //email verification
  @POST("user/verify")
  Future<void> emailVerification(
    @Body() EmailVerificationModel emailVerificationModel,
  );

  @POST("user/resend-verify")
  Future<void> resendEmailVerification(@Body() Map<String, dynamic> email);

  @POST("user/forgot-password")
  Future<void> forgotPassword(@Body() Map<String, dynamic> email);

  @POST("user/resend-forgot-password")
  Future<void> resendForgotPassword(@Body() Map<String, dynamic> email);

  @POST("user/reset-password")
  Future<void> resetPassword(@Body() ResetPasswordModel resetPasswordModel);

  @POST("user/change-uid")
  Future<LoginResponseModel> changeUid(@Body() LoginModel loginModel);

  @GET("user/search")
  Future<UsersResponseModel> searchUser(@Query("name") String name);

  @POST("user/set-role")
  Future<void> setUserRole(@Body() Map<String, dynamic> data);

  @GET("teachers")
  Future<TeachersResponseModel> getTeachers();

  @POST("login")
  Future<LoginResponseModel> login(@Body() LoginModel loginModel);

  @DELETE("logout")
  Future<void> logout();

  @GET("/user")
  Future<UserResponseModel> getUser();

  @DELETE("/user")
  Future<UserResponseModel> deleteUser(@Body() Map<String, dynamic> data);


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
  Future<CoursesResponseModel> getTeacherCoursesById(@Path("id") int id,);
  // public courses

  @GET("public/courses")
  Future<CoursesResponseModel> getPublicCourses();

  @GET("public/courses/search")
  Future<CoursesResponseModel> getPublicCoursesByTitle(@Query("title") String title);

  @GET("public/courses/{id}/videos")
  Future<VideosResponseModel> getPublicCourseVideos(@Path("id") int id);

  @GET("public/courses/teacher/{id}")
  Future<CoursesResponseModel> getPublicTeacherCoursesById(@Path("id") int id,);



  @POST("courses")
  @MultiPart()
  Future<AddCourseResponseModel> addCourse(
    @Part() String title,
    @Part() String description,
    @Part() int price,
    @Part() MultipartFile image,
  );
  @POST("courses/{id}")
  @MultiPart()
  Future<AddCourseResponseModel> editCourse(
    @Path("id") int id,
    @Part() String title,
    @Part() String description,
    @Part() int price,
    @Part() MultipartFile image,
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

  @GET("courses/{id}/codes")
  Future<CodesResponseModel> getCourseCodes(@Path("id") int id);
  
  @POST("courses/add-codes/{id}")
  Future<CodesResponseModel> addNewCodes(@Path("id") int id);


  @POST("subscriptions")
  Future<CoursesResponseModel> subscribe(@Body() Map<String, dynamic> data);

  @POST("/teacher-info")
  @MultiPart()
  Future<TeacherInfoModel> addTeacherInfo(
    @Part() String? bio,
    @Part() MultipartFile? image,
  );

  @PUT("/teacher-info")
  @MultiPart()
  Future<void> updateTeacherInfo(
    @Part() String bio,
    @Part() MultipartFile image,
  );

  

}
