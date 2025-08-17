import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:Edzo/core/helpers/local_storage.dart';
import 'package:Edzo/core/helpers/role_helper.dart';
import 'package:Edzo/core/network/api_result.dart';
import 'package:Edzo/core/network/dio_factory.dart';
import 'package:Edzo/core/network/main_api.dart';
import 'package:Edzo/models/user_model.dart';
import 'package:Edzo/repos/admin_repo.dart';
import 'package:Edzo/repos/auth/email_verification_repo.dart';
import 'package:Edzo/repos/auth/forgot_password_repo.dart';
import 'package:Edzo/repos/auth/login_repo.dart';
import 'package:Edzo/repos/auth/logout_repo.dart';
import 'package:Edzo/repos/auth/register_repo.dart';
import 'package:Edzo/repos/courses/courses_repo.dart';
import 'package:Edzo/repos/courses/public_courses_repo.dart';
import 'package:Edzo/repos/teacher_repo.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:intl/date_symbol_data_local.dart';

class AppServices extends GetxService {
  bool isLoggedIn = false;
  Role role = Role.student;
  Future<AppServices> init() async {
    await LocalStorage.init();
    await setUpApi();
    await checkToken();
    await getTheme();
    await requestStoragePermission();
    role = await LocalStorage.getRole();
    await initializeDateFormatting("ar");
    return this;
  }

  Future<void> setUpApi() async {
    Get.putAsync(() async => MainApi(await DioFactory.getInstance()));
    Get.lazyPut(() => LoginRepo(Get.find<MainApi>()), fenix: true);
    Get.lazyPut(() => LogoutRepo(Get.find<MainApi>()), fenix: true);
    Get.lazyPut(() => RegisterRepo(Get.find<MainApi>()), fenix: true);
    Get.lazyPut(() => EmailVerificationRepo(Get.find<MainApi>()), fenix: true);
    Get.lazyPut(() => ForgotPasswordRepo(Get.find<MainApi>()), fenix: true);
    Get.lazyPut(() => CoursesRepo(Get.find<MainApi>()), fenix: true);
    Get.lazyPut(() => TeacherRepo(Get.find<MainApi>()), fenix: true);
    Get.lazyPut(() => AdminRepo(Get.find<MainApi>()), fenix: true);
    Get.lazyPut(() => PublicCoursesRepo(Get.find<MainApi>()), fenix: true);
  }

  Future<void> checkToken() async {
    String? token = await LocalStorage.getToken();
    if (token == null) {
      isLoggedIn = false;
      return;
    }
    LoginRepo loginRepo = Get.find<LoginRepo>();
    ApiResult<UserModel> res = await loginRepo.getUser();
    if (res.status) {
      if (res.data?.emailVerifiedAt == null) {
        await LocalStorage.removeToken();
        isLoggedIn = false;
        return;
      }

      isLoggedIn = true;
    } else {
      await LocalStorage.removeToken();
      isLoggedIn = false;
    }
  }

  Future<void> getTheme() async {
    bool isDarkMode = await LocalStorage.getTheme();
    Get.changeThemeMode(isDarkMode ? ThemeMode.dark : ThemeMode.light);
  }

  Future<bool> requestStoragePermission() async {
    if (Platform.isAndroid) {
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      int sdkInt = androidInfo.version.sdkInt ?? 0;

      if (sdkInt >= 33) {
        // Android 13+ يستخدم صلاحيات الصور والفيديو
        var status = await Permission.photos.status;
        if (!status.isGranted) {
          var result = await Permission.photos.request();
          return result.isGranted;
        }
        return true;
      } else {
        // أجهزة أقدم تستخدم صلاحية التخزين التقليدية
        var status = await Permission.storage.status;
        if (!status.isGranted) {
          var result = await Permission.storage.request();
          return result.isGranted;
        }
        return true;
      }
    } else if (Platform.isIOS) {
      var status = await Permission.photos.status;
      if (!status.isGranted) {
        var result = await Permission.photos.request();
        return result.isGranted;
      }
      return true;
    }

    return false;
  }
}
