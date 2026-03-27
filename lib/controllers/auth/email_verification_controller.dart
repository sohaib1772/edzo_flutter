import 'package:edzo/core/helpers/deep_link_helper.dart';
import 'package:edzo/core/helpers/session_helper.dart';
import 'package:edzo/models/auth/email_verification_model.dart';
import 'package:edzo/repos/auth/email_verification_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class EmailVerificationController extends GetxController {
  RxBool isLoading = false.obs;
  late TextEditingController codeController;

  EmailVerificationRepo emailVerificationRepo =
      Get.find<EmailVerificationRepo>();

  RxBool stopAnimation = false.obs;

  @override
  void onInit() {
    super.onInit();
    codeController = TextEditingController();
  }

  Future<void> emailVerification() async {
    isLoading.value = true;
    final res = await emailVerificationRepo.emailVerification(
      EmailVerificationModel(
        email: Get.arguments['email'],
        code: codeController.text,
      ),
    );

    if (res.status) {
      Get.snackbar(
        "تم التحقق بنجاح",
        "تم تفعيل البريد بنجاح",
        colorText: Colors.green.shade300,
      );
      if (Get.arguments != null && Get.arguments['from_settings'] == true) {
        if (SessionHelper.user != null) {
          SessionHelper.user!.email = Get.arguments['email'];
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
