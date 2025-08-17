import 'package:Edzo/controllers/auth/login_controller.dart';
import 'package:Edzo/controllers/auth/register_controller.dart';
import 'package:Edzo/core/widgets/app_text_button.dart';
import 'package:Edzo/core/widgets/app_text_form.dart';
import 'package:Edzo/core/widgets/scaffold/app_scaffold.dart';
import 'package:Edzo/views/auth/login/widgets/login_form.dart';
import 'package:Edzo/views/auth/register/widgets/register_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class RegisterScreen extends StatelessWidget {
  RegisterScreen({super.key});
  final controller = Get.find<RegisterController>();
  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      showAppBar: false,
      body: Center(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset('assets/images/edzo_logo.png', height: 200.h),

              SizedBox(height: 28.h),
              Text(
                'انشاء حساب',
                style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 18.h),
              RegisterForm(),
              SizedBox(height: 18.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(" لديك حساب؟", style: TextStyle(fontSize: 14.sp)),
                  SizedBox(width: 10.w),
                  GestureDetector(
                    onTap: () => Get.back(),
                    child: Text(
                      "تسجيل دخول",
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 28.h),
              //terms and conditions
              Text(
                "سياسة الخصوصية و الشروط و الاحكام",
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.underline,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              SizedBox(height: 18.h),

              //
            ],
          ),
        ),
      ),
    );
  }
}
