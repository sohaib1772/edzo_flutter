import 'package:edzo/controllers/course_controller.dart';
import 'package:edzo/core/constance/app_router_keys.dart';
import 'package:edzo/core/widgets/course_card_loading_skeleton.dart';
import 'package:edzo/core/widgets/scaffold/app_scaffold.dart';
import 'package:edzo/views/cource/widgets/course_details_stats_widget.dart';
import 'package:edzo/views/cource/widgets/course_image_preview_widget.dart';
import 'package:edzo/views/cource/widgets/course_playlist_widget.dart';
import 'package:edzo/views/cource/widgets/course_teacher_info_widget.dart';
import 'package:edzo/views/cource/widgets/course_videos_list_widget.dart';
import 'package:edzo/views/cource/widgets/subscribe_in_course_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class CourseScreen extends StatelessWidget {
  final CourseController courseController = Get.find<CourseController>();

  CourseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bool fromDeepLink = courseController.fromDeepLink;

    return AppScaffold(
      leading: fromDeepLink
          ? IconButton(
              onPressed: () => Get.offAllNamed(AppRouterKeys.mainLayout),
              icon: const Icon(Icons.arrow_back),
            )
          : null,
      body: RefreshIndicator(
        onRefresh: () async {
          await courseController.getVideos();
        },
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics(),
          ),
          child: Center(
            child: LayoutBuilder(
              builder: (context, constraints) {
                double width = constraints.maxWidth > 700
                    ? 700
                    : (constraints.maxWidth > 600 ? 600 : constraints.maxWidth);

                return SizedBox(
                  width: width,
                  child: Column(
                    children: [
                      _buildTitleRow(),
                      SizedBox(height: 16.h),
                      CourseTeacherInfoWidget(controller: courseController),
                      SizedBox(height: 18.h),
                      CourseImagePreviewWidget(controller: courseController),
                      SizedBox(height: 18.h),
                      _buildDescriptionSection(),
                      SizedBox(height: 10.h),
                      const Divider(),
                      CourseDetailsStatsWidget(controller: courseController),
                      SizedBox(height: 18.h),
                      _buildTelegramButton(),
                      GetBuilder<CourseController>(
                        init: courseController,
                        builder: (controller) =>
                            controller.courseModel == null || controller.courseModel!.isSubscribed
                            ? SizedBox(height: 10.h)
                            : SubscribeInCourseWidget(),
                      ),
                      SizedBox(height: 10.h),
                      const Divider(),
                      SizedBox(height: 10.h),
                      _buildVideosAndPlaylistsSection(),
                      SizedBox(height: 10.h),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTitleRow() {
    return Row(
      children: [
        SizedBox(width: 10.w),
        Expanded(
          child: Text(
            courseController.courseModel?.title ?? "",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 24.sp.clamp(24, 28),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDescriptionSection() {
    return Column(
      children: [
        Row(
          children: [
            SizedBox(width: 10.w),
            const Text("الوصف", style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        SizedBox(height: 5.h),
        Row(
          children: [
            SizedBox(width: 10.w),
            Expanded(
              child: Text(courseController.courseModel?.description ?? ""),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTelegramButton() {
    if (courseController.courseModel?.telegramUrl == null)
      return const SizedBox.shrink();
    return IconButton(
      onPressed: () async {
        if (!await launchUrl(
          Uri.parse("${courseController.courseModel?.telegramUrl}"),
          mode: LaunchMode.externalApplication,
        ))
          ;
      },
      icon: Icon(Icons.telegram, size: 50.sp.clamp(50, 55)),
    );
  }

  Widget _buildVideosAndPlaylistsSection() {
    return Obx(
      () => courseController.isLoading.value
          ? CourseCardLoadingSkeleton(
              onRefresh: () async => await courseController.getVideos(),
            )
          : courseController.videos.isEmpty &&
                courseController.playlists.isEmpty
          ? _buildEmptyState()
          : Column(
              children: [
                CourseVideosListWidget(
                  courseModel: courseController.courseModel!,
                  controller: courseController,
                ),
                SizedBox(height: 10.h),
                CoursePlaylistWidget(
                  courseModel: courseController.courseModel!,
                  controller: courseController,
                ),
              ],
            ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        children: [
          Icon(Icons.hourglass_empty_outlined, size: 50.sp.clamp(50, 55)),
          SizedBox(height: 10.h),
          const Text("لا يوجد دروس حتى الان"),
        ],
      ),
    );
  }
}
