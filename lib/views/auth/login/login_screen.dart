import 'package:edzo/controllers/auth/login_controller.dart';
import 'package:edzo/core/constance/app_router_keys.dart';
import 'package:edzo/core/widgets/app_text_button.dart';
import 'package:edzo/core/widgets/app_text_form.dart';
import 'package:edzo/core/widgets/scaffold/app_scaffold.dart';
import 'package:edzo/views/auth/login/widgets/login_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';


class LoginScreen extends StatelessWidget {


  LoginScreen({super.key ,});

  LoginController controller = Get.find<LoginController>();
  
  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      showAppBar: false,
      body: Center(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: LayoutBuilder(
            
            

            builder: (context, constraints) { 
              double width = constraints.maxWidth;
             
              if(constraints.maxWidth > 500){
                width = 500;
              }

              return SizedBox(
              width: width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset('assets/images/edzo_logo.png', height: 200.h),
              
                  SizedBox(height: 28.h),
                  Text(
                    'تسجيل الدخول',
                    style: TextStyle(fontSize: 18.sp.clamp(18, 22), fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 18.h),
                  LoginForm(),
                  SizedBox(height: 18.h),
                  GestureDetector(
                    onTap: () => Get.toNamed(AppRouterKeys.mainLayout),
                    child: Text("الدخول كزائر"),
                  ),
                  SizedBox(height: 18.h),
              
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("ليس لديك حساب؟", style: TextStyle(fontSize: 14.sp.clamp(12, 18))),
                      SizedBox(width: 10.w),
                      GestureDetector(
                        onTap: () => Get.toNamed(AppRouterKeys.registerScreen),
                        child: Text(
                          " إنشاء حساب",
                          style: TextStyle(
                            fontSize: 14.sp.clamp(12, 18),
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
                      fontSize: 14.sp.clamp(12, 18),
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  SizedBox(height: 18.h),
              
                  //
                ],
              ),
            );},
          ),
        ),
      ),
    );
  }
}
