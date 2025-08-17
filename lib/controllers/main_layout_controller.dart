import 'package:Edzo/core/constance/app_router_keys.dart';
import 'package:Edzo/core/helpers/local_storage.dart';
import 'package:Edzo/core/helpers/role_helper.dart';
import 'package:Edzo/core/helpers/session_helper.dart';
import 'package:Edzo/core/services/app_services.dart';
import 'package:Edzo/repos/auth/logout_repo.dart';
import 'package:Edzo/views/admin/admin_screen.dart';
import 'package:Edzo/views/home/home_screen.dart';
import 'package:Edzo/views/my_subscriptions/my_subscriptions_screen.dart';
import 'package:Edzo/views/search/search_screen.dart';
import 'package:Edzo/views/teacher/teacher_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MainLayoutController extends GetxController {
  LogoutRepo logoutRepo = Get.find<LogoutRepo>();
  TextEditingController deleteAccountConfirmationController =
      TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  RxBool isLoading = false.obs;

  RxInt currentScreen = 0.obs;
  RxBool isDarkMode = true.obs;

  List<BottomNavigationBarItem> teacherItems = [
    BottomNavigationBarItem(icon: Icon(Icons.home), label: 'الرئيسية'),
    BottomNavigationBarItem(icon: Icon(Icons.search), label: 'بحث'),
    BottomNavigationBarItem(icon: Icon(Icons.book), label: 'كورساتي'),
    BottomNavigationBarItem(icon: Icon(Icons.person), label: 'المعلم'),
  ];
  List<BottomNavigationBarItem> adminItems = [
    BottomNavigationBarItem(icon: Icon(Icons.home), label: 'الرئيسية'),
    BottomNavigationBarItem(icon: Icon(Icons.search), label: 'بحث'),
    BottomNavigationBarItem(icon: Icon(Icons.book), label: 'كورساتي'),
    BottomNavigationBarItem(icon: Icon(Icons.person), label: 'المعلم'),
    BottomNavigationBarItem(
      icon: Icon(Icons.admin_panel_settings),
      label: 'الادمن',
    ),
  ];
  List<BottomNavigationBarItem> studentItems = [
    BottomNavigationBarItem(icon: Icon(Icons.home), label: 'الرئيسية'),
    BottomNavigationBarItem(icon: Icon(Icons.search), label: 'بحث'),
    BottomNavigationBarItem(icon: Icon(Icons.book), label: 'كورساتي'),
  ];

  List<Widget> studentScreens = [
    HomeScreen(),
    SearchScreen(),
    MySubscriptionsScreen(),
  ];
  List<Widget> teacherScreens = [
    HomeScreen(),
    SearchScreen(),
    MySubscriptionsScreen(),
    TeacherScreen(),
  ];
  List<Widget> adminScreens = [
    HomeScreen(),
    SearchScreen(),
    MySubscriptionsScreen(),
    TeacherScreen(),
    AdminScreen(),
  ];

  RxList<BottomNavigationBarItem> items = <BottomNavigationBarItem>[].obs;
  RxList<Widget> screens = <Widget>[].obs;

  Future<void> setItems() async {
    print(RoleHelper.role);
    items.value = RoleHelper.role == Role.teacher
        ? teacherItems
        : RoleHelper.role == Role.admin
        ? adminItems
        : studentItems;
    screens.value = RoleHelper.role == Role.teacher
        ? teacherScreens
        : RoleHelper.role == Role.admin
        ? adminScreens
        : studentScreens;
  }

  @override
  void onInit() async {
    super.onInit();
    isDarkMode.value = Get.isDarkMode;
    await setItems();
  }

  void changeScreen(int index) {
    currentScreen.value = index;
  }

  String getTitle() {
    switch (currentScreen.value) {
      case 0:
        return "الرئيسية";
      case 1:
        return "بحث";
      case 2:
        return "كورساتي";
      case 3:
        return "المعلم";
      case 4:
        return "الادمن";
      default:
        return "الرئيسية";
    }
  }

  Future<void> changeTheme() async {
    Get.changeThemeMode(Get.isDarkMode ? ThemeMode.light : ThemeMode.dark);
    isDarkMode.value = !isDarkMode.value;
    await LocalStorage.saveTheme(isDarkMode.value);
  }

  Future<void> logout() async {
    isLoading.value = true;
    final res = await logoutRepo.logout();
    if (res.status) {
      Get.offAllNamed(AppRouterKeys.loginScreen);
      SessionHelper.user = null;
      RoleHelper.role = Role.student;
    } else {
      Get.snackbar(
        "خطاء في تسجيل الخروج",
        res.errorHandler!.getErrorsList(),
        colorText: Colors.red.shade300,
        backgroundColor: Colors.grey.shade900,
        onTap: (snack) {
          Get.offAllNamed(AppRouterKeys.loginScreen);
        },
      );
    }
    isLoading.value = false;
  }

  Future<void> deleteAccount() async {
    if (SessionHelper.user == null) {
      Get.offAllNamed(AppRouterKeys.loginScreen);

      return;
    }

    if (formKey.currentState!.validate()) {
      Get.back();
      isLoading.value = true;
      final res = await logoutRepo.deleteAccount(
        deleteAccountConfirmationController.text,
      );
      if (res.status) {
        Get.offAllNamed(AppRouterKeys.loginScreen);
        SessionHelper.user = null;
        RoleHelper.role = Role.student;
      } else {
        Get.snackbar(
          "خطاء في حذف الحساب",
          res.errorHandler!.getErrorsList(),
          colorText: Colors.red.shade300,
          backgroundColor: Colors.grey.shade900,
          onTap: (snack) {
            Get.offAllNamed(AppRouterKeys.loginScreen);
          },
        );
      }
      isLoading.value = false;
    }
  }
}
