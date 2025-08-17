import 'dart:io';

import 'package:Edzo/controllers/edit_course_controller.dart';
import 'package:Edzo/core/helpers/app_form_validator.dart';
import 'package:Edzo/core/widgets/app_text_button.dart';
import 'package:Edzo/core/widgets/app_text_form.dart';
import 'package:Edzo/models/course_model.dart';
import 'package:Edzo/views/edit_course/widgets/edit_course_select_image_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

class EditCourseFormWidget extends StatelessWidget {
  EditCourseFormWidget({super.key});
  EditCourseController controller = Get.find<EditCourseController>();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          EditCourseSelectImageWidget(),
          SizedBox(height: 30.h),
          Obx(
            ()=> !controller.editMode.value
                ? AppTextButton(
                    title: "تعديل",
                    onPressed: () async {
                      controller.editMode.value = true;
                    },
                  )
                : Column(
                    children: [
                      AppTextButton(
                        title: "الغاء",
                        onPressed: () async {
                          controller.editMode.value = false;
                        },
                      ),
                      SizedBox(height: 10.h),
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
                        textInputType: TextInputType.number,
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
                        () => Row(
                          children: [
                            Expanded(
                              child: AppTextButton(
                                isLoading: controller.isLoading.value,
                                title: "حفظ",
                                onPressed: () async {
                                  if (formKey.currentState!.validate()) {
                                    controller.editCourse();
                                  }
                                },
                              ),
                            ),
                            SizedBox(width: 10.w),
                            Expanded(
                              child: AppTextButton(
                                isLoading: controller.isLoading.value,
                                color: Colors.red.shade300,
                                title: "حذف",
                                onPressed: () async {
                                  Get.dialog(
                                    AlertDialog(
                                      title: Text("هل أنت متأكد من حذف الدورة؟"),
                                      actions: [
                                        Obx(
                                          () => AppTextButton(
                                            isLoading: controller.isLoading.value,
                                            color: Colors.red.shade300,
                                            title: "نعم",
                                            onPressed: () {
                                              controller.deleteCourse();
                                            },
                                          ),
                                        ),
                                        SizedBox(height: 10.w),
                                        AppTextButton(
                                          title: "لا",
                                          onPressed: () => Get.back(),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ).animate().fade(),
          ),
        ],
      ),
    );
  }
}
