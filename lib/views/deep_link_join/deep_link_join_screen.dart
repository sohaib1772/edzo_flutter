import 'package:edzo/controllers/auth/deep_link_join_controller.dart';
import 'package:edzo/core/widgets/scaffold/app_scaffold.dart';
import 'package:edzo/views/deep_link_join/widgets/deep_link_join_body.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DeepLinkJoinScreen extends StatelessWidget {
  const DeepLinkJoinScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(DeepLinkJoinController());

    return AppScaffold(
      title: "انضمام للدورة",
      body: DeepLinkJoinBody(controller: controller),
    );
  }
}
