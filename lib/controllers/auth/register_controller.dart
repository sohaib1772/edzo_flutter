import 'package:edzo/core/constance/app_router_keys.dart';
import 'package:edzo/core/helpers/device_info.dart';
import 'package:edzo/core/helpers/app_form_validator.dart';
import 'package:edzo/core/network/api_result.dart';
import 'package:edzo/models/auth/register_model.dart';
import 'package:edzo/repos/auth/register_repo.dart';
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

    String input = emailController.text.trim();
    bool isEmail = AppFormValidator.isEmailValid(input);

    ApiResult res = await registerRepo.register(
      RegisterModel(
        name: nameController.text,
        email: isEmail ? input : null,
        phone: !isEmail ? input : null,
        password: passwordController.text,
        passwordConfirmation: passwordConfirmationController.text,
        uid: deviceId,
      ),
    );

    if (res.status) {
      Get.snackbar(
        "تم التسجيل بنجاح",
        isEmail ? "يرجى تأكيد بريدك الالكتروني" : "يرجى تأكيد رقم الهاتف",
        colorText: Colors.green.shade300,
      );
      if (isEmail) {
        Get.toNamed(
          AppRouterKeys.emailVerificationScreen,
          arguments: {'email': input},
        );
      } else {
        Get.toNamed(
          AppRouterKeys.phoneVerificationScreen,
          arguments: {'phone': input},
        );
      }
    } else {
      Get.snackbar(
        "خطاء في التسجيل",
        res.errorHandler!.getErrorsList(),
        colorText: Colors.red.shade300,
      );
    }

    isLoading.value = false;
  }
}
