import 'package:edzo/core/constance/app_constance.dart';
import 'package:edzo/core/helpers/session_helper.dart';
import 'package:edzo/models/code_model.dart';
import 'package:edzo/models/course_model.dart';
import 'package:edzo/repos/courses/courses_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';

class CourseCodesController extends GetxController {
  RxBool isLoading = false.obs;
  CoursesRepo coursesRepo = Get.find<CoursesRepo>();

  RxList<CodeModel> codes = <CodeModel>[].obs;
  RxInt selectedFilter = (-1).obs; // -1: All, 0: Unused, 1: Copied, 2: Used

  List<CodeModel> get filteredCodes {
    if (selectedFilter.value == -1) return codes;
    return codes.where((c) => c.status == selectedFilter.value).toList();
  }

  void changeFilter(int filter) {
    selectedFilter.value = filter;
  }

  RxInt selectedIndex = (-1).obs;
  late CourseModel courseModel;

  @override
  onInit() async {
    courseModel = Get.arguments;
    await getCourseCodes();
    super.onInit();
  }

  Future<void> getCourseCodes() async {
    isLoading.value = true;
    var res = await coursesRepo.getCourseCodes(courseModel.id ?? 0);
    if (!res.status) {
      Get.snackbar(
        "خطاء في جلب الكودات",
        res.errorHandler!.getErrorsList(),
        colorText: Colors.red.shade300,
      );
      isLoading.value = false;
      return;
    }
    codes.value = res.data ?? [];
    isLoading.value = false;
  }

  void copyCode(CodeModel codeModelItem, int index) async {
    selectedIndex.value = index;

    // Mark as copied in background
    if (codeModelItem.status == 0) {
      coursesRepo.markAsCopied(codeModelItem.id ?? 0).then((res) {
        if (res.status) {
          codes[index].status = 1;
          codes.refresh();
        }
      });
    }

    final String teacherName =
        courseModel.teacherName ?? SessionHelper.user?.name ?? "";
    final fullLink =
        "${AppConstance.deepLinkBaseUrl}/${courseModel.id}/${codeModelItem.code}";

    final String shareText =
        "=========Edzo=========\n\n"
        "course: ${courseModel.title}\n"
        "teacher: $teacherName\n\n"
        "price: ${courseModel.price}\n\n"
        "======================\n\n"
        "code: ${codeModelItem.code}\n\n"
        "link: $fullLink";

    await Clipboard.setData(ClipboardData(text: shareText));
    Get.snackbar(
      "تم نسخ الكود بنجاح",
      "رابط الانضمام جاهز للمشاركة",
      colorText: Colors.green.shade300,
    );
  }

  void shareCode(CodeModel codeModelItem, int index) async {
    // Mark as copied in background (same as copy logic)
    if (codeModelItem.status == 0) {
      coursesRepo.markAsCopied(codeModelItem.id ?? 0).then((res) {
        if (res.status) {
          codes[index].status = 1;
          codes.refresh();
        }
      });
    }

    final String teacherName =
        courseModel.teacherName ?? SessionHelper.user?.name ?? "";
    final fullLink =
        "${AppConstance.deepLinkBaseUrl}/${courseModel.id}/${codeModelItem.code}";

    final String shareText =
        "=========Edzo=========\n\n"
        "course: ${courseModel.title}\n"
        "teacher: $teacherName\n\n"
        "price: ${courseModel.price}\n\n"
        "======================\n\n"
        "code: ${codeModelItem.code}\n\n"
        "link: $fullLink";

    await Share.share(shareText);
  }

  void addNewCodes() async {
    isLoading.value = true;
    var res = await coursesRepo.addNewCodes(courseModel.id ?? 0);
    if (!res.status) {
      Get.snackbar(
        "خطاء في اضافة الاكواد",
        res.errorHandler!.getErrorsList(),
        colorText: Colors.red.shade300,
      );
      isLoading.value = false;
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
