import 'package:edzo/controllers/main_layout_controller.dart';
import 'package:edzo/core/constance/app_router_keys.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppBarDefaultLeading extends StatelessWidget {
  AppBarDefaultLeading({super.key});
  MainLayoutController controller = Get.find();
  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.settings),
      onPressed: () {
        Get.toNamed(AppRouterKeys.settingsScreen);
      },
    );
  }
}
