import 'package:cached_network_image/cached_network_image.dart';
import 'package:edzo/controllers/course_controller.dart';
import 'package:edzo/core/constance/app_constance.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class CourseImagePreviewWidget extends StatelessWidget {
  final CourseController controller;

  const CourseImagePreviewWidget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.dialog(
          Dialog(
            child: CachedNetworkImage(
              imageUrl:
                  "${AppConstance.baseUrl}/storage/${controller.courseModel?.image ?? ""}",
              fit: BoxFit.cover,
            ),
          ),
        );
      },
      child: Container(
        width: double.infinity,
        height: 300.h,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(16.r)),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16.r),
          child: CachedNetworkImage(
            imageUrl:
                "${AppConstance.baseUrl}/storage/${controller.courseModel?.image ?? ""}",
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
