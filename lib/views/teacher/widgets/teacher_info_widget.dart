import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:edzo/controllers/teacher_controller.dart';
import 'package:edzo/core/constance/app_constance.dart';
import 'package:edzo/core/helpers/session_helper.dart';
import 'package:edzo/core/widgets/app_text_button.dart';
import 'package:edzo/core/widgets/app_text_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';

class TeacherInfoWidget extends StatelessWidget {
  TeacherInfoWidget({super.key});
  TeacherController controller = Get.find<TeacherController>();
  @override
  Widget build(BuildContext context) {
    return GetBuilder<TeacherController>(
      init: controller,
      builder: (controller) => Container(
        padding: EdgeInsets.all(10.r),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Column(
          children: [
            GestureDetector(
              onTap: () {
                controller.selectImage();
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(80.r),
                ),
                height: 150.h,
                width: 150.w,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(80.r),
                  child: controller.selectedImage?.path != null
                      ? Image.file(
                          File(controller.selectedImage!.path),
                          fit: BoxFit.cover,
                        )
                      : SessionHelper.user?.teacherInfo?.image != null
                      ? CachedNetworkImage(
                          imageUrl: "${AppConstance.baseUrl}/storage/${controller.imageUrl.value}",
                          fit: BoxFit.cover,
                          placeholder: (context, url) =>
                              Center(child: CircularProgressIndicator()),
                        )
                      : Image.asset(
                          "assets/images/edzo_logo.png",
                          fit: BoxFit.cover,
                        ),
                ),
              ),
            ),
            SizedBox(height: 10.h),
            GestureDetector(
              onTap: () {
                controller.isEdited.value = true;
                controller.update();
              },
              child: AppTextForm(
                enabled: controller.isEdited.value,
                controller: controller.bioController,
                hint: "اكتب نبذة عن نفسك",
                maxLines: 3,
              ),
            ),
            SizedBox(height: 10.h),
            GestureDetector(
              onTap: () {
                controller.isEdited.value = true;
                controller.update();
              },
              child: AppTextForm(
                enabled: controller.isEdited.value,
                controller: controller.telegramUrlController,
                hint: "رابط تليجرامك",
              ),
            ),
            SizedBox(height: 10.h),

            controller.isEdited.value
                ? Row(
                    children: [
                      Expanded(
                        child: AppTextButton(
                          title: "حفظ",
                          onPressed: () {
                            controller.addTeacherInfo();
                          },
                        ),
                      ),
                      SizedBox(width: 10.w),
                      Expanded(
                        child: AppTextButton(
                          color: Colors.red.shade300,
                          title: "الغاء",
                          onPressed: () {
                            controller.cancelEdit();
                          },
                        ),
                      ),
                    ],
                  )
                : SizedBox(),
          ],
        ),
      ),
    );
  }
}
