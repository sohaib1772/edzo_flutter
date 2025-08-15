import 'dart:io';

import 'package:edzo/controllers/teacher_controller.dart';
import 'package:edzo/core/constance/app_router_keys.dart';
import 'package:edzo/core/widgets/app_text_button.dart';
import 'package:edzo/core/widgets/app_text_form.dart';
import 'package:edzo/core/widgets/course_card_loading_skeleton.dart';
import 'package:edzo/core/widgets/course_card_widget.dart';
import 'package:edzo/views/teacher/widgets/teacher_info_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_getx_widget.dart';

class TeacherScreen extends StatelessWidget {
  TeacherScreen({super.key});
  TeacherController controller = Get.put(TeacherController());
  @override
  Widget build(BuildContext context) {
    return GetX(
      init: controller,
      builder: (controller) => controller.isLoading.value
          ? CourseCardLoadingSkeleton(
              onRefresh: () => controller.getCourses(),
          )
          : RefreshIndicator(
              onRefresh: () => controller.getCourses(),
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics(),
                ),
                child: controller.courses.isEmpty
                    ? SizedBox(
                        height: MediaQuery.of(context).size.height - 200.h,
                        child: Center(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              TeacherInfoWidget(),
                              SizedBox(height: 20.h),
                              Icon(Icons.hourglass_empty_outlined, size: 50.sp),
                              SizedBox(height: 20.h),
                              Text(
                                "لا يوجد دورات تم نشرها حتى الان",
                                style: TextStyle(
                                  fontSize: 20.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 20.h),
                              AppTextButton(
                                title: "اضافة دورة جديدة",
                                icon: Icons.add,
                                onPressed: () {
                                  Get.toNamed(AppRouterKeys.addCourseScreen);
                                },
                              ),
                            ],
                          ),
                        ),
                      )
                    : Column(
                        children: [

                          TeacherInfoWidget(),

                          SizedBox(height: 20.h),
                          AppTextButton(
                            title: "اضافة دورة جديدة",
                            icon: Icons.add,
                            onPressed: () {
                              Get.toNamed(AppRouterKeys.addCourseScreen);
                            },
                          ),
                          SizedBox(height: 20.h),
                          ListView.builder(
                            shrinkWrap: true,

                            physics: NeverScrollableScrollPhysics(),
                            itemCount: controller.courses.length,
                            itemBuilder: (context, index) {
                              return CourseCardWidget(
                                isTeacher: true,
                                course: controller.courses[index],
                              );
                            },
                          ),
                        ],
                      ),
              ),
            ),
    );
  }
}
