import 'package:edzo/controllers/auth/email_verification_controller.dart';
import 'package:edzo/controllers/auth/forgot_password_controller.dart';

import 'package:edzo/core/helpers/app_form_validator.dart';
import 'package:edzo/core/widgets/app_text_button.dart';
import 'package:edzo/core/widgets/app_text_form.dart';
import 'package:edzo/views/auth/forgot_password/widgets/send_forgot_password_code_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class ForgotPasswordForm extends StatelessWidget {
  ForgotPasswordForm({super.key});
  final controller = Get.find<ForgotPasswordController>();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        children: [
          SendForgotPasswordCodeForm(),
          SizedBox(height: 18.h),
          AppTextForm(
            validator: (value) {
              if (AppFormValidator.isEmpty(value ?? ""))
                return 'رمز التحقق مطلوب';

              return null;
            },
            controller: controller.codeController,
            hint: 'رمز التحقق',
            suffix: Obx(
              () =>
                  IconButton(
                        onPressed: () {
                          controller.getCodeFormClipboard();
                        },
                        icon: Icon(Icons.copy),
                      )
                      .animate(
                        onPlay: (acontroller) {
                          acontroller.repeat();
                        },
                      )
                      .shake(
                        hz: controller.stopAnimation.value ? 0 : 1.8,
                        duration: Duration(milliseconds: 4000),
                      ),
            ),
          ),
          SizedBox(height: 36.h),
          Obx(
            () => AppTextForm(
              validator: (value) {
                if (AppFormValidator.isEmpty(value ?? ""))
                  return 'كلمة المرور مطلوبة';
                if (!AppFormValidator.isPasswordValid(value ?? ""))
                  return "كلمة المرور يجب ان تحتوي على رموز و ارقام و احرف \n و يجب ان تكون 8 أحرف على الأقل";
                return null;
              },
              controller: controller.passwordController,
              hint: 'كلمة المرور الجديدة',
              prefixIcon: Icons.lock_outline,
              showText: !controller.showPassword.value,
              suffix: IconButton(
                onPressed: () {
                  controller.toggleShowPassword();
                },
                icon: Icon(
                  controller.showPassword.value
                      ? Icons.visibility_off_outlined
                      : Icons.remove_red_eye_outlined,
                  size: 24.sp.clamp(24, 28),
                ),
              ),
            ),
          ),
          SizedBox(height: 18.h),
          Obx(
            () => AppTextForm(
              validator: (value) {
                if (value != controller.passwordController.text)
                  return 'كلمة المرور غير متطابقة';
                return null;
              },
              controller: controller.passwordConfirmationController,
              hint: 'اعادة كلمة المرور',
              prefixIcon: Icons.lock_outline,
              showText: !controller.showPassword.value,
              suffix: IconButton(
                onPressed: () {
                  controller.toggleShowPassword();
                },
                icon: Icon(
                  controller.showPassword.value
                      ? Icons.visibility_off_outlined
                      : Icons.remove_red_eye_outlined,
                  size: 24.sp.clamp(24, 28),
                ),
              ),
            ),
          ),
         SizedBox(height: 36.h),
          Obx(
            () => AppTextButton(
              isLoading: controller.isLoading.value,
              title: 'تحقق',
              onPressed: () async {
                if (!formKey.currentState!.validate()) return;
                 controller.resetPassword();
              },
            ),
          ),
        ],
      ),
    );
  }
}
