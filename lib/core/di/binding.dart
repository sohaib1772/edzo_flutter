import 'package:Edzo/controllers/add_course_controller.dart';
import 'package:Edzo/controllers/admin_controller.dart';
import 'package:Edzo/controllers/app_search_controller.dart';
import 'package:Edzo/controllers/auth/email_verification_controller.dart';
import 'package:Edzo/controllers/auth/forgot_password_controller.dart';
import 'package:Edzo/controllers/course_codes_controller.dart';
import 'package:Edzo/controllers/course_controller.dart';
import 'package:Edzo/controllers/edit_course_controller.dart';
import 'package:Edzo/controllers/home_controller.dart';
import 'package:Edzo/controllers/main_layout_controller.dart';
import 'package:Edzo/controllers/auth/login_controller.dart';
import 'package:Edzo/controllers/auth/register_controller.dart';
import 'package:Edzo/controllers/my_subscriptions_controller.dart';
import 'package:Edzo/controllers/teacher_controller.dart';
import 'package:Edzo/controllers/teacher_profile_controller.dart';
import 'package:Edzo/controllers/upload_video_controller.dart';

import 'package:get/get.dart';

class Binding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => LoginController(), fenix: true);
    Get.lazyPut(() => RegisterController(), fenix: true);
    Get.lazyPut(() => MainLayoutController(), fenix: true);
    Get.lazyPut(() => EmailVerificationController(), fenix: true);
    Get.lazyPut(() => ForgotPasswordController(), fenix: true);
    Get.lazyPut(() => HomeController(), fenix: true);
    Get.lazyPut(() => AppSearchController(), fenix: true);
    Get.lazyPut(() => CourseController(), fenix: true);
    Get.lazyPut(() => MySubscriptionsController(), fenix: true);
    Get.lazyPut(() => TeacherController(), fenix: true);
    Get.lazyPut(() => AddCourseController(), fenix: true);
    Get.lazyPut(() => EditCourseController(), fenix: true);
    Get.lazyPut(() => UploadVideoController(), fenix: true);
    Get.lazyPut(() => CourseCodesController(), fenix: true);
    Get.lazyPut(() => TeacherProfileController(), fenix: true);
    Get.lazyPut(() => AdminController(), fenix: true);
    
  }
}
