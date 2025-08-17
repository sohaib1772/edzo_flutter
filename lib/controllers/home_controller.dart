import 'package:Edzo/core/helpers/session_helper.dart';
import 'package:Edzo/core/network/api_result.dart';
import 'package:Edzo/models/course_model.dart';
import 'package:Edzo/repos/courses/courses_repo.dart';
import 'package:Edzo/repos/courses/public_courses_repo.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeController extends GetxController{
  CoursesRepo coursesRepo = Get.find<CoursesRepo>();
  PublicCoursesRepo publicCoursesRepo = Get.find<PublicCoursesRepo>();

  RxBool isLoading = false.obs;
  RxList<CourseModel> courses = <CourseModel>[].obs;

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

  @override
  void onInit()async {
   await getCourses();
    super.onInit();
  }
}
  
