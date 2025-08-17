import 'dart:io';

import 'package:Edzo/controllers/add_course_controller.dart';
import 'package:Edzo/controllers/edit_course_controller.dart';
import 'package:Edzo/controllers/upload_video_controller.dart';
import 'package:Edzo/core/constance/app_router_keys.dart';
import 'package:Edzo/core/helpers/app_form_validator.dart';
import 'package:Edzo/core/services/app_services.dart';
import 'package:Edzo/core/widgets/app_text_button.dart';
import 'package:Edzo/core/widgets/app_text_form.dart';
import 'package:Edzo/core/widgets/scaffold/app_scaffold.dart';
import 'package:Edzo/models/course_model.dart';
import 'package:Edzo/views/edit_course/widgets/add_video_dialog.dart';
import 'package:Edzo/views/edit_course/widgets/edit_course_form_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class EditCourseScreen extends StatelessWidget {
  EditCourseScreen({super.key});
  EditCourseController controller = Get.find<EditCourseController>();
  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: "تعديل الدورة",
      body: GetBuilder(
        init: controller,

        builder: (controller) => RefreshIndicator(
          onRefresh: () => controller.getCourseVideos(),
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics(),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Obx(
                  () => controller.isDelete.value
                      ? Center(
                          child: Container(
                            margin: EdgeInsets.all(20.r),
                            padding: EdgeInsets.all(20.r),
                            decoration: BoxDecoration(
                              color: Theme.of(context).cardColor,
                              borderRadius: BorderRadius.circular(16.r),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(height: 20.h),
                                Icon(
                                  Icons.check,
                                  color: Colors.green,
                                  size: 60.sp,
                                ),
                                SizedBox(height: 20.h),
                                Text(
                                  "تم حذف الدورة",
                                  style: TextStyle(fontSize: 20.sp),
                                ),
                                SizedBox(height: 20.h),
                                AppTextButton(
                                  title: "العودة الى الصفحة السابقة",
                                  onPressed: () {
                                    Get.back();
                                  },
                                ),
                              ],
                            ),
                          ),
                        )
                      : EditCourseFormWidget(),
                ),
                Obx(
                  () => controller.isDelete.value
                      ? SizedBox(height: 20.h)
                      : Column(
                          children: [
                            SizedBox(height: 20.h),
                            AppTextButton(
                              title: "عرض الاكواد",
                              onPressed: () {
                                Get.toNamed(
                                  AppRouterKeys.courseCodes,
                                  arguments: {
                                    "courseId": controller.courseModel.id,
                                  },
                                );
                              },
                            ),
                            SizedBox(height: 20.h),
                            Divider(),
                            SizedBox(height: 20.h),
                            Row(
                              children: [
                                Text(
                                  "الدروس",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20.sp,
                                  ),
                                ),
                                Spacer(),
                                IconButton(
                                  onPressed: () {
                                    Get.dialog(AddVideoDialog());
                                  },
                                  icon: Icon(Icons.add, size: 30.sp),
                                ),
                              ],
                            ),
                            SizedBox(height: 10.h),
                            Obx(
                              () =>
                                  controller.videos.isEmpty &&
                                      !controller.isLoading.value
                                  ? Center(child: Text("لا يوجد دروس حتى الان"))
                                  : controller.isLoading.value
                                  ? Center(child: CircularProgressIndicator())
                                  : ListView.builder(
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      itemCount: controller.videos.length,
                                      itemBuilder: (context, index) {
                                        return GestureDetector(
                                          onTap: () {
                                            Get.toNamed(
                                              AppRouterKeys.videoPlayerScreen,
                                              arguments: {
                                                "videoModel":
                                                    controller.videos[index],
                                                    "courseVideos":
                                                    controller.videos,
                                                    "courseModel":
                                                    controller.courseModel,
                                              },
                                            );
                                          },
                                          child: Container(
                                            height: 80.h,
                                            margin: EdgeInsets.symmetric(
                                              vertical: 5.h,
                                            ),
                                            padding: EdgeInsets.all(10.r),
                                            decoration: BoxDecoration(
                                              color: Theme.of(
                                                context,
                                              ).cardColor,
                                              borderRadius:
                                                  BorderRadius.circular(16.r),
                                            ),
                                            child: Row(
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    controller
                                                            .videos[index]
                                                            .title ??
                                                        "",
                                                    style: TextStyle(
                                                      fontSize: 20.sp,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    maxLines: 1,
                                                  ),
                                                ),

                                                Obx(
                                                  () =>
                                                      controller.editMode.value
                                                      ? IconButton(
                                                          onPressed: () {
                                                            Get.dialog(
                                                              AlertDialog(
                                                                title: Text(
                                                                  "هل أنت متأكد من حذف الفيديو؟",
                                                                ),
                                                                actions: [
                                                                  AppTextButton(
                                                                    isLoading: controller
                                                                        .isLoading
                                                                        .value,
                                                                    title:
                                                                        "نعم",
                                                                    onPressed: () {
                                                                      controller.deleteCourseVideo(
                                                                        controller.videos[index].id ??
                                                                            0,
                                                                      );
                                                                    },
                                                                    color: Colors
                                                                        .red
                                                                        .shade300,
                                                                  ),
                                                                  SizedBox(
                                                                    height:
                                                                        10.h,
                                                                  ),
                                                                  AppTextButton(
                                                                    isLoading: controller
                                                                        .isLoading
                                                                        .value,
                                                                    title: "لا",
                                                                    onPressed: () =>
                                                                        Get.back(),
                                                                  ),
                                                                ],
                                                              ),
                                                            );
                                                          },
                                                          icon: Icon(
                                                            Icons.delete,
                                                            color: Colors
                                                                .red
                                                                .shade300,
                                                          ),
                                                        )
                                                      : Icon(
                                                          Icons
                                                              .arrow_forward_ios,
                                                          size: 30.sp,
                                                        ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                            ),
                          ],
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
