import 'package:edzo/core/widgets/scaffold/app_scaffold.dart';
import 'package:edzo/views/auth/email_verification/widgets/email_verification_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class EmailVerificationScreen extends StatelessWidget {
   const EmailVerificationScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      showAppBar: false,
      body: Center(
        child: LayoutBuilder(
          builder:(context, constraints){
            
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
                        'تحقق من البريد الالكتروني',
                        style: TextStyle(fontSize: 18.sp.clamp(18, 22), fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 18.h),
                      EmailVerificationForm(),
            
                      
                    ],
                  ),
          );},
        ),
      ),
    );
  }
}