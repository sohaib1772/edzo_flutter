import 'package:edzo/core/constance/app_router_keys.dart';
import 'package:edzo/core/services/app_services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NeedUpdateMiddleware extends GetMiddleware{
  @override
  RouteSettings? redirect(String? route) {
    if(Get.find<AppServices>().needUpdate){
      return const RouteSettings(name: AppRouterKeys.updateScreen);
    }
    return null;
  }
}