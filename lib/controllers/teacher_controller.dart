import 'dart:io';

import 'package:dio/dio.dart';
import 'package:edzo/core/helpers/role_helper.dart';
import 'package:edzo/core/helpers/session_helper.dart';
import 'package:edzo/core/services/app_services.dart';
import 'package:edzo/models/course_model.dart';
import 'package:edzo/repos/courses/courses_repo.dart';
import 'package:edzo/repos/teacher_repo.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide MultipartFile;
import 'package:image_picker/image_picker.dart';

class TeacherController extends GetxController {
  TeacherRepo teacherRepo = Get.find();

  RxBool isLoading = false.obs;
  RxList<CourseModel> courses = <CourseModel>[].obs;
  CoursesRepo coursesRepo = Get.find();

  TextEditingController bioController = TextEditingController();
  TextEditingController telegramUrlController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  XFile? selectedImage;
  ImagePicker picker = ImagePicker();

  RxString imageUrl = "".obs;
  RxString bio = "".obs;

  RxBool isEdited = false.obs;

  void selectImage() async {
    selectedImage = await picker.pickImage(source: ImageSource.gallery);
    if (selectedImage != null) {
      isEdited.value = true;
    }
    update();
  }

  void cancelEdit() {
    bioController.text = SessionHelper.user?.teacherInfo?.bio ?? "";
    telegramUrlController.text =
        SessionHelper.user?.teacherInfo?.telegramUrl ?? "";
    nameController.text = SessionHelper.user?.name ?? "";
    selectedImage = null;
    imageUrl.value = SessionHelper.user?.teacherInfo?.image ?? "";
    isEdited.value = false;
    update();
  }

  void addTeacherInfo() async {
    isLoading.value = true;

    if (nameController.text != SessionHelper.user?.name &&
        nameController.text.isNotEmpty) {
      final nameRes = await teacherRepo.updateUserName(nameController.text);
      if (!nameRes.status) {
        isLoading.value = false;
        Get.snackbar(
          "خطاء في تحديث الاسم",
          nameRes.errorHandler!.getErrorsList(),
          colorText: Colors.red.shade300,
        );
        return;
      }
      SessionHelper.user?.name = nameController.text;
    }

    final res = await teacherRepo.addTeacherInfo(
      bioController.text,
      selectedImage?.path == null
          ? null
          : MultipartFile.fromBytes(
              File(selectedImage!.path).readAsBytesSync(),
              filename: selectedImage?.path.split('/').last,
            ),
      telegramUrlController.text,
    );
    if (!res.status) {
      isLoading.value = false;
      Get.snackbar(
        "خطاء في اضافة المعلومات",
        res.errorHandler!.getErrorsList(),
        colorText: Colors.red.shade300,
      );
      return;
    }

    Get.snackbar(
      "تم اضافة المعلومات بنجاح",
      "",
      colorText: Colors.green.shade300,
    );
    isEdited.value = false;
    SessionHelper.user?.teacherInfo?.bio = bioController.text.isEmpty
        ? SessionHelper.user?.teacherInfo?.bio
        : bioController.text;
    SessionHelper.user?.teacherInfo?.image =
        res.data?.image ?? SessionHelper.user?.teacherInfo?.image;
    isLoading.value = false;
  }

  Future<void> getCourses() async {
    if (RoleHelper.role != Role.teacher && RoleHelper.role != Role.admin)
      return;
    isLoading.value = true;
    final res = await coursesRepo.getTeacherCourses();
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
  }

  @override
  void onInit() async {
    super.onInit();
    getCourses();
    imageUrl.value = SessionHelper.user?.teacherInfo?.image ?? "";
    bio.value = SessionHelper.user?.teacherInfo?.bio ?? "";
    bioController.text = bio.value;
    telegramUrlController.text =
        SessionHelper.user?.teacherInfo?.telegramUrl ?? "";
    nameController.text = SessionHelper.user?.name ?? "";

    nameController.addListener(() {
      isEdited.value = true;
      update();
    });
    bioController.addListener(() {
      isEdited.value = true;
      update();
    });
    telegramUrlController.addListener(() {
      isEdited.value = true;
      update();
    });
  }
}
