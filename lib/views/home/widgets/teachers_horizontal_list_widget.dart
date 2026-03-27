import 'package:cached_network_image/cached_network_image.dart';
import 'package:edzo/controllers/home_controller.dart';
import 'package:edzo/core/constance/app_router_keys.dart';
import 'package:edzo/models/teacher_info_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:edzo/core/constance/app_constance.dart';

class TeachersHorizontalListWidget extends StatelessWidget {
  const TeachersHorizontalListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController>();

    return Obx(() {
      if (controller.isTeachersLoading.value && controller.teachers.isEmpty) {
        return const SizedBox.shrink(); // Or a loading shimmer
      }

      if (controller.teachers.isEmpty) {
        return const SizedBox.shrink();
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () {
                    Get.toNamed(AppRouterKeys.teachersScreen);
                  },
                  child: Text(
                    "See All",
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Get.theme.primaryColor,
                    ),
                  ),
                ),
                Text(
                  "Lectures",
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 160.h.clamp(160, 200),
            child: ListView.separated(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              scrollDirection: Axis.horizontal,
              itemCount: controller.teachers.length,
              separatorBuilder: (context, index) => SizedBox(width: 16.w),
              itemBuilder: (context, index) {
                final teacher = controller.teachers[index];
                return GestureDetector(
                  onTap: () {
                    Get.toNamed(
                      AppRouterKeys.teacherProfileScreen,
                      arguments: {
                        "teacherId": teacher.id,
                        "teacherName": teacher.name,
                        "teacherInfoModel": TeacherInfoModel(
                          bio: teacher.bio,
                          image: teacher.image,
                        ),
                      },
                    );
                  },
                  child: Column(
                    children: [
                      Container(
                        width: 70.r,
                        height: 70.r,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Get.theme.primaryColor.withOpacity(0.5),
                            width: 2,
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(35.r),
                          child:
                              (teacher.image != null &&
                                  teacher.image!.isNotEmpty)
                              ? CachedNetworkImage(
                                  imageUrl:
                                      "${AppConstance.baseUrl}/storage/${teacher.image}",
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) => const Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                  errorWidget: (context, url, error) =>
                                      Image.asset(
                                        "assets/images/edzo_logo.png",
                                        fit: BoxFit.cover,
                                      ),
                                )
                              : Image.asset(
                                  "assets/images/edzo_logo.png",
                                  fit: BoxFit.cover,
                                ),
                        ),
                      ),
                      SizedBox(height: 8.h),
                      SizedBox(
                        width: 80.r,
                        child: Text(
                          teacher.name ?? "استاذ",
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          SizedBox(height: 16.h),
        ],
      );
    });
  }
}
