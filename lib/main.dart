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


// متطلبات جديدة
// اضافة مدة الفيديو عند الرفع 
// نظام جابترات
// لكل فيديو مدة و لكل جابتر مجموع المدة
// لكل كورس مجموع مدة الفيديوهات و عدد الفيديواهات و عدد الطلاب المشتركين 
// حفظ اخر مكان شاهده الطالب لكل فيديو
// عرض نسبة المشاهدة في قائمة الفيديوهات

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ScreenUtil.ensureScreenSize();
  await Get.putAsync(() => AppServices().init());
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  MyApp({super.key});
  static const platform = MethodChannel("flutter/secure");

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isScreenCaptured = false;

  @override
  void initState() {
    super.initState();

    if (Platform.isIOS) {
      // ✅ جلب الحالة عند الإقلاع
      MyApp.platform.invokeMethod("getInitialCaptureStatus").then((value) {
        if (value != null && value is bool) {
          setState(() {
            _isScreenCaptured = value;
          });
        }
      });

      // ✅ متابعة التغييرات بعد الإقلاع
      MyApp.platform.setMethodCallHandler((call) async {
        if (call.method == "screenCaptured") {
          bool captured = call.arguments as bool;
          setState(() {
            _isScreenCaptured = captured;
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      child: _isScreenCaptured
          ? Container(color: Colors.black) // شاشة سوداء إذا في تسجيل
          : GetMaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Edzo',
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