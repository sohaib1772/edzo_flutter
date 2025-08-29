import 'package:cached_network_image/cached_network_image.dart';
import 'package:edzo/controllers/course_controller.dart';
import 'package:edzo/core/constance/app_constance.dart';
import 'package:edzo/core/constance/app_router_keys.dart';
import 'package:edzo/core/widgets/course_card_loading_skeleton.dart';
import 'package:edzo/core/widgets/scaffold/app_scaffold.dart';
import 'package:edzo/models/course_model.dart';
import 'package:edzo/views/cource/widgets/course_videos_list_widget.dart';
import 'package:edzo/views/cource/widgets/subscribe_in_course_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class CourseScreen extends StatelessWidget {
  CourseController courseController = Get.find<CourseController>();

  CourseScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return AppScaffold(
     
      body: RefreshIndicator(
        onRefresh: () async {
          await courseController.getVideos();
        },
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics(),
          ),
          child: Column(
            children: [
              SizedBox(height: 18.h),
              GestureDetector(
                onTap: () {
                  Get.dialog(
                    useSafeArea: false,

                    Dialog(
                      child: CachedNetworkImage(
                        imageUrl:
                            "${AppConstance.baseUrl}/storage/${courseController.courseModel.image}",
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                },
                child: Container(
                  width: double.infinity,
                  height: 300.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16.r),
                    child: CachedNetworkImage(
                      imageUrl:
                          "${AppConstance.baseUrl}/storage/${courseController.courseModel.image}",
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 18.h),
              GestureDetector(
                onTap: () {
                  Get.toNamed(
                    AppRouterKeys.teacherProfileScreen,
                    arguments: {
                      "teacherInfoModel":
                          courseController.courseModel.teacherInfo,
                      "teacherName": courseController.courseModel.teacherName,
                      "teacherId": courseController.courseModel.teacherId,
                    },
                  );
                },
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 50.w,
                      height: 50.h,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(50.r),
                        child:
                            courseController.courseModel.teacherInfo?.image !=
                                null
                            ? CachedNetworkImage(
                                imageUrl:
                                    "${AppConstance.baseUrl}/storage/${courseController.courseModel.teacherInfo!.image}",
                              )
                            : Image.asset('assets/images/edzo_logo.png'),
                      ),
                    ),
                    SizedBox(width: 16.w),
                    Text(
                      courseController.courseModel.teacherName ?? "",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18.sp,
                      ),
                    ),
                    Spacer(),
                    Row(
                      children: [
                        Icon(Icons.people),
                        SizedBox(width: 8.w),
                        Text(
                          courseController.courseModel.subscribersCount
                              .toString(),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18.sp,
                          ),
                        ),
                        SizedBox(width: 8.w),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 18.h),
              Text(courseController.courseModel.title ?? ""),
              SizedBox(height: 10.h),
              Text(courseController.courseModel.description ?? ""),
              SizedBox(height: 10.h),
              GetBuilder<CourseController>(
                init: courseController,

                builder: (controller) => controller.courseModel.isSubscribed
                    ? SizedBox(height: 10.h)
                    : SubscribeInCourseWidget(),
              ),
              SizedBox(height: 10.h),
              Divider(),
              SizedBox(height: 10.h),

              Obx(
                () => courseController.isLoading.value
                    ? CourseCardLoadingSkeleton(
                        onRefresh: () async {
                          await courseController.getVideos();
                        },
                    )
                    : courseController.videos.isEmpty
                    ? Center(
                        child: Column(
                          children: [
                            Icon(Icons.hourglass_empty_outlined, size: 50.sp),
                            SizedBox(height: 10.h),
                            Text("لا يوجد دروس حتى الان"),
                          ],
                        ),
                      )
                    : CourseVideosListWidget(
                        courseModel: Get.arguments['courseModel'],
                        controller: courseController,
                    ),
              ),
              SizedBox(height: 10.h),
            ],
          ),
        ),
      ),
    );
  }
}
