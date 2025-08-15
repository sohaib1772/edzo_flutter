import 'package:edzo/controllers/auth/login_controller.dart';
import 'package:edzo/core/constance/app_router_keys.dart';
import 'package:edzo/core/helpers/app_form_validator.dart';
import 'package:edzo/core/widgets/app_text_button.dart';
import 'package:edzo/core/widgets/app_text_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

class LoginForm extends StatelessWidget {
  LoginForm({super.key});
  final controller = Get.find<LoginController>();
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
                  size: 24.sp,
                ),
              ),
            ),
          ),
          SizedBox(height: 18.h),
          Align(
            alignment: Alignment.centerRight,
            child: GestureDetector(
              onTap: () => Get.toNamed(AppRouterKeys.forgetPasswordScreen),
              child: Text(
                "نسيت كلمة المرور؟",
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.underline,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
          ),
          SizedBox(height: 28.h),
          // تم الغاء الميزة و استبدالها بالجلسات 
          // من الممكن ارجاع الميزة مستقبلا
          
          GestureDetector(
            onTap: () {
              if (formKey.currentState!.validate()) {
                Get.dialog(
                  AlertDialog(
                    title: Text("تحذير"),
                    content: Text("هل تريد فتح الحساب من جهاز جديد؟"),
                    actions: [
                      Obx(
                        ()=> AppTextButton(
                          color: Theme.of(context).colorScheme.outline,
                          isLoading: controller.changeUidLoading.value,
                          title: "لا",
                          onPressed: () => Get.back(),
                        ),
                      ),
                      SizedBox(height: 16.w),
                      Obx(
                        ()=> AppTextButton(
                          color: Colors.red.shade300,
                          isLoading: controller.changeUidLoading.value,
                          onPressed: () {
                            controller.changeUid();
                          },
                          title: "نعم",
                        ),
                      ),
                    ],
                  ),
                );
              }
            },
            child: Text(
              "فتح الحساب من جهاز جديد",
              style: TextStyle(fontSize: 14.sp, color: Colors.grey.shade600),
            ),
          ),
          SizedBox(height: 28.h),
          Obx(
            () => AppTextButton(
              isLoading: controller.isLoading.value,
              title: 'تسجيل الدخول',
              onPressed: () async {
                if (!formKey.currentState!.validate()) return;
                await controller.login();
              },
            ),
          ),
        ],
      ),
    );
  }
}
