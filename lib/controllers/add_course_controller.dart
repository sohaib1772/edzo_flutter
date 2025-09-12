import 'dart:io';
import 'package:dio/dio.dart';
import 'package:edzo/controllers/home_controller.dart';
import 'package:edzo/controllers/my_subscriptions_controller.dart';
import 'package:edzo/controllers/teacher_controller.dart';
import 'package:edzo/core/constance/app_router_keys.dart';
import 'package:edzo/core/routing/app_router.dart';

import 'package:edzo/models/add_course_model.dart';
import 'package:edzo/repos/courses/courses_repo.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide MultipartFile;
import 'package:image_picker/image_picker.dart';

class AddCourseController extends GetxController {
  RxBool isLoading = false.obs;
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController telegramUrlController = TextEditingController();
  XFile? image;
  RxString imagePath = ''.obs;
  CoursesRepo coursesRepo = Get.find<CoursesRepo>();

  Future<void> pickImage() async {
    image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image != null) {
      imagePath.value = image!.path;
    }
    imagePath.value = image!.path;
  }

  void addCourse() async {
    isLoading.value = true;
    final res = await coursesRepo.addCourse(
      AddCourseModel(
        title: titleController.text,
        description: descriptionController.text,
        price: int.parse(priceController.text),
        image: MultipartFile.fromBytes(
          File(imagePath.value).readAsBytesSync(),
          filename: imagePath.value.split('/').last,
        ),
        telegramUrl: telegramUrlController.text,
      ),
    );

    if (!res.status) {
      isLoading.value = false;
      Get.snackbar(
        "خطاء في اضافة الدورة",
        res.errorHandler!.getErrorsList(),
        colorText: Colors.red.shade300,
      );
    }
    res.data?.subscribersCount = 0;
    Get.find<TeacherController>().courses.add(res.data!);
    Get.find<HomeController>().courses.add(res.data!);
    Get.offNamed(AppRouterKeys.editCourseScreen, arguments: {"courseModel": res.data});
    isLoading.value = false;
  }

  @override
  void onClose() {
    titleController.dispose();
    descriptionController.dispose();
    priceController.dispose();
    super.onClose();
  }
}
