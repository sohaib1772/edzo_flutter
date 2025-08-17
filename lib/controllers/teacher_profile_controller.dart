import 'package:Edzo/core/helpers/session_helper.dart';
import 'package:Edzo/core/network/api_result.dart';
import 'package:Edzo/models/course_model.dart';
import 'package:Edzo/models/teacher_info_model.dart';
import 'package:Edzo/repos/courses/courses_repo.dart';
import 'package:Edzo/repos/courses/public_courses_repo.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TeacherProfileController extends GetxController{

  RxBool isLoading = false.obs;
  CoursesRepo coursesRepo = Get.find();
  PublicCoursesRepo publicCoursesRepo = Get.find();
  TeacherInfoModel? teacherInfoModel = Get.arguments['teacherInfoModel'];
  String teacherName = Get.arguments['teacherName'];
  int teacherId = Get.arguments['teacherId'];
  RxList<CourseModel> courses = <CourseModel>[].obs;


  Future<void> getTeacherCourses()async{
    isLoading.value = true;

    late ApiResult res;

    if (SessionHelper.user == null) {
      res = await publicCoursesRepo.getTeacherCoursesById(teacherId);
    } else {
      res = await coursesRepo.getTeacherCoursesById(teacherId);
    }
    if(!res.status){
      Get.snackbar("خطاء في جلب الدورات", res.errorHandler!.getErrorsList(),colorText: Colors.red.shade300);
      return;
    }
    courses.value = res.data!;
    isLoading.value = false;

  }


  @override
  void onInit() async{
   await getTeacherCourses();
    super.onInit();
  }



}