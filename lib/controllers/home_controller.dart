import 'package:edzo/core/helpers/session_helper.dart';
import 'package:edzo/core/network/api_result.dart';
import 'package:edzo/models/course_model.dart';
import 'package:edzo/models/teachers_response_model.dart';
import 'package:edzo/repos/courses/courses_repo.dart';
import 'package:edzo/repos/courses/public_courses_repo.dart';
import 'package:edzo/repos/teacher_repo.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  CoursesRepo coursesRepo = Get.find<CoursesRepo>();
  PublicCoursesRepo publicCoursesRepo = Get.find<PublicCoursesRepo>();
  TeacherRepo teacherRepo = Get.find<TeacherRepo>();

  RxBool isLoading = false.obs;
  RxBool isTeachersLoading = false.obs;
  RxList<CourseModel> courses = <CourseModel>[].obs;
  RxList<TeachersInfoModel> teachers = <TeachersInfoModel>[].obs;

  Future<void> getCourses() async {
    isLoading.value = true;

    late ApiResult res;
    
    if(SessionHelper.user == null){
      res = await publicCoursesRepo.getCourses();
    }else{
      res = await coursesRepo.getCourses();
    }

    if(!res.status){
      Get.snackbar("خطاء في جلب الدورات", res.errorHandler!.getErrorsList(),colorText: Colors.red.shade300);
       isLoading.value = false;
      return;
    }

      courses.value = res.data!;
    
    isLoading.value = false;
  }

  Future<void> getTeachers() async {
    isTeachersLoading.value = true;
    final res = await teacherRepo.getPinnedTeachers();
    if (res.status) {
      teachers.assignAll(res.data?.data ?? []);
    }
    isTeachersLoading.value = false;
  }

  @override
  void onInit() async {
    super.onInit();
    await Future.wait([
      getCourses(),
      getTeachers(),
    ]);
  }
}
  
