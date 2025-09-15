import 'package:edzo/controllers/course_controller.dart';
import 'package:edzo/core/constance/app_router_keys.dart';
import 'package:edzo/core/helpers/local_storage.dart';
import 'package:edzo/core/helpers/role_helper.dart';
import 'package:edzo/core/helpers/session_helper.dart';
import 'package:edzo/models/course_model.dart';
import 'package:edzo/views/cource/widgets/course_videos_list_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class CoursePlaylistWidget extends StatelessWidget {
  CoursePlaylistWidget({
    super.key,
    required this.courseModel,
    required this.controller,
  });
  CourseModel courseModel;
  CourseController controller;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: controller.playlists.length,
      itemBuilder: (context, index) {
        int totalPlayListVideosDuration = 0;
        for (var video in controller.playlists[index].videos!) {
          totalPlayListVideosDuration += video.duration ?? 0;
        }
        return Container(
          margin: EdgeInsets.symmetric(vertical: 5.h),
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: ExpansionTile(
            title: Text(controller.playlists[index].title!),
            subtitle: Padding(
              padding:  EdgeInsets.symmetric(vertical: 10.h),
              child: Row(
                children: [
                  Text("مدة القائمة - "),
                  Text(
                    controller.durationFromSeconds(totalPlayListVideosDuration).value,
                  ),
                ],
              ),
            ),
            children: List.generate(
              controller.playlists[index].videos!.length,
              (generator) {
                bool canPlay = false;
                if (RoleHelper.role == Role.full ||
                    ! (controller.playlists[index].videos?[generator].isPaid! ?? false) ||
                    controller.courseModel.isSubscribed) {
                  canPlay = true;
                } else if (SessionHelper.user == null &&
                    !(controller.playlists[index].videos?[generator].isPaid! ?? false)) {
                  canPlay = true;
                } else {
                  canPlay = false;
                }
                final videoDuration =
                    controller.playlists[index].videos?[generator].duration ?? 1; // مدة الفيديو
                final watchedTime =
                    LocalStorage.getVideoLastWatchedSecond(
                      controller.playlists[index].videos?[generator].id.toString() ?? '',
                    ) ??
                    0; // الوقت الذي شاهده المستخدم

                return GestureDetector(
                  onTap: () async {
                    bool canPlay = false;
                    if (RoleHelper.role == Role.full ||
                        !(controller.playlists[index].videos?[generator].isPaid! ?? false) ||
                        controller.courseModel.isSubscribed) {
                      canPlay = true;
                    } else if (SessionHelper.user == null &&
                        !(controller.playlists[index].videos?[generator].isPaid! ?? false)) {
                      canPlay = true;
                    } else {
                      canPlay = false;
                    }

                    if (!canPlay) return;
                    if (Get.currentRoute == AppRouterKeys.videoPlayerScreen) {
                      await Get.toNamed(
                        AppRouterKeys.videoPlayerScreen,
                        arguments: {
                          'videoModel': controller.playlists[index].videos?[generator],
                          "courseModel": controller.courseModel,
                        },
                      );
                      controller.update();
                      return;
                    }
                    await Get.toNamed(
                      AppRouterKeys.videoPlayerScreen,
                      arguments: {
                        'videoModel': controller.playlists[index].videos?[generator],
                        "courseModel": controller.courseModel,
                      },
                    );
                    controller.update();
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 5.h),
                    padding: EdgeInsets.symmetric(horizontal: 10.w),
                    height: 85.h,
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.play_arrow, size: 30.sp),
                            SizedBox(width: 10.w),
                            Expanded(
                              child: Text(
                                !canPlay
                                    ? "اشترك بالدورة لمشاهدة الدرس"
                                    : controller.playlists[index].videos?[generator].title ?? "",
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            SizedBox(width: 10.w),
                            Icon(Icons.arrow_forward_ios),
                          ],
                        ),
                        if (controller.playlists[index].videos?[generator].duration != null)
                          SizedBox(height: 10.h),
                        controller.playlists[index].videos?[generator].duration == null
                            ? SizedBox.shrink()
                            : Row(
                                children: [
                                  SizedBox(width: 8.w),
                                  Icon(Icons.timer_outlined, size: 18.sp),
                                  SizedBox(width: 5.w),
                                  Text(
                                    controller
                                        .durationFromSeconds(
                                          controller.playlists[index].videos?[generator].duration ??
                                              0,
                                        )
                                        .value,
                                    style: TextStyle(fontSize: 13.sp),
                                  ),
                                  Spacer(),
                                  Text(
                                    ((watchedTime / (videoDuration ?? 1)) * 100)
                                            .toStringAsFixed(0) +
                                        "%",
                                  ),
                                ],
                              ),
                        if (controller.playlists[index].videos?[generator].duration != null)
                          SizedBox(height: 5.h),
                        if (controller.playlists[index].videos?[generator].duration != null)
                          LinearProgressIndicator(
                            trackGap: 0,
                            value: watchedTime / (videoDuration ?? 1),
                            backgroundColor: Colors.grey,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Theme.of(context).primaryColor,
                            ),
                          ),
                        if (controller.playlists[index].videos?[generator].duration != null)
                          SizedBox(height: 10.h),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
