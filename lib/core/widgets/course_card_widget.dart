import 'package:cached_network_image/cached_network_image.dart';
import 'package:Edzo/core/constance/app_constance.dart';
import 'package:Edzo/core/constance/app_router_keys.dart';
import 'package:Edzo/core/helpers/role_helper.dart';
import 'package:Edzo/core/helpers/session_helper.dart';
import 'package:Edzo/models/course_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class CourseCardWidget extends StatelessWidget {
  CourseCardWidget({super.key, required this.course, this.isTeacher = false});
  CourseModel course;
  bool isTeacher;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (isTeacher) {
          Get.toNamed(
            AppRouterKeys.editCourseScreen,
            arguments: {"courseModel": course},
          );
          return;
        }
        Get.toNamed(
          AppRouterKeys.courseScreen,
          arguments: {"courseModel": course},
        );
      },
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 10.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16.r),
                  topRight: Radius.circular(16.r),
                ),
                child: CachedNetworkImage(
                  imageUrl: "${AppConstance.baseUrl}/storage/${course.image}",
                  placeholder: (context, url) =>
                      Center(child: CircularProgressIndicator()),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Container(
              width: double.infinity,
              padding: EdgeInsets.only(right: 16.r, bottom: 16.r, top: 16.r),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(16.r),
                  bottomRight: Radius.circular(16.r),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    course.title ?? "",
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    course.description ?? "",
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 16.h),
                RoleHelper.role == Role.full ? SizedBox.shrink() :  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16.r,
                          vertical: 4.r,
                        ),
                        color: course.price.toString() == "0"
                            ? Colors.green.shade300
                            : Colors.red.shade300,
                        child: Text(
                          course.price.toString() == "0"
                              ? "مجاني"
                              : course.price.toString() + " دينار",
                          style: TextStyle(
                            shadows: [
                              Shadow(color: Colors.black, offset: Offset(0, 1)),
                            ],
                            fontWeight: FontWeight.bold,
                            fontSize: 24.sp,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16.h),
                  isTeacher
                      ? SizedBox.shrink()
                      : Padding(
                          padding: EdgeInsets.only(left: 16.w),
                          child: Divider(height: 16.h),
                        ),
                  SizedBox(height: 16.h),
                  isTeacher
                      ? SizedBox.shrink()
                      : GestureDetector(
                          onTap: () {
                            Get.toNamed(
                              AppRouterKeys.teacherProfileScreen,
                              arguments: {
                                "teacherInfoModel": course.teacherInfo,
                                "teacherName": course.teacherName,
                                "teacherId": course.teacherId
                              },
                            );
                          },
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              CircleAvatar(
                                radius: 24.r,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(24.r),
                                  child: course.teacherInfo?.image != null
                                      ? CachedNetworkImage(
                                          imageUrl:
                                              "${AppConstance.baseUrl}/storage/${course.teacherInfo?.image}",
                                        )
                                      : Image.asset(
                                          "assets/images/edzo_logo.png",
                                        ),
                                ),
                              ),
                              SizedBox(width: 16.w),
                              Text(
                                course.teacherName ?? "",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18.sp,
                                ),
                              ),
                              Spacer(),
                            SessionHelper.user == null ? SizedBox.shrink() :  Row(
                                children: [
                                  Icon(Icons.people),
                                  SizedBox(width: 8.w),
                                  Text(
                                    course.subscribersCount.toString(),
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
