import 'dart:io';

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
import 'package:url_launcher/url_launcher.dart';

class UpdateScreen extends StatelessWidget {
  UpdateScreen({super.key});

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

              if (constraints.maxWidth > 500) {
                width = 500;
              }

              return SizedBox(
                width: width,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset('assets/images/edzo_service_logo.png', height: 300.h),

                    SizedBox(height: 28.h),
                    Text(
                      'يتوفر تحديث جديد !',
                      style: TextStyle(
                        fontSize: 18.sp.clamp(18, 22),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 28.h),
                    AppTextButton(
                      title: 'تحديث الان',
                      onPressed: () async {
                        final Uri androidUrl = Uri.parse(
                          'https://play.google.com/store/apps/details?id=com.technianova.edzo',
                        );

                        final Uri iosUrl = Uri.parse(
                          'https://apps.apple.com/app/id6749455181',
                        );

                        if (Platform.isAndroid) {
                          if (await canLaunchUrl(androidUrl)) {
                            await launchUrl(
                              androidUrl,
                              mode: LaunchMode.externalApplication,
                            );
                          }
                        } else if (Platform.isIOS) {
                          if (await canLaunchUrl(iosUrl)) {
                            await launchUrl(
                              iosUrl,
                              mode: LaunchMode.externalApplication,
                            );
                          }
                        }
                      },
                    ),

                    //
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
