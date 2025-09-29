import 'package:edzo/controllers/home_controller.dart';
import 'package:edzo/repos/courses/pin_course_repo.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class PinCourseController extends GetxController{
 PinCourseRepo pinCourseRepo = Get.find();
 RxBool isLoading = false.obs;

 void pinCourse(int id) async{
   isLoading.value = true;
   final res = await pinCourseRepo.pinCourse(id);
   if (!res.status) {
     Get.snackbar(
       "خطاء في تثبيت الدورة",
       res.errorHandler!.getErrorsList(),
       colorText: Colors.red.shade300,
     );
     isLoading.value = false;
     return;
   }
   Get.snackbar(
     "تم تثبيت الدورة بنجاح",
     "",
     colorText: Colors.green.shade300,
   );
   Get.find<HomeController>().courses.where((element) => element.id == id).first.isPin = true;
   Get.find<HomeController>().courses.refresh();
   isLoading.value = false;

 }
 void unPinCourse(int id) async{
   isLoading.value = true;
   final res = await pinCourseRepo.unpinCourse(id);
   if (!res.status) {
     Get.snackbar(
       "خطاء في تثبيت الدورة",
       res.errorHandler!.getErrorsList(),
       colorText: Colors.red.shade300,
     );
     isLoading.value = false;
     return;
   }
   Get.snackbar(
     "تم الغاء تثبيت الدورة",
     "",
     colorText: Colors.green.shade300,
   );
   Get.find<HomeController>().courses.where((element) => element.id == id).first.isPin = false;
   Get.find<HomeController>().courses.refresh();
   isLoading.value = false;
 }

}