import 'package:edzo/core/constance/app_router_keys.dart';
import 'package:edzo/core/helpers/session_helper.dart';
import 'package:get/get.dart';

class DeepLinkHelper {
  static int? pendingCourseId;
  static String? pendingCode;

  static void setPendingJoin(int courseId, String code) {
    pendingCourseId = courseId;
    pendingCode = code;
  }

  static bool get hasPendingJoin =>
      pendingCourseId != null && pendingCode != null;

  static void clearPendingJoin() {
    pendingCourseId = null;
    pendingCode = null;
  }

  static void navigateAfterAuth() {
    final user = SessionHelper.user;
    if (user != null && user.needsPhoneVerification) {
      Get.offAllNamed(AppRouterKeys.mandatoryPhoneScreen);
      return;
    }

    if (hasPendingJoin) {
      final id = pendingCourseId;
      final code = pendingCode;
      clearPendingJoin();

      // Navigate to the deep link join screen with the parameters in the URL
      final route = AppRouterKeys.joinCourse
          .replaceFirst(':id', id.toString())
          .replaceFirst(':code', code.toString());

      Get.offAllNamed(route);
    } else {
      Get.offAllNamed(AppRouterKeys.mainLayout);
    }
  }
}
