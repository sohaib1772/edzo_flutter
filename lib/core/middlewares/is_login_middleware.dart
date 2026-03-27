import 'package:edzo/core/constance/app_router_keys.dart';
import 'package:edzo/core/services/app_services.dart';
import 'package:edzo/core/helpers/session_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class IsLoginMiddleware  extends GetMiddleware{
  @override
  RouteSettings? redirect(String? route) {
    if (Get.find<AppServices>().isLoggedIn) {
      final user = SessionHelper.user;
      if (user != null && user.needsPhoneVerification) {
        return const RouteSettings(name: AppRouterKeys.mandatoryPhoneScreen);
      }
      return const RouteSettings(name: AppRouterKeys.mainLayout);
    }
    return null;
  }

  
}