import 'package:cached_network_image/cached_network_image.dart';
import 'package:edzo/controllers/course_controller.dart';
import 'package:edzo/core/constance/app_constance.dart';
import 'package:edzo/core/constance/app_router_keys.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class CourseTeacherInfoWidget extends StatelessWidget {
  final CourseController controller;

  const CourseTeacherInfoWidget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.toNamed(
          AppRouterKeys.teacherProfileScreen,
          arguments: {
            "teacherInfoModel": controller.courseModel?.teacherInfo,
            "teacherName": controller.courseModel?.teacherName,
            "teacherId": controller.courseModel?.teacherId,
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
              child: controller.courseModel?.teacherInfo?.image != null
                  ? CachedNetworkImage(
                      imageUrl:
                          "${AppConstance.baseUrl}/storage/${controller.courseModel?.teacherInfo!.image}",
                    )
                  : Image.asset('assets/images/edzo_logo.png'),
            ),
          ),
          SizedBox(width: 16.w),
          Text(
            controller.courseModel?.teacherName ?? "",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18.sp.clamp(18, 22),
            ),
          ),
          const Spacer(),
          if (controller.courseModel?.teacherInfo?.telegramUrl != null)
            IconButton(
              onPressed: () async {
                if (!await launchUrl(
                  Uri.parse(
                    controller.courseModel?.teacherInfo?.telegramUrl ?? "",
                  ),
                  mode: LaunchMode.externalApplication,
                )) {
                  throw Exception(
                    'Could not launch ${controller.courseModel?.teacherInfo?.telegramUrl}',
                  );
                }
              },
              icon: const Icon(Icons.telegram),
            ),
        ],
      ),
    );
  }
}
