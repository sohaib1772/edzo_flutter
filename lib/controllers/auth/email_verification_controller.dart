import 'package:Edzo/core/constance/app_router_keys.dart';
import 'package:Edzo/models/auth/email_verification_model.dart';
import 'package:Edzo/repos/auth/email_verification_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class EmailVerificationController extends GetxController{
  RxBool isLoading = false.obs;
  late TextEditingController codeController;

  EmailVerificationRepo emailVerificationRepo = Get.find<EmailVerificationRepo>();

  RxBool stopAnimation = false.obs;


  @override
  void onInit() {
    super.onInit();
    codeController = TextEditingController();
  }

  Future<void> emailVerification()async{
    isLoading.value = true;
    final res = await emailVerificationRepo.emailVerification(
      EmailVerificationModel(
        email: Get.arguments['email'],
        code: codeController.text,
      ),
    );

    if (res.status) {
      Get.snackbar("تم التحقق بنجاح", "يرجى تسجيل الدخول",colorText: Colors.green.shade300);
      print("prev route ${Get.previousRoute}");
       Get.offAllNamed(AppRouterKeys.loginScreen);
    } else {
      Get.snackbar("خطاء في التحقق", res.errorHandler!.getErrorsList(),colorText: Colors.red.shade300);
    }
    isLoading.value = false;

  } 

  void getCodeFormClipboard(){
    Clipboard.getData(Clipboard.kTextPlain).then((value) {
      codeController.text = value!.text!;
    })   ;

      stopAnimation.value = true;

  }


  @override
  void onClose() {
    codeController.dispose();
    super.onClose();
  }

}