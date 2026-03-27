import 'package:edzo/models/teachers_response_model.dart';
import 'package:edzo/repos/teacher_repo.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TeachersController extends GetxController {
  TeacherRepo teacherRepo = Get.find<TeacherRepo>();

  RxBool isLoading = false.obs;
  RxList<TeachersInfoModel> teachers = <TeachersInfoModel>[].obs;

  Future<void> getTeachers() async {
    isLoading.value = true;
    final res = await teacherRepo.getTeachers(null); // No count limit
    if (res.status) {
      teachers.assignAll(res.data?.data ?? []);
    } else {
      Get.snackbar(
        "خطأ في جلب الأساتذة",
        res.errorHandler?.getErrorsList() ?? "حدث خطأ ما",
        colorText: Colors.red.shade300,
      );
    }
    isLoading.value = false;
  }

  @override
  void onInit() {
    super.onInit();
    getTeachers();
  }
}
