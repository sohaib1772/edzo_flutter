import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:edzo/core/constance/app_constance.dart';
import 'package:edzo/core/constance/app_router_keys.dart';
import 'package:edzo/core/helpers/check_app_version.dart';
import 'package:edzo/core/helpers/local_storage.dart';
import 'package:edzo/core/helpers/role_helper.dart';
import 'package:edzo/core/network/api_result.dart';
import 'package:edzo/core/network/dio_factory.dart';
import 'package:edzo/core/network/main_api.dart';
import 'package:edzo/models/user_model.dart';
import 'package:edzo/repos/admin_repo.dart';
import 'package:edzo/repos/app_settings_repo.dart';
import 'package:edzo/repos/auth/email_verification_repo.dart';
import 'package:edzo/repos/auth/forgot_password_repo.dart';
import 'package:edzo/repos/auth/login_repo.dart';
import 'package:edzo/repos/auth/logout_repo.dart';
import 'package:edzo/repos/auth/register_repo.dart';
import 'package:edzo/repos/courses/courses_repo.dart';
import 'package:edzo/repos/courses/pin_course_repo.dart';
import 'package:edzo/repos/courses/public_courses_repo.dart';
import 'package:edzo/repos/playlist/playlist_repo.dart';
import 'package:edzo/repos/teacher_repo.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:intl/date_symbol_data_local.dart';

class AppServices extends GetxService {
  bool isLoggedIn = false;
  bool needUpdate = false;
  Role role = Role.student;
  Future<AppServices> init() async {
    

    await LocalStorage.init();
    await setUpApi();
    print("app version ${await getAppVersion()}");
    
    await checkToken();
    await getTheme();
    await requestStoragePermission();
    role = await LocalStorage.getRole();
    await initializeDateFormatting("ar");
    await checkAppVersion();
    return this;
  }

  Future<void> setUpApi() async {
    Get.putAsync(() async => MainApi(await DioFactory.getInstance()));
     Get.lazyPut(()=> AppSettingsRepo(Get.find<MainApi>()), fenix: true);
    Get.lazyPut(() => LoginRepo(Get.find<MainApi>()), fenix: true);
    Get.lazyPut(() => LogoutRepo(Get.find<MainApi>()), fenix: true);
    Get.lazyPut(() => RegisterRepo(Get.find<MainApi>()), fenix: true);
    Get.lazyPut(() => EmailVerificationRepo(Get.find<MainApi>()), fenix: true);
    Get.lazyPut(() => ForgotPasswordRepo(Get.find<MainApi>()), fenix: true);
    Get.lazyPut(() => CoursesRepo(Get.find<MainApi>()), fenix: true);
    Get.lazyPut(() => TeacherRepo(Get.find<MainApi>()), fenix: true);
    Get.lazyPut(() => AdminRepo(Get.find<MainApi>()), fenix: true);
    Get.lazyPut(() => PublicCoursesRepo(Get.find<MainApi>()), fenix: true);
    Get.lazyPut(() => PlaylistRepo(Get.find<MainApi>()), fenix: true);
    Get.lazyPut(() => PinCourseRepo(Get.find<MainApi>()), fenix: true);
   
    

  }

  Future<void> checkAppVersion() async {
    AppSettingsRepo appSettingsRepo = Get.find<AppSettingsRepo>();
    ApiResult<String> res = await appSettingsRepo.getAppVersion();
    if (res.status) {
      if (isVersionLower(AppConstance.appDevVersion, res.data?? "")) {
        print("need update");
        needUpdate = true;
      }
      else{
        print("no need update");
      }
    }
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
  Future<String> getAppVersion() async {
  final info = await PackageInfo.fromPlatform();
  return info.version;
}
}
