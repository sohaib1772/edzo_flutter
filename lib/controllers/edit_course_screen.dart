import 'dart:io';

import 'package:edzo/controllers/add_course_controller.dart';
import 'package:edzo/core/helpers/app_form_validator.dart';
import 'package:edzo/core/widgets/app_text_button.dart';
import 'package:edzo/core/widgets/app_text_form.dart';
import 'package:edzo/core/widgets/scaffold/app_scaffold.dart';
import 'package:edzo/models/course_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';


class EditCourseScreen extends StatelessWidget {
  EditCourseScreen({super.key});
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  AddCourseController controller = AddCourseController();
  CourseModel courseModel = Get.arguments['courseModel'];
  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      body: Form(
        key: formKey,
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Obx(
                () => controller.imagePath.value != ""
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
                              image: FileImage(
                                File(controller.imagePath.value),
                              ),
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
              ),
              SizedBox(height: 30.h),
              AppTextForm(
                prefixIcon: Icons.title_outlined,
                hint: "العنوان",
                validator: (value) {
                  if (AppFormValidator.isEmpty(value ?? ""))
                    return 'العنوان مطلوب';
                  return null;
                },
                controller: controller.titleController,
              ),
              SizedBox(height: 10.h),
              AppTextForm(
                maxLines: 5,
                hint: "الوصف",
                validator: (value) {
                  if (AppFormValidator.isEmpty(value ?? ""))
                    return 'الوصف مطلوب';
                  return null;
                },
                controller: controller.descriptionController,
              ),
              SizedBox(height: 20.h),
              AppTextForm(
                prefixIcon: Icons.monetization_on_outlined,
                hint: "السعر",
                validator: (value) {
                  if (AppFormValidator.isEmpty(value ?? ""))
                    return 'السعر مطلوب';
                  return null;
                },
                controller: controller.priceController,
              ),
              SizedBox(height: 30.h),

              Obx(
                () => AppTextButton(
                  isLoading: controller.isLoading.value,
                  title: "اضافة الدورة",
                  onPressed: () async {
                    if (formKey.currentState!.validate()) {
                      controller.addCourse();
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
