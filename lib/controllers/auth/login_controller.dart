import 'package:device_info_plus/device_info_plus.dart';
import 'package:edzo/core/constance/app_router_keys.dart';
import 'package:edzo/core/helpers/device_info.dart';
import 'package:edzo/models/auth/login_model.dart';
import 'package:edzo/repos/auth/email_verification_repo.dart';
import 'package:edzo/repos/auth/login_repo.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  var showPassword = false.obs;

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
    final res = await loginRepo.login(
      LoginModel(
        email: emailController.text,
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
      Get.offAllNamed(AppRouterKeys.mainLayout);
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

      if (res.data == "notVerified") {
        final res = await emailVerificationRepo.resendEmailVerification(
          emailController.text,
        );
        if (res.status) {
          Get.snackbar(
            "تم ارسال الكود بنجاح",
            "يرجى التحقق من بريدك الالكتروني",
            colorText: Colors.green.shade300,
          );
          Get.toNamed(
            AppRouterKeys.emailVerificationScreen,
            arguments: {"email": emailController.text},
          );
        } else {
          Get.snackbar(
            "خطأ في ارسال الكود",
            res.errorHandler!.getErrorsList(),
            colorText: Colors.red.shade300,
          );
        }
      }
    }
    isLoading.value = false;
  }


  void changeUid()async{
    changeUidLoading.value = true;
    String? deviceId =await DeviceInfo.getDeviceId();
   final res = await loginRepo.changeUid(
      LoginModel(
        email: emailController.text,
        password: passwordController.text,
        uid: deviceId,
      ),
    );
    if(res.status){
       Get.back();
      Get.snackbar(
        "تم تغيير الجهاز بنجاح",
        "يرجى تسجيل الدخول",
        colorText: Colors.green.shade300,
      );
     
    }else{
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
