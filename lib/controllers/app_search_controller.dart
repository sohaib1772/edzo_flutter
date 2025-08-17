import 'package:Edzo/models/course_model.dart';
import 'package:Edzo/repos/courses/courses_repo.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_workers/utils/debouncer.dart';

class AppSearchController extends GetxController {
  var searchQuery = ''.obs;
  RxBool isLoading = false.obs;

  TextEditingController searchController = TextEditingController();

  RxList<CourseModel> courses = <CourseModel>[].obs;

  CoursesRepo coursesRepo = Get.find<CoursesRepo>();


  Debouncer debouncer = Debouncer(delay: Duration(milliseconds: 1000));



  void search() async {
    
    debouncer(() async {
    isLoading.value = true;
    var res = await coursesRepo.getCoursesByTitle(searchController.text);

    if (!res.status) {
      Get.snackbar(
        "خطاء في جلب الدورات",
        res.errorHandler!.getErrorsList(),
        colorText: Colors.red.shade300,
      );
      return;
    }

    courses.value = res.data!;
    isLoading.value = false;
    });

  }
}
