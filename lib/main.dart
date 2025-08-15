import 'dart:io';

import 'package:edzo/core/constance/app_router_keys.dart';
import 'package:edzo/core/di/binding.dart';
import 'package:edzo/core/routing/app_router.dart';
import 'package:edzo/core/services/app_services.dart';
import 'package:edzo/core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';


void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  await ScreenUtil.ensureScreenSize();
  await Get.putAsync(() => AppServices().init());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      SystemChannels.platform.invokeMethod('preventScreenRecording');
    }
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        
        themeMode: Get.isDarkMode ? ThemeMode.dark : ThemeMode.light,
        locale: const Locale('ar'),
        initialRoute: AppRouterKeys.loginScreen,
        initialBinding: Binding(),
        getPages: AppRouter.pages,

      ),
    );
  }
}

