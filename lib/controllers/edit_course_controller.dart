import 'dart:io';
import 'package:dio/dio.dart';
import 'package:edzo/controllers/home_controller.dart';
import 'package:edzo/controllers/my_subscriptions_controller.dart';
import 'package:edzo/controllers/teacher_controller.dart';

import 'package:edzo/models/add_course_model.dart';
import 'package:edzo/models/course_model.dart';
import 'package:edzo/models/video_model.dart';
import 'package:edzo/repos/courses/courses_repo.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide MultipartFile;
import 'package:image_picker/image_picker.dart';

class EditCourseController  extends GetxController {
  RxBool isLoading = false.obs;
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController telegramUrlController = TextEditingController();
  XFile? image;
  RxString imagePath = ''.obs;
  CoursesRepo coursesRepo = Get.find<CoursesRepo>();
  RxString imageUrl = ''.obs;
  late CourseModel courseModel;
  RxBool isDelete = false.obs;
  RxBool editMode = false.obs;

  RxList<VideoModel> videos = <VideoModel>[].obs;


  @override
  void onInit() async{
    super.onInit();
   await customInit(Get.arguments['courseModel']);
  }

  Future<void> customInit(CourseModel courseModel)async {
    titleController.text = courseModel.title ?? "";
    descriptionController.text = courseModel.description ?? "";
    priceController.text = courseModel.price.toString();
    imageUrl.value = courseModel.image ?? "";
    telegramUrlController.text = courseModel.telegramUrl ?? "";
    this.courseModel = courseModel;
    await getCourseVideos();
  }

  Future<void> getCourseVideos()async{

    isLoading .value = true;

    var res = await coursesRepo.getCourseVideos(courseModel.id ?? 0);
    if(!res.status){
      isLoading .value = false;
      Get.snackbar("خطاء في جلب الدروس", res.errorHandler!.getErrorsList(),colorText: Colors.red.shade300);
      return;
    }
    videos.value = res.data ?? [];
    isLoading .value = false;

  }

  Future<void> pickImage() async {
    if(!editMode.value) return;

    image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image != null) {
      imagePath.value = image!.path;
    }
    imagePath.value = image!.path;
  }

  void editCourse() async {
    isLoading.value = true;
    final res = await coursesRepo.editCourse(
      EditCourseModel(
        id: courseModel.id ?? 0,
        title: titleController.text,
        description: descriptionController.text,
        price: int.parse(priceController.text),
        image: imagePath.value.isEmpty
            ? null
            : MultipartFile.fromBytes(
          File(imagePath.value).readAsBytesSync(),
          filename: imagePath.value.split('/').last,
        ),
        telegramUrl: telegramUrlController.text,
      ),
    );

    if (!res.status) {
      isLoading.value = false;
      Get.snackbar(
        "خطاء في تعديل الدورة",
        res.errorHandler!.getErrorsList(),
        colorText: Colors.red.shade300,
      );
    }
    Get.snackbar("تم تعديل الدورة بنجاح", "", colorText: Colors.green.shade300);
    isLoading.value = false;
  }

  void deleteCourse()async{
    isLoading.value = true;
    final res = await coursesRepo.deleteCourse(courseModel.id ?? 0);
    if (!res.status) {
      isLoading.value = false;
      Get.snackbar(
        "خطاء في حذف الدورة",
        res.errorHandler!.getErrorsList(),
        colorText: Colors.red.shade300,
      );
      return;
    }
    Get.find<TeacherController>().courses.removeWhere((element) => element.id == courseModel.id);
    Get.find<HomeController>().courses.removeWhere((element) => element.id == courseModel.id);
    Get.find<MySubscriptionsController>().courses.removeWhere((element) => element.id == courseModel.id);

    Get.back();

    isLoading.value = false;
    isDelete.value = true;

  }

  void deleteCourseVideo(int id)async{
    isLoading.value = true;
    final res = await coursesRepo.deleteCourseVideo(id);
    if (!res.status) {
      isLoading.value = false;
      Get.snackbar(
        "خطاء في حذف الفيديو",
        res.errorHandler!.getErrorsList(),
        colorText: Colors.red.shade300,
      );
      return;
    }
    Get.back();
    Get.snackbar("تم حذف الفيديو بنجاح","");
    videos.removeWhere((element) => element.id == id);
    isLoading.value = false;

  }
}
