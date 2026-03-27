import 'package:edzo/core/constance/app_router_keys.dart';
import 'package:edzo/core/helpers/deep_link_helper.dart';
import 'package:edzo/core/helpers/device_info.dart';
import 'package:edzo/core/helpers/app_form_validator.dart';
import 'package:edzo/models/auth/login_model.dart';
import 'package:edzo/repos/auth/email_verification_repo.dart';
import 'package:edzo/repos/auth/phone_verification_repo.dart';
import 'package:edzo/repos/auth/login_repo.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  RxBool showPassword = false.obs;

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  RxBool isLoading = false.obs;
  RxBool changeUidLoading = false.obs;

  LoginRepo loginRepo = Get.find<LoginRepo>();

  EmailVerificationRepo emailVerificationRepo =
      Get.find<EmailVerificationRepo>();

  void toggleShowPassword() {
    showPassword.value = !showPassword.value;
  }

  Future<void> login() async {
    isLoading.value = true;
    String? deviceId = await DeviceInfo.getDeviceId();
    print(deviceId);

    String input = emailController.text.trim();
    bool isEmail = AppFormValidator.isEmailValid(input);

    final res = await loginRepo.login(
      LoginModel(
        email: isEmail ? input : null,
        phone: !isEmail ? input : null,
        password: passwordController.text,
        uid: deviceId,
      ),
    );
    if (res.status) {
      Get.snackbar(
        "تم تسجيل الدخول بنجاح",
        "مرحبا بعودتك 👋",
        colorText: Colors.green.shade300,
      );
      
      // The repo already updates SessionHelper.user = res.data.data
      
      DeepLinkHelper.navigateAfterAuth();
      return;
    } else {
      if (res.data == null) {
        Get.snackbar(
          "خطأ في تسجيل الدخول",
          res.errorHandler!.getErrorsList(),
          colorText: Colors.red.shade300,
        );
        isLoading.value = false;
        return;
      }

      if (res.message == "notVerified") {
        if (isEmail) {
          final resEmail = await emailVerificationRepo.resendEmailVerification(
            input,
          );
          if (resEmail.status) {
            Get.snackbar(
              "تم ارسال الكود بنجاح",
              "يرجى التحقق من بريدك الالكتروني",
              colorText: Colors.green.shade300,
            );
            Get.toNamed(
              AppRouterKeys.emailVerificationScreen,
              arguments: {"email": input},
            );
          } else {
            Get.snackbar(
              "خطأ في ارسال الكود",
              resEmail.errorHandler!.getErrorsList(),
              colorText: Colors.red.shade300,
            );
          }
        } else {
          final resPhone = await Get.find<PhoneVerificationRepo>()
              .resendPhoneVerification(input);
          if (resPhone.status) {
            Get.snackbar(
              "تم ارسال الكود بنجاح",
              "يرجى التحقق من رسائل الهاتف",
              colorText: Colors.green.shade300,
            );
            Get.toNamed(
              AppRouterKeys.phoneVerificationScreen,
              arguments: {"phone": input},
            );
          } else {
            Get.snackbar(
              "خطأ في ارسال الكود",
              resPhone.errorHandler!.getErrorsList(),
              colorText: Colors.red.shade300,
            );
          }
        }
      }
    }
    isLoading.value = false;
  }

  void changeUid() async {
    changeUidLoading.value = true;
    String? deviceId = await DeviceInfo.getDeviceId();
    String input = emailController.text.trim();
    bool isEmail = AppFormValidator.isEmailValid(input);
    final res = await loginRepo.changeUid(
      LoginModel(
        email: isEmail ? input : null,
        phone: !isEmail ? input : null,
        password: passwordController.text,
        uid: deviceId,
      ),
    );
    if (res.status) {
      Get.back();
      Get.snackbar(
        "تم تغيير الجهاز بنجاح",
        "يرجى تسجيل الدخول",
        colorText: Colors.green.shade300,
      );
    } else {
      Get.back();
      Get.snackbar(
        "خطاء في تغيير الجهاز",
        res.errorHandler!.getErrorsList(),
        colorText: Colors.red.shade300,
      );
    }
    changeUidLoading.value = false;
  }
}
