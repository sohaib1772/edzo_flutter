import 'package:edzo/controllers/auth/login_controller.dart';
import 'package:edzo/controllers/auth/register_controller.dart';
import 'package:edzo/core/helpers/app_form_validator.dart';
import 'package:edzo/core/widgets/app_text_button.dart';
import 'package:edzo/core/widgets/app_text_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

class RegisterForm extends StatelessWidget {
  RegisterForm({super.key});
  final controller = Get.find<RegisterController>();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        children: [
          AppTextForm(
            validator: (value) {
              if (AppFormValidator.isEmpty(value ?? ""))
                return 'الاسم الثلاثي مطلوب';
              if (!AppFormValidator.isUsernameValid(value ?? ""))
                return 'ألاسم الثلاثي يجب ان يحتوي على 3 أحرف على الأقل';
              return null;
            },
            controller: controller.nameController,
            hint: 'الاسم الثلاثي',
            prefixIcon: Icons.person_outline,
          ),
          SizedBox(height: 18.h),
          AppTextForm(
            validator: (value) {
              if (AppFormValidator.isEmpty(value ?? ""))
                return 'البريد الالكتروني مطلوب';
              if (!AppFormValidator.isEmailValid(value ?? ""))
                return 'البريد الالكتروني غير صحيح';
              return null;
            },
            controller: controller.emailController,
            hint: 'البريد الالكتروني',
            prefixIcon: Icons.email_outlined,
          ),
          SizedBox(height: 18.h),
          Obx(
            () => AppTextForm(
              validator: (value) {
                if (AppFormValidator.isEmpty(value ?? ""))
                  return 'كلمة المرور مطلوبة';
                if(!AppFormValidator.isPasswordValid(value ?? "")) return "كلمة المرور يجب ان تحتوي على رموز و ارقام و احرف \n و يجب ان تكون 8 أحرف على الأقل";
                return null;
              },
              controller: controller.passwordController,
              hint: 'كلمة المرور',
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
                  size: 24.sp.clamp(24,28),
                ),
              ),
            ),
          ),
          SizedBox(height: 18.h),
        
          Obx(
            () => AppTextButton(
              isLoading: controller.isLoading.value,
              title: 'تسجيل',
              onPressed: () async {
                if (!formKey.currentState!.validate()) return;
                await controller.register();
              },
            ),
          ),
        ],
      ),
    );
  }
}
