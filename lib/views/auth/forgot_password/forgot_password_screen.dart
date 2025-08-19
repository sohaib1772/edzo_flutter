import 'package:edzo/core/widgets/scaffold/app_scaffold.dart';
import 'package:edzo/views/auth/forgot_password/widgets/forgot_password_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class ForgotPasswordScreen extends StatelessWidget {
   const ForgotPasswordScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      showAppBar: false,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset('assets/images/edzo_logo.png', height: 200.h),
          
                    SizedBox(height: 28.h),
                    Text(
                      'نسيت كلمة المرور',
                      style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 18.h),
                    ForgotPasswordForm(),
          
                    
                  ],
                ),
        ),
      ),
    );
  }
}