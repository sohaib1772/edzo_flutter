import 'package:edzo/models/code_model.dart';
import 'package:edzo/repos/courses/courses_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class CourseCodesController extends GetxController {
  RxBool isLoading = false.obs;
  CoursesRepo coursesRepo = Get.find<CoursesRepo>();

  RxList<CodeModel> codes = <CodeModel>[].obs;

  RxInt selectedIndex = 0.obs;

  Future<void> getCourseCodes() async {
    int courseId = Get.arguments['courseId'] ?? 0;
    isLoading.value = true;
    var res = await coursesRepo.getCourseCodes(courseId);
    if (!res.status) {
      Get.snackbar(
        "خطاء في جلب الكودات",
        res.errorHandler!.getErrorsList(),
        colorText: Colors.red.shade300,
      );
      return;
    }
    codes.value = res.data ?? [];
    isLoading.value = false;
  }

  void copyCode(String code, int index) async {
    selectedIndex.value = index;
    await Clipboard.setData(ClipboardData(text: code));
    Get.snackbar("تم نسخ الكود بنجاح", "", colorText: Colors.green.shade300);
  }

  @override
  onInit() async {
    await getCourseCodes();
    super.onInit();
  }

  void addNewCodes() async {
    if (codes.length >= 10) {
      Get.snackbar(
        "حدث خطاء",
        "لا يمكن اضافة كودات اكثر من 10",
        colorText: Colors.red.shade300,
      );
      return;
    }
    isLoading.value = true;
    var res = await coursesRepo.addNewCodes(Get.arguments['courseId'] ?? 0);
    if (!res.status) {
      Get.snackbar(
        "خطاء في اضافة الاكواد",
        res.errorHandler!.getErrorsList(),
        colorText: Colors.red.shade300,
      );
      return;
    }
    codes.value = res.data ?? [];
    Get.snackbar(
      "تم اضافة الاكواد",
      "تم اضافة الاكواد بنجاح",
      colorText: Colors.green.shade300,
    );

    isLoading.value = false;
  }
}
