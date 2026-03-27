import 'package:edzo/core/helpers/deep_link_helper.dart';
import 'package:edzo/core/helpers/session_helper.dart';
import 'package:edzo/repos/auth/phone_verification_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class PhoneVerificationController extends GetxController {
  RxBool isLoading = false.obs;
  late TextEditingController codeController;

  PhoneVerificationRepo phoneVerificationRepo =
      Get.find<PhoneVerificationRepo>();

  RxBool stopAnimation = false.obs;

  @override
  void onInit() {
    super.onInit();
    codeController = TextEditingController();
  }

  Future<void> phoneVerification() async {
    isLoading.value = true;
    final res = await phoneVerificationRepo.phoneVerification({
      "phone": Get.arguments['phone'],
      "code": codeController.text,
    });

    if (res.status) {
      Get.snackbar(
        "تم التحقق بنجاح",
        "تم التحقق من الهاتف بنجاح",
        colorText: Colors.green.shade300,
      );
      if (Get.arguments != null && (Get.arguments['from_settings'] == true || Get.arguments['mandatory'] == true)) {
        if (SessionHelper.user != null) {
          SessionHelper.user!.phone = Get.arguments['phone'];
        }
        DeepLinkHelper.navigateAfterAuth();
      } else {
        DeepLinkHelper.navigateAfterAuth();
      }
    } else {
      Get.snackbar(
        "خطاء في التحقق",
        res.errorHandler!.getErrorsList(),
        colorText: Colors.red.shade300,
      );
    }
    isLoading.value = false;
  }

  void getCodeFormClipboard() {
    Clipboard.getData(Clipboard.kTextPlain).then((value) {
      codeController.text = value!.text!;
    });

    stopAnimation.value = true;
  }

  @override
  void onClose() {
    codeController.dispose();
    super.onClose();
  }
}
