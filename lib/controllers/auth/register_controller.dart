import 'package:Edzo/core/constance/app_router_keys.dart';
import 'package:Edzo/core/helpers/device_info.dart';
import 'package:Edzo/core/network/api_result.dart';
import 'package:Edzo/models/auth/register_model.dart';
import 'package:Edzo/repos/auth/register_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class RegisterController extends GetxController {
  RegisterRepo registerRepo = Get.find<RegisterRepo>();

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController passwordConfirmationController =
      TextEditingController();

  RxBool showPassword = false.obs;
  RxBool isLoading = false.obs;

  void toggleShowPassword() {
    showPassword.value = !showPassword.value;
  }

  Future<void> register() async {
    isLoading.value = true;

    String? deviceId = await DeviceInfo.getDeviceId();

    ApiResult res = await registerRepo.register(
      RegisterModel(
        name: nameController.text,
        email: emailController.text,
        password: passwordController.text,
        passwordConfirmation: passwordConfirmationController.text,
        uid: deviceId,
      ),
    );

    if (res.status) {
      Get.snackbar(
        "تم التسجيل بنجاح",
        "يرجى تأكيد بريدك الالكتروني",
        colorText: Colors.green.shade300,
      );
      Get.toNamed(AppRouterKeys.emailVerificationScreen,
          arguments: {
            'email': emailController.text,
          });
    } else {
      Get.snackbar("خطاء في التسجيل", res.errorHandler!.getErrorsList(),
          colorText: Colors.red.shade300);
    }

    isLoading.value = false;
  }
}
