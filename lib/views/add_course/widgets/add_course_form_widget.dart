import 'package:edzo/controllers/add_course_controller.dart';
import 'package:edzo/core/helpers/app_form_validator.dart';
import 'package:edzo/core/widgets/app_text_button.dart';
import 'package:edzo/core/widgets/app_text_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class AddCourseFormWidget extends StatelessWidget {
  final AddCourseController controller;

  const AddCourseFormWidget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Form(
      key: controller.formKey,
      child: Column(
        children: [
          AppTextForm(
            prefixIcon: Icons.title_outlined,
            hint: "العنوان",
            validator: (value) {
              if (AppFormValidator.isEmpty(value ?? "")) return 'العنوان مطلوب';
              return null;
            },
            controller: controller.titleController,
          ),
          SizedBox(height: 10.h),
          AppTextForm(
            maxLines: 5,
            hint: "الوصف",
            validator: (value) {
              if (AppFormValidator.isEmpty(value ?? "")) return 'الوصف مطلوب';
              return null;
            },
            controller: controller.descriptionController,
          ),
          SizedBox(height: 20.h),
          AppTextForm(
            textInputType: TextInputType.number,
            prefixIcon: Icons.monetization_on_outlined,
            hint: "السعر",
            validator: (value) {
              if (AppFormValidator.isEmpty(value ?? "")) return 'السعر مطلوب';
              return null;
            },
            controller: controller.priceController,
          ),
          SizedBox(height: 30.h),
          AppTextForm(
            prefixIcon: Icons.link_outlined,
            hint: "رابط تيليجرام اختياري",
            controller: controller.telegramUrlController,
          ),
          SizedBox(height: 30.h),
          Obx(
            () => AppTextButton(
              isLoading: controller.isLoading.value,
              title: "اضافة الدورة",
              onPressed: () {
                if (controller.formKey.currentState!.validate()) {
                  controller.addCourse();
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
