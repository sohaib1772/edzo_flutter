import 'package:cached_network_image/cached_network_image.dart';
import 'package:edzo/controllers/teachers_controller.dart';
import 'package:edzo/core/constance/app_constance.dart';
import 'package:edzo/core/constance/app_router_keys.dart';
import 'package:edzo/core/widgets/scaffold/app_scaffold.dart';
import 'package:edzo/models/teacher_info_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class TeachersScreen extends StatelessWidget {
  TeachersScreen({super.key});

  final controller = Get.put(TeachersController());

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: "Lectures",
      padding: 0,
      body: Obx(() {
        if (controller.isLoading.value && controller.teachers.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        return RefreshIndicator(
          onRefresh: () => controller.getTeachers(),
          child: ListView.separated(
            padding: EdgeInsets.all(16.r),
            itemCount: controller.teachers.length,
            separatorBuilder: (context, index) => SizedBox(height: 16.h),
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
                child: Container(
                  padding: EdgeInsets.all(12.r),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(12.r),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 80.r,
                        height: 80.r,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Get.theme.primaryColor.withOpacity(0.3),
                            width: 2,
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(40.r),
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
                      SizedBox(width: 16.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              teacher.name ?? "أستاذ",
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            if (teacher.bio != null &&
                                teacher.bio!.isNotEmpty) ...[
                              SizedBox(height: 4.h),
                              Text(
                                teacher.bio!,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ],
                            SizedBox(height: 8.h),
                            Row(
                              children: [
                                _buildStat(
                                  Icons.book_outlined,
                                  "${teacher.coursesCount ?? 0} دورات",
                                ),
                                SizedBox(width: 16.w),
                                _buildStat(
                                  Icons.people_outline,
                                  "${teacher.totalStudentsCount ?? 0} مشتركين",
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Icon(
                        Icons.arrow_forward_ios,
                        size: 16.sp,
                        color: Colors.grey.shade400,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      }),
    );
  }

  Widget _buildStat(IconData icon, String label) {
    return Row(
      children: [
        Icon(icon, size: 14.sp, color: Get.theme.primaryColor),
        SizedBox(width: 4.w),
        Text(
          label,
          style: TextStyle(
            fontSize: 11.sp,
            fontWeight: FontWeight.w500,
            color: Colors.grey.shade700,
          ),
        ),
      ],
    );
  }
}
