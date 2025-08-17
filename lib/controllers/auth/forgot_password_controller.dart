import 'dart:async';

import 'package:Edzo/core/constance/app_router_keys.dart';
import 'package:Edzo/models/auth/email_verification_model.dart';
import 'package:Edzo/models/auth/reset_password_model.dart';
import 'package:Edzo/repos/auth/email_verification_repo.dart';
import 'package:Edzo/repos/auth/forgot_password_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class ForgotPasswordController extends GetxController {
  ForgotPasswordRepo forgotPasswordRepo = Get.find<ForgotPasswordRepo>();

  RxBool isLoading = false.obs;
  RxBool sendCodeLoading = false.obs;
  TextEditingController codeController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController passwordConfirmationController =
      TextEditingController();

  RxBool stopAnimation = false.obs;
  RxBool showPassword = false.obs;

  RxBool canSendCode = true.obs;
  int countdown = 0;
  Timer? sendCodeTimer;

  Future<void> sendCode() async {
    if (!canSendCode.value) return;

    bool sent = await forgotPasswordRequest();
    if (!sent) {
      canSendCode.value = true;
      countdown = 0;
      sendCodeTimer?.cancel();
      return;
    }
    canSendCode.value = false;
    countdown = 60;

    sendCodeTimer?.cancel();

    sendCodeTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      countdown--;
      update();

      if (countdown == 0) {
        canSendCode.value = true;
        timer.cancel();
        update();
      }
    });
  }

  Future<bool> forgotPasswordRequest() async {
    sendCodeLoading.value = true;

    var res = await forgotPasswordRepo.forgotPasswordRequest(
      emailController.text,
    );
    if (res.status) {
      Get.snackbar(
        "تم ارسال الكود بنجاح",
        "يرجى تحقق من البريد الالكتروني",
        colorText: Colors.green.shade300,
      );
      sendCodeLoading.value = false;
      return true;
    } else {
      Get.snackbar(
        "خطاء في ارسال الكود",
        res.errorHandler!.getErrorsList(),
        colorText: Colors.red.shade300,
      );
      sendCodeLoading.value = false;
      return false;
    }
  }

  void resetPassword() async {
    isLoading.value = true;
    final res = await forgotPasswordRepo.resetPassword(
      ResetPasswordModel(
        email: emailController.text,
        code: codeController.text,
        password: passwordController.text,
        passwordConfirmation: passwordConfirmationController.text,
      ),
    );
    if(res.status) {
      Get.snackbar("تم تغيير كلمة المرور بنجاح", "يرجى تسجيل الدخول",colorText: Colors.green.shade300);
      Get.offAllNamed(AppRouterKeys.loginScreen);
    }else{
      Get.snackbar("خطاء في تغيير كلمة المرور", res.errorHandler!.getErrorsList(),colorText: Colors.red.shade300);
    }
    isLoading.value = false;
  }

  void toggleShowPassword() {
    showPassword.value = !showPassword.value;
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
