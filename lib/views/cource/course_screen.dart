import 'package:cached_network_image/cached_network_image.dart';
import 'package:edzo/controllers/course_controller.dart';
import 'package:edzo/core/constance/app_constance.dart';
import 'package:edzo/core/constance/app_router_keys.dart';
import 'package:edzo/core/widgets/app_text_button.dart';
import 'package:edzo/core/widgets/course_card_loading_skeleton.dart';
import 'package:edzo/core/widgets/scaffold/app_scaffold.dart';
import 'package:edzo/models/course_model.dart';
import 'package:edzo/views/cource/widgets/course_playlist_widget.dart';
import 'package:edzo/views/cource/widgets/course_videos_list_widget.dart';
import 'package:edzo/views/cource/widgets/subscribe_in_course_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

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
          child: Center(
            child: LayoutBuilder(
              
              builder:(context, constraints){
                
                double width = constraints.maxWidth;
                
                if(constraints.maxWidth > 700){
                  width = 700;
                }else if(constraints.maxWidth > 600){
                  width = 600;
                }
                return SizedBox(
                width: width,
            
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(width: 10.w),
                        Expanded(
                          child: Text(
                            courseController.courseModel.title ?? "",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 24.sp.clamp(24, 28),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16.h),
                    GestureDetector(
                      onTap: () {
                        Get.offNamed(
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
                            width: 50.w.clamp(50, 55),
                            height: 50.h.clamp(50, 55),
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
                              fontSize: 18.sp.clamp(18, 22),
                            ),
                          ),
                          Spacer(),
                        courseController.courseModel.teacherInfo?.telegramUrl != null ?  IconButton(
                            onPressed: () async {
                              // url lancher
                              if (!await launchUrl(
                                Uri.parse(
                                  courseController.courseModel.teacherInfo?.telegramUrl ?? "",
                                ),
                                mode: LaunchMode.externalApplication,
                              )) {
                                throw Exception(
                                  'Could not launch ${courseController.courseModel.teacherInfo?.telegramUrl}',
                                );
                              }
                            },
                            icon: Icon(Icons.telegram),
                          ) : SizedBox.shrink(),
                        ],
                      ),
                    ),
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(width: 10.w),
                        Text("الوصف", style: TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                    SizedBox(height: 5.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(width: 10.w),
                        Expanded(child: Text(courseController.courseModel.description ?? "")),
                      ],
                    ),
                    SizedBox(height: 10.h),
                    Divider(),
                    Row(
                      children: [
                        Icon(Icons.people),
                        SizedBox(width: 8.w),
                        Text("عدد المشتركين"),
                        Spacer(),
                        Text(
                          courseController.courseModel.subscribersCount.toString(),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18.sp.clamp(18, 22),
                          ),
                        ),
                        SizedBox(width: 8.w),
                      ],
                    ),
                    SizedBox(height: 10.h),
                    Row(
                      children: [
                        Icon(Icons.videocam_sharp),
                        SizedBox(width: 8.w),
                        Text("عدد المحاضرات"),
                        Spacer(),
                        Obx(
                          ()=> Text(
                            (courseController.videos.length +
                                    courseController.playlists.fold(
                                      0,
                                      (previous, element) =>
                                          previous + element.videos!.length,
                                    ))
                                .toString(),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18.sp.clamp(18, 22),
                            ),
                          ),
                        ),
                        SizedBox(width: 8.w),
                      ],
                    ),
                    SizedBox(height: 10.h),
                    Row(
                      children: [
                        Icon(Icons.timer_outlined),
                        SizedBox(width: 8.w),
                        Text("اجمالي وقت المحاضرات"),
                        Spacer(),
                        Obx(
                          () => Text(
                            courseController
                                .durationFromSeconds(
                                  courseController.totalDuration.value +
                                      courseController.playlists.fold(
                                        0,
                                        (previousPlaylistSum, playlist) =>
                                            previousPlaylistSum +
                                            (playlist.videos?.fold(
                                                  0,
                                                  (previousVideoSum, video) =>
                                                      (previousVideoSum ?? 0) +
                                                      (video.duration ?? 0),
                                                ) ??
                                                0),
                                      ),
                                )
                                .value
                                .toString(),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18.sp.clamp(18, 22),
                            ),
                          ),
                        ),
                        SizedBox(width: 8.w),
                      ],
                    ),
                    SizedBox(height: 18.h),
                
                    courseController.courseModel.telegramUrl != null
                        ? IconButton(
                            onPressed: () async {
                              if (!await launchUrl(
                                Uri.parse(
                                  "${courseController.courseModel.telegramUrl}",
                                ),
                                mode: LaunchMode.externalApplication,
                              ))
                                ;
                            },
                            icon: Icon(Icons.telegram, size: 50.sp.clamp(50, 55)),
                          )
                        : SizedBox.shrink(),
                
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
                          : courseController.videos.isEmpty &&
                                  courseController.playlists.isEmpty
                          ? Center(
                              child: Column(
                                children: [
                                  Icon(Icons.hourglass_empty_outlined, size: 50.sp.clamp(50, 55)),
                                  SizedBox(height: 10.h),
                                  Text("لا يوجد دروس حتى الان"),
                                ],
                              ),
                            )
                          : Column(
                              children: [
                                CourseVideosListWidget(
                                  courseModel: Get.arguments['courseModel'],
                                  controller: courseController,
                                ),
                                SizedBox(height: 10.h),
                                CoursePlaylistWidget(
                                  courseModel: Get.arguments['courseModel'],
                                  controller: courseController,
                                ),
                              ],
                            ),
                    ),
                    SizedBox(height: 10.h),
                  ],
                ),
              );},
            ),
          ),
        ),
      ),
    );
  }
}
