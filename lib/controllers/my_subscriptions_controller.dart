import 'package:Edzo/core/helpers/session_helper.dart';
import 'package:Edzo/models/course_model.dart';
import 'package:Edzo/repos/courses/courses_repo.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MySubscriptionsController extends GetxController {
  RxBool isLoading = false.obs;
  RxList<CourseModel> courses = <CourseModel>[].obs;
  CoursesRepo coursesRepo = Get.find<CoursesRepo>();

  Future<void> getCourses() async {
    if(SessionHelper.user == null ) return;

    isLoading.value = true;
    var res = await coursesRepo.getMySupscriptions();

    if (!res.status) {
      Get.snackbar(
        "خطاء في جلب الدورات المشترك بها",
        res.errorHandler!.getErrorsList(),
        colorText: Colors.red.shade300,
      );
      return;
    }

    courses.value = res.data!;

    isLoading.value = false;
  }

  @override
  void onInit() async {
    await getCourses();
    super.onInit();
  }
}
