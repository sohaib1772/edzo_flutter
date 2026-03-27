import 'package:edzo/core/helpers/role_helper.dart';
import 'package:edzo/models/teachers_response_model.dart';
import 'package:edzo/models/user_model.dart';
import 'package:edzo/repos/admin_repo.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_workers/utils/debouncer.dart';

class AdminController extends GetxController {
  AdminRepo adminRepo = Get.find();
  RxBool isLoading = false.obs;
  RxBool isSearchLoading = false.obs;
  RxBool isSetRoleLoading = false.obs;
  TextEditingController searchController = TextEditingController();
  RxList<UserModel> users = <UserModel>[].obs;
  Debouncer debouncer = Debouncer(delay: Duration(milliseconds: 1500));
  RxList<TeachersInfoModel> teachers = <TeachersInfoModel>[].obs;

  @override
  void onInit() async{
   await getTeachers();
    super.onInit();
  }

  Future<void> getTeachers() async {

    if(RoleHelper.role != Role.admin) return;

    isLoading.value = true;
    final res = await adminRepo.getTeachers();
    if (!res.status) {
      isLoading.value = false;
      Get.snackbar(
        "خطاء في جلب المعلمين",
        res.errorHandler!.getErrorsList(),
        colorText: Colors.red.shade300,
      );
      return;
    }
    teachers.value = res.data!;
    isLoading.value = false;

  }
 
  void userSearch() async {
    if(RoleHelper.role != Role.admin) return;
    debouncer(() async {
      isSearchLoading.value = true;
      final res = await adminRepo.getUsersByName(searchController.text);
      if (!res.status) {
        isSearchLoading.value = false;
        Get.snackbar(
          "خطاء في جلب المستخدمين",
          res.errorHandler!.getErrorsList(),
          colorText: Colors.red.shade300,
        );
        return;
      }

      users.value = res.data!;
      isSearchLoading.value = false;
    });
  }

  void setUserRole(String role, int id) async {
    if(RoleHelper.role != Role.admin) return;
    isSetRoleLoading.value = true;
    final res = await adminRepo.setUserRole(role, id);
    if (!res.status) {
      Get.snackbar(
        "خطاء في تعديل المستخدم",
        res.errorHandler!.getErrorsList(),
        colorText: Colors.red.shade300,
      );
      isSetRoleLoading.value = false;
      return;
    }
    users.where((x) => x.id == id).first.role = role;
    Get.back();
    Get.snackbar(
      "تم تعديل المستخدم بنجاح",
      "",
      colorText: Colors.green.shade300,
    );
    isSetRoleLoading.value = false;
    update();
  }

  RxBool isPinLoading = false.obs;
  Future<void> pinTeacher(int teacherId) async {
    isPinLoading.value = true;
    final res = await adminRepo.pinTeacher(teacherId);
    if (!res.status) {
      Get.snackbar(
        "خطاء في تحديث الحالة",
        res.errorHandler?.getErrorsList() ?? res.message,
        colorText: Colors.red.shade300,
      );
      isPinLoading.value = false;
      return;
    }

    // Update local state
    int index = teachers.indexWhere((t) => t.id == teacherId);
    if (index != -1) {
      teachers[index].isPin = !(teachers[index].isPin ?? false);
      teachers.refresh();
    }

    Get.snackbar(
      "تم تحديث الحالة بنجاح",
      "",
      colorText: Colors.green.shade300,
    );
    isPinLoading.value = false;
  }
}
