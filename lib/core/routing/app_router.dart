import 'package:edzo/core/constance/app_router_keys.dart';
import 'package:edzo/core/middlewares/is_login_middleware.dart';
import 'package:edzo/core/middlewares/need_update_middleware.dart';
import 'package:edzo/views/add_course/add_course_screen.dart';
import 'package:edzo/views/auth/email_verification/email_verification_screen.dart';
import 'package:edzo/views/auth/forgot_password/forgot_password_screen.dart';
import 'package:edzo/views/auth/login/login_screen.dart';
import 'package:edzo/views/auth/register/screens/register_screen.dart';
import 'package:edzo/views/cource/course_screen.dart';
import 'package:edzo/views/course_codes/course_codes_screen.dart';
import 'package:edzo/views/edit_course/course_videos_list_screen.dart';
import 'package:edzo/views/edit_course/edit_course_screen.dart';
import 'package:edzo/views/edit_course/widgets/edit_course_form_widget.dart';
import 'package:edzo/views/main_layout/main_layout_screen.dart';
import 'package:edzo/views/playlist_teacher/playlist_teacher_screen.dart';
import 'package:edzo/views/privacy/privacy_policy_screen.dart';
import 'package:edzo/views/teacher_profile/teacher_profile_screen.dart';
import 'package:edzo/views/teacher_reports/teacher_reports_screen.dart';
import 'package:edzo/views/update/update_screen.dart';
import 'package:edzo/views/video_player/video_player_screen.dart';
import 'package:get/get.dart';

class AppRouter {
  static List<GetPage> pages = [
    GetPage(
      middlewares: [IsLoginMiddleware(),NeedUpdateMiddleware()],
      name: AppRouterKeys.loginScreen, page:()=>  LoginScreen()),
    GetPage(name: AppRouterKeys.registerScreen, page: ()=> RegisterScreen()),
    GetPage(name: AppRouterKeys.updateScreen, page: ()=> UpdateScreen()),
    GetPage(name: AppRouterKeys.emailVerificationScreen, page: ()=> EmailVerificationScreen()),
    GetPage(name: AppRouterKeys.forgetPasswordScreen, page: ()=> ForgotPasswordScreen()),
    GetPage(name: AppRouterKeys.mainLayout, page: ()=> MainLayoutScreen()),
    GetPage(name: AppRouterKeys.courseScreen, page: ()=> CourseScreen()),
    GetPage(name: AppRouterKeys.addCourseScreen, page: ()=> AddCourseScreen()),
    GetPage(name: AppRouterKeys.editCourseScreen, page: ()=> EditCourseScreen()),
    GetPage(name: AppRouterKeys.videoPlayerScreen, page: ()=> VideoPlayerScreen()),
    GetPage(name: AppRouterKeys.courseCodes, page: ()=> CourseCodesScreen()),
    GetPage(name: AppRouterKeys.teacherProfileScreen, page: ()=> TeacherProfileScreen()),
    GetPage(name: AppRouterKeys.privacyPolicy, page: ()=> PolicyPage()),
    GetPage(name: AppRouterKeys.teacherReportsScreen, page: ()=> TeacherReportsScreen()),
    GetPage(name: AppRouterKeys.teacherPlaylistsScreen, page: ()=> PlaylistTeacherScreen()),
    GetPage(name: AppRouterKeys.courseVideosListScreen, page: ()=> CourseVideosListScreen()),

  ];



  
}