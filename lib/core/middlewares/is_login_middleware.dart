import 'package:Edzo/core/constance/app_router_keys.dart';
import 'package:Edzo/core/services/app_services.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class IsLoginMiddleware  extends GetMiddleware{
  @override
  RouteSettings? redirect(String? route) {
    if (Get.find<AppServices>().isLoggedIn) {
      return const RouteSettings(name: AppRouterKeys.mainLayout);
    }
    return null;
  }

  
}