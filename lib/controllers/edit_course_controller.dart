import 'dart:io';
import 'package:dio/dio.dart';
import 'package:edzo/controllers/home_controller.dart';
import 'package:edzo/controllers/my_subscriptions_controller.dart';
import 'package:edzo/controllers/teacher_controller.dart';
import 'package:edzo/controllers/teacher_playlist_controller.dart';

import 'package:edzo/models/add_course_model.dart';
import 'package:edzo/models/course_model.dart';
import 'package:edzo/models/video_model.dart';
import 'package:edzo/repos/courses/courses_repo.dart';
import 'package:edzo/repos/playlist/playlist_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart' hide MultipartFile;
import 'package:image_picker/image_picker.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

class EditCourseController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool isGetCodeLoading = false.obs;
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController telegramUrlController = TextEditingController();
  PlaylistRepo playlistRepo = Get.find();
  XFile? image;
  RxString imagePath = ''.obs;
  CoursesRepo coursesRepo = Get.find<CoursesRepo>();
  RxString imageUrl = ''.obs;
  late CourseModel courseModel;
  RxBool isDelete = false.obs;
  RxBool editMode = false.obs;

  RxList<VideoModel> videos = <VideoModel>[].obs;

  @override
  void onInit() async {
    super.onInit();
    await customInit(Get.arguments['courseModel']);
  }

  Future<void> customInit(CourseModel courseModel) async {
    titleController.text = courseModel.title ?? "";
    descriptionController.text = courseModel.description ?? "";
    priceController.text = courseModel.price.toString();
    imageUrl.value = courseModel.image ?? "";
    telegramUrlController.text = courseModel.telegramUrl ?? "";
    this.courseModel = courseModel;
    await getCourseVideos();
  }

  Future<void> copyCode() async {
    isGetCodeLoading.value = true;
    var res = await coursesRepo.copyCourseCode(courseModel.id ?? 0);
    if (!res.status) {
      Get.snackbar(
        "خطاء في جلب الكودات",
        res.errorHandler!.getErrorsList(),
        colorText: Colors.red.shade300,
      );
      isGetCodeLoading.value = false;
      return;
    }
    Get.snackbar(
      "تم النسخ",
      "الكود صالح لمدة ساعة",
      colorText: Colors.green.shade300,
    );
    //save to clipboard
    await Clipboard.setData(ClipboardData(text: res.data ?? ""));
    isGetCodeLoading.value = false;
  }

  Future<void> getCourseVideos() async {
    isLoading.value = true;

    var res = await coursesRepo.getCourseVideos(courseModel.id ?? 0);
    if (!res.status) {
      isLoading.value = false;
      Get.snackbar(
        "خطاء في جلب الدروس",
        res.errorHandler!.getErrorsList(),
        colorText: Colors.red.shade300,
      );
      return;
    }
    videos.value = res.data?.directVideos ?? [];
    isLoading.value = false;
  }

  Future<void> pickImage() async {
    if (!editMode.value) return;

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

  void deleteCourse() async {
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
    Get.find<TeacherController>().courses.removeWhere(
      (element) => element.id == courseModel.id,
    );
    Get.find<HomeController>().courses.removeWhere(
      (element) => element.id == courseModel.id,
    );
    Get.find<MySubscriptionsController>().courses.removeWhere(
      (element) => element.id == courseModel.id,
    );

    Get.back();

    isLoading.value = false;
    isDelete.value = true;
  }

  void deleteCourseVideo(int id, {int? courseId}) async {
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

    if (courseId != null) {
      await Get.find<TeacherPlaylistController>().getPlaylists(courseId);
      return;
    }
    Get.back();
    Get.snackbar("تم حذف الفيديو بنجاح", "", colorText: Colors.green.shade300);
    videos.removeWhere((element) => element.id == id);
    isLoading.value = false;
  }

  Future<void> updateOrder() async {
    List<Map<String, dynamic>> videosOrder = [];

    for (int itemIndex = 0; itemIndex < videos.length; itemIndex++) {
      videosOrder.add({
        "id": videos[itemIndex].id,
        "playlist_id": null, // لأن الفيديوهات هنا لا تنتمي لأي قائمة
        "order": itemIndex,
      });
    }

    final res = await playlistRepo.updateOrder(videosOrder);
    if (!res.status) {
      Get.snackbar(
        "خطأ في تحديث ترتيب الفيديوهات",
        res.errorHandler!.getErrorsList(),
        colorText: Colors.red.shade300,
      );
      return;
    }
  }
}
