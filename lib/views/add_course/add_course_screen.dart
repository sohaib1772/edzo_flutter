import 'package:edzo/controllers/add_course_controller.dart';
import 'package:edzo/core/widgets/scaffold/app_scaffold.dart';
import 'package:edzo/views/add_course/widgets/add_course_form_widget.dart';
import 'package:edzo/views/add_course/widgets/add_course_select_image_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddCourseScreen extends StatelessWidget {
  final AddCourseController controller = Get.put(AddCourseController());

  AddCourseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: "اضافة دورة جديدة",
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            AddCourseSelectImageWidget(controller: controller),
            const SizedBox(height: 30),
            AddCourseFormWidget(controller: controller),
          ],
        ),
      ),
    );
  }
}
