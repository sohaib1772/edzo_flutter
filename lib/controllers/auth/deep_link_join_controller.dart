import 'package:edzo/controllers/my_subscriptions_controller.dart';
import 'package:edzo/core/constance/app_router_keys.dart';
import 'package:edzo/core/helpers/deep_link_helper.dart';
import 'package:edzo/core/helpers/session_helper.dart';
import 'package:edzo/core/network/api_result.dart';
import 'package:edzo/models/course_model.dart';
import 'package:edzo/repos/courses/courses_repo.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DeepLinkJoinController extends GetxController {
  CoursesRepo get coursesRepo => Get.find<CoursesRepo>();

  RxBool isLoading = true.obs;
  String? errorMessage;

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _handleJoin();
    });
  }

  Future<void> _handleJoin() async {
    final String? idStr = Get.parameters['id'];
    final String? code = Get.parameters['code'];

    if (idStr == null || code == null) {
      _showError("رابط غير صالح");
      return;
    }

    final int? courseId = int.tryParse(idStr);
    if (courseId == null) {
      _showError("معرف الدورة غير صحيح");
      return;
    }

    // Check if logged in
    if (SessionHelper.user == null) {
      DeepLinkHelper.setPendingJoin(courseId, code);
      Get.offAllNamed(AppRouterKeys.loginScreen);
      Get.snackbar("تنبيه", "يرجى تسجيل الدخول أولاً للانضمام للدورة");
      return;
    }

    try {
      final ApiResult res = await coursesRepo.subscribe(code, courseId);

      if (res.status) {
        Get.snackbar("بنجاح", "تم الاشتراك في الدورة بنجاح");

        // Refresh MySubscriptionsController
        if (Get.isRegistered<MySubscriptionsController>()) {
          await Get.find<MySubscriptionsController>().getCourses();
        } else {
          Get.put(MySubscriptionsController());
          await Get.find<MySubscriptionsController>().getCourses();
        }

        final CourseModel? joinedCourse = Get.find<MySubscriptionsController>()
            .courses
            .firstWhereOrNull((element) => element.id == courseId);

        if (joinedCourse != null) {
          Get.offAllNamed(
            AppRouterKeys.courseScreen,
            arguments: {'courseModel': joinedCourse, 'fromDeepLink': true},
          );
        } else {
          Get.offAllNamed(AppRouterKeys.mainLayout);
        }
      } else {
        _showError(res.message);
      }
    } catch (e) {
      _showError("حدث خطأ أثناء محاولة الانضمام: $e");
    } finally {
      isLoading.value = false;
    }
  }

  void _showError(String message) {
    errorMessage = message;
    isLoading.value = false;
    Get.snackbar("خطأ", message, colorText: Colors.red);
  }
}
