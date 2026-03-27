import 'dart:io';

import 'package:device_preview/device_preview.dart';
import 'package:edzo/core/constance/app_router_keys.dart';
import 'package:edzo/core/di/binding.dart';
import 'package:edzo/core/routing/app_router.dart';
import 'package:edzo/core/services/app_services.dart';
import 'package:edzo/core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  await ScreenUtil.ensureScreenSize();
  await Get.putAsync(() => AppServices().init());
  runApp(MyApp());
  FlutterNativeSplash.remove();
}

class MyApp extends StatefulWidget {
  MyApp({super.key});
  static const platform = MethodChannel("flutter/secure");

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isScreenCaptured = false;

  void _handleLink(String link) {
    if (link.contains("/join")) {
      final uri = Uri.parse(link);
      final segments = uri.pathSegments;
      final joinIndex = segments.indexOf("join");
      if (joinIndex != -1 && segments.length > joinIndex + 2) {
        final id = segments[joinIndex + 1];
        final code = segments[joinIndex + 2];
        Get.offAllNamed(
          AppRouterKeys.joinCourse
              .replaceFirst(':id', id)
              .replaceFirst(':code', code),
        );
      }
    }
  }

  @override
  void initState() {
    super.initState();

    MyApp.platform.setMethodCallHandler((call) async {
      if (call.method == "onDeepLink") {
        _handleLink(call.arguments as String);
      } else if (call.method == "screenCaptured" && Platform.isIOS) {
        bool captured = call.arguments as bool;
        setState(() {
          _isScreenCaptured = captured;
        });
      }
    });

    if (Platform.isIOS) {
      // ✅ جلب الحالة عند الإقلاع
      MyApp.platform.invokeMethod("getInitialCaptureStatus").then((value) {
        if (value != null && value is bool) {
          setState(() {
            _isScreenCaptured = value;
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
      builder: (context, child) => _isScreenCaptured
          ? Container(color: Colors.black) // شاشة سوداء إذا في تسجيل
          : GetMaterialApp(
              onReady: () async {
                FlutterNativeSplash.remove();

                // Manual Deep Link Handling for Cold Start
                try {
                  final String? initialLink = await MyApp.platform.invokeMethod(
                    "getInitialLink",
                  );
                  if (initialLink != null) {
                    _handleLink(initialLink);
                  }
                } catch (e) {
                  print("Deep link error: $e");
                }
              },
              builder: (context, child) {
                return MediaQuery(
                  data: MediaQuery.of(context).copyWith(
                    textScaler: const TextScaler.linear(
                      1.0,
                    ), // منع تكبير النصوص على التابلت
                  ),
                  child: child!,
                );
              },
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
