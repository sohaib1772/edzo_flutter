import 'package:cached_network_image/cached_network_image.dart';
import 'package:edzo/controllers/teacher_profile_controller.dart';
import 'package:edzo/core/constance/app_constance.dart';
import 'package:edzo/core/widgets/course_card_loading_skeleton.dart';
import 'package:edzo/core/widgets/course_card_widget.dart';
import 'package:edzo/core/widgets/scaffold/app_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class TeacherProfileScreen extends StatelessWidget {
  TeacherProfileScreen({super.key});
  TeacherProfileController controller = Get.find<TeacherProfileController>();

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      body: RefreshIndicator(
        onRefresh: () => controller.getTeacherCourses(),
        child: SingleChildScrollView(
          child: Column(
            children: [
              CircleAvatar(
                radius: 80,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(80),
                  child: controller.teacherInfoModel?.image != null
                      ? CachedNetworkImage(
                          imageUrl:
                              "${AppConstance.baseUrl}/storage/${controller.teacherInfoModel?.image}",
                          placeholder: (context, url) =>
                              Center(child: const CircularProgressIndicator()),
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                        )
                      : Image.asset('assets/images/edzo_logo.png'),
                ),
              ),
              SizedBox(height: 20.h),
              Text(
                controller.teacherName,
                style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20.h),
              Text(
                controller.teacherInfoModel?.bio ?? "",
                style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20.h),

              Divider(),
              SizedBox(height: 20.h),
              Text(
                "دوراتي",
                style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20.h),
              Obx(
                ()=> controller.isLoading.value
                    ? CourseCardLoadingSkeleton(
                        onRefresh: () => controller.getTeacherCourses(),
                    )
                    : controller.courses.isEmpty
                    ? Center(child: Text("لا يوجد دورات"))
                    : ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: controller.courses.length,
                        itemBuilder: (context, index) =>
                            CourseCardWidget(course: controller.courses[index]),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
