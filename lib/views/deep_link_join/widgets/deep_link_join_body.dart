import 'package:edzo/controllers/auth/deep_link_join_controller.dart';
import 'package:edzo/core/constance/app_router_keys.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DeepLinkJoinBody extends StatelessWidget {
  final DeepLinkJoinController controller;

  const DeepLinkJoinBody({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Obx(() {
        if (controller.isLoading.value) {
          return const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text(
                "جاري معالجة طلب الانضمام...",
                style: TextStyle(fontSize: 16),
              ),
            ],
          );
        }

        if (controller.errorMessage != null) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              Text(
                controller.errorMessage!,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => Get.offAllNamed(AppRouterKeys.mainLayout),
                child: const Text("العودة للرئيسية"),
              ),
            ],
          );
        }

        return const Text("جاري تحويلك...");
      }),
    );
  }
}
