import 'package:edzo/controllers/main_layout_controller.dart';
import 'package:edzo/core/helpers/role_helper.dart';
import 'package:edzo/core/services/app_services.dart';
import 'package:edzo/core/widgets/scaffold/app_scaffold.dart';
import 'package:edzo/views/admin/admin_screen.dart';
import 'package:edzo/views/home/home_screen.dart';
import 'package:edzo/views/my_subscriptions/my_subscriptions_screen.dart';
import 'package:edzo/views/search/search_screen.dart';
import 'package:edzo/views/teacher/teacher_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MainLayoutScreen extends StatelessWidget {
  MainLayoutScreen({super.key});
  MainLayoutController mainLayoutController = Get.find<MainLayoutController>();

  
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => AppScaffold(
        defaultLeading: true,
        title: mainLayoutController.getTitle(),
        body: Obx(
          () => IndexedStack(
            index: mainLayoutController.currentScreen.value,
            children:mainLayoutController.screens ?? [],
          ),
        ),
        bottomNavigationBar: Obx(
          () => BottomNavigationBar(
            currentIndex: mainLayoutController.currentScreen.value,
            onTap: (index) {
              mainLayoutController.changeScreen(index);
            },
            type: BottomNavigationBarType.fixed,
            items: mainLayoutController.items ?? [],
          ),
        ),
      ),
    );
  }
}
