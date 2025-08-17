import 'package:Edzo/controllers/course_controller.dart';
import 'package:Edzo/core/constance/app_router_keys.dart';
import 'package:Edzo/core/helpers/role_helper.dart';
import 'package:Edzo/core/helpers/session_helper.dart';
import 'package:Edzo/models/course_model.dart';
import 'package:Edzo/models/video_model.dart';
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
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
            height: 60.h,
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Row(
              children: [
                Icon(Icons.play_arrow, size: 30.sp),
                SizedBox(width: 10.w),
                Expanded(
                  child: Text(
                    !canPlay
                        ? "اشترك بالدورة لمشاهدة الدرس"
                        : controller.videos[index].title ?? "",
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
          ),
        );
      },
    );
  }
}
