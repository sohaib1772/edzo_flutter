import 'package:edzo/controllers/course_controller.dart';
import 'package:edzo/core/constance/app_router_keys.dart';
import 'package:edzo/core/helpers/local_storage.dart';
import 'package:edzo/core/helpers/role_helper.dart';
import 'package:edzo/core/helpers/session_helper.dart';
import 'package:edzo/models/course_model.dart';
import 'package:edzo/models/video_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class CourseVideosListWidget extends StatelessWidget {
  CourseVideosListWidget({
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
      itemCount: controller.videos.length,
      itemBuilder: (context, index) {
        bool canPlay = false;
        if (RoleHelper.role == Role.full ||
            !controller.videos[index].isPaid! ||
            controller.courseModel.isSubscribed) {
          canPlay = true;
        } else if (SessionHelper.user == null &&
            !controller.videos[index].isPaid!) {
          canPlay = true;
        } else {
          canPlay = false;
        }
    final videoDuration = controller.videos[index].duration ?? 1; // مدة الفيديو
final watchedTime = LocalStorage.getVideoLastWatchedSecond(controller.videos[index].id.toString()) ?? 0; // الوقت الذي شاهده المستخدم

        return GestureDetector(
          onTap: () async {
            if (!canPlay) return;
            if (Get.currentRoute == AppRouterKeys.videoPlayerScreen) {
              await Get.toNamed(
                AppRouterKeys.videoPlayerScreen,
                arguments: {
                  'videoModel': controller.videos[index],
                  "courseModel": controller.courseModel,
                },
              );
              controller.update();
              return;
            }
            await Get.toNamed(
              AppRouterKeys.videoPlayerScreen,
              arguments: {
                'videoModel': controller.videos[index],
                "courseModel": controller.courseModel,
              },
            );
            controller.update();
          },
          child: Container(
            margin: EdgeInsets.symmetric(vertical: 5.h),
            padding: EdgeInsets.symmetric(horizontal: 10.w),
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
                    Icon(Icons.play_arrow, size: 30.sp.clamp(30, 35)),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: Text(
                        !canPlay
                            ? "اشترك بالدورة لمشاهدة الدرس"
                            : controller.videos[index].title ?? "",
                        style: TextStyle(
                          fontSize: 16.sp.clamp(16, 18),
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
                  if(controller.videos[index].duration != null)
                SizedBox(height: 10.h),
                 controller.videos[index].duration == null  ? SizedBox.shrink():Row(
                  children: [
                    SizedBox(width: 8.w),
                    Icon(
                      Icons.timer_outlined,
                      size: 18.sp.clamp(18, 22),
                    ),
                    SizedBox(width: 5.w),
                    Text(
                      controller.durationFromSeconds(
                          controller.videos[index].duration ?? 0).value ,
                      style: TextStyle(fontSize: 13.sp.clamp(13, 15)),
                    ),     
                    Spacer(),
                    Text(
                   ((  watchedTime /  (videoDuration ?? 1)) * 100 ).toStringAsFixed(0) +"%",
                    ),              
                  ]),
                  if(controller.videos[index].duration != null)
                SizedBox(height: 5.h,),
                if(controller.videos[index].duration != null)
                  LinearProgressIndicator(
                    trackGap: 0,
                    value: watchedTime / (videoDuration ?? 1),
                    backgroundColor: Colors.grey,
                    valueColor: AlwaysStoppedAnimation<Color>(
                        Theme.of(context).primaryColor),
                  ),
                  if(controller.videos[index].duration != null)
                  SizedBox(height: 10.h),

              ],
            ),
          ),
        );
      },
    );
  }
}
