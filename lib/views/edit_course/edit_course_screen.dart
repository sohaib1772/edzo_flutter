import 'dart:io';

import 'package:drag_and_drop_lists/drag_and_drop_lists.dart';
import 'package:edzo/controllers/add_course_controller.dart';
import 'package:edzo/controllers/edit_course_controller.dart';
import 'package:edzo/controllers/upload_video_controller.dart';
import 'package:edzo/core/constance/app_router_keys.dart';
import 'package:edzo/core/helpers/app_form_validator.dart';
import 'package:edzo/core/services/app_services.dart';
import 'package:edzo/core/widgets/app_text_button.dart';
import 'package:edzo/core/widgets/app_text_form.dart';
import 'package:edzo/core/widgets/scaffold/app_scaffold.dart';
import 'package:edzo/models/course_model.dart';
import 'package:edzo/views/edit_course/widgets/add_video_dialog.dart';
import 'package:edzo/views/edit_course/widgets/edit_course_form_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class EditCourseScreen extends StatelessWidget {
  EditCourseScreen({super.key});

  final EditCourseController controller = Get.find<EditCourseController>();

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: "تعديل الدورة",
      body: GetBuilder<EditCourseController>(
        init: controller,
        builder: (_) => RefreshIndicator(
          onRefresh: () => controller.getCourseVideos(),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics(),
            ),
            child: LayoutBuilder(
              builder: (context, constraints) {
                double width = constraints.maxWidth;
                if (constraints.maxWidth > 500) {
                  width = 500;
                }

                return ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: MediaQuery.of(
                      context,
                    ).size.height, // 🔥 ضروري حتى لا يظهر فراغ
                  ),
                  child: IntrinsicHeight(
                    // 🔥 يسمح للعمود أن يتمدد بقدر المحتوى
                    child: SizedBox(
                      width: width,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(height: 20.h),

                          /// فورم تعديل الكورس
                          Obx(
                            () => controller.isDelete.value
                                ? _buildDeletedView(context)
                                : EditCourseFormWidget(),
                          ),

                          Obx(
                            () => controller.isDelete.value
                                ? SizedBox(height: 20.h)
                                : _buildVideosSection(context),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDeletedView(BuildContext context) {
    return Center(
      child: Container(
        margin: EdgeInsets.all(20.r),
        padding: EdgeInsets.all(20.r),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 20.h),
            Icon(Icons.check, color: Colors.green, size: 60.sp),
            SizedBox(height: 20.h),
            Text(
              "تم حذف الدورة",
              style: TextStyle(fontSize: 20.sp.clamp(20, 24)),
            ),
            SizedBox(height: 20.h),
            AppTextButton(
              title: "العودة الى الصفحة السابقة",
              onPressed: () {
                Get.back();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVideosSection(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 20.h),
        AppTextButton(
          title: "إدارة الأكواد",
          onPressed: () {
            Get.toNamed(
              AppRouterKeys.courseCodes,
              arguments: controller.courseModel,
            );
          },
        ),
        SizedBox(height: 20.h),
        Divider(),
        SizedBox(height: 20.h),
        AppTextButton(
          title: "المحاضرات",
          onPressed: () {
            Get.toNamed(
              AppRouterKeys.courseVideosListScreen,
              arguments: controller.courseModel.id ?? 0,
            );
          },
        ),
        SizedBox(height: 20.h),
        AppTextButton(
          title: "قوائم التشغيل",
          onPressed: () {
            Get.toNamed(
              AppRouterKeys.teacherPlaylistsScreen,
              arguments: controller.courseModel.id ?? 0,
            );
          },
        ),
        SizedBox(height: 100.h),
      ],
    );
  }
}
