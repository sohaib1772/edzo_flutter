import 'package:edzo/controllers/home_controller.dart';
import 'package:edzo/core/widgets/course_card_widget.dart';
import 'package:edzo/core/widgets/course_card_loading_skeleton.dart';
import 'package:edzo/views/home/widgets/teachers_horizontal_list_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});
  HomeController homeController = Get.find();
  @override
  Widget build(BuildContext context) {
    return GetX(
      init: homeController,
      builder: (controller) => controller.isLoading.value
          ? CourseCardLoadingSkeleton(
              onRefresh: () => controller.getCourses(),
            )
          : controller.courses.isEmpty && controller.teachers.isEmpty
              ? RefreshIndicator(
                  onRefresh: () async {
                    await controller.getCourses();
                    await controller.getTeachers();
                  },
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(
                      parent: AlwaysScrollableScrollPhysics(),
                    ),
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height - 100,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.hourglass_empty_outlined, size: 50.sp),
                            SizedBox(height: 20.h),
                            Text(
                              "لا يوجد محتوى حتى الان",
                              style: TextStyle(
                                fontSize: 20.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                )
              : RefreshIndicator(
                  onRefresh: () async {
                    await controller.getCourses();
                    await controller.getTeachers();
                  },
                  child: ListView(
                    physics: const BouncingScrollPhysics(
                      parent: AlwaysScrollableScrollPhysics(),
                    ),
                    children: [
                      const TeachersHorizontalListWidget(),
                      ...controller.courses.map(
                        (course) => CourseCardWidget(course: course),
                      ),
                    ],
                  ),
                ),
    );
  }
}
