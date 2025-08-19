import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:edzo/controllers/edit_course_controller.dart';
import 'package:edzo/core/constance/app_constance.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class EditCourseSelectImageWidget extends StatelessWidget {
  EditCourseSelectImageWidget({super.key});
  EditCourseController controller = Get.find<EditCourseController>();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => controller.imageUrl.value != "" && controller.imagePath.value == ""
          ? GestureDetector(
              onTap: () async {
              controller.pickImage();
              },
              child: Container(
                width: double.infinity,
                height: 200.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16.r),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16.r),
                  child: CachedNetworkImage(
                    imageUrl:
                        "${AppConstance.baseUrl}/storage/${controller.imageUrl.value}",
                    fit: BoxFit.cover,
                    placeholder: (context, url) =>
                        Center(child: CircularProgressIndicator()),

                  ),
                ),
              ),
            )
          : controller.imagePath.value != ""
          ? GestureDetector(
              onTap: () async {
                controller.pickImage();
              },
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
              onTap: () async {
                controller.pickImage();
              },
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
