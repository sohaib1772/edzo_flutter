import 'package:edzo/core/constance/app_router_keys.dart';
import 'package:edzo/core/helpers/role_helper.dart';
import 'package:edzo/core/helpers/session_helper.dart';
import 'package:edzo/core/services/app_services.dart';
import 'package:edzo/repos/auth/logout_repo.dart';
import 'package:edzo/repos/auth/phone_verification_repo.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MandatoryPhoneController extends GetxController {
  final PhoneVerificationRepo _phoneRepo = Get.find<PhoneVerificationRepo>();
  final LogoutRepo _logoutRepo = Get.find<LogoutRepo>();
  final TextEditingController phoneController = TextEditingController();
  RxBool isLoading = false.obs;

  Future<void> submitPhone() async {
    final phone = phoneController.text.trim();
    if (phone.isEmpty) {
      Get.snackbar("تنبيه", "يرجى إدخال رقم الهاتف", colorText: Colors.red);
      return;
    }

    isLoading.value = true;
    final res = await _phoneRepo.addPhone(phone);
    isLoading.value = false;

    if (res.status) {
      Get.toNamed(
        AppRouterKeys.phoneVerificationScreen,
        arguments: {"phone": phone, "mandatory": true},
      );
    } else {
      Get.snackbar(
        "خطأ",
        res.errorHandler?.getErrorsList() ?? "حدث خطأ ما",
        colorText: Colors.red,
      );
    }
  }

  Future<void> logout() async {
    isLoading.value = true;
    final res = await _logoutRepo.logout();
    if (res.status) {
      SessionHelper.user = null;
      RoleHelper.role = Role.student;
      Get.find<AppServices>().isLoggedIn = false;
      Get.offAllNamed(AppRouterKeys.loginScreen);
    } else {
      Get.snackbar(
        "خطأ",
        res.errorHandler?.getErrorsList() ?? "حدث خطأ في تسجيل الخروج",
        colorText: Colors.red,
      );
    }
    isLoading.value = false;
  }

  @override
  void onClose() {
    phoneController.dispose();
    super.onClose();
  }
}
