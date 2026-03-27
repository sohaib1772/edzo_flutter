import 'dart:io';
import 'package:edzo/controllers/add_course_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class AddCourseSelectImageWidget extends StatelessWidget {
  final AddCourseController controller;

  const AddCourseSelectImageWidget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => controller.imagePath.value != ""
          ? GestureDetector(
              onTap: () => controller.pickImage(),
              child: Container(
                width: double.infinity,
                height: 200.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16.r),
                  image: DecorationImage(
                    image: FileImage(File(controller.imagePath.value)),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            )
          : GestureDetector(
              onTap: () => controller.pickImage(),
              child: Container(
                alignment: Alignment.center,
                height: 200.h,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16.r),
                  color: Theme.of(context).cardColor,
                ),
                child: Text(
                  "اختار صورة الدورة",
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
    );
  }
}
