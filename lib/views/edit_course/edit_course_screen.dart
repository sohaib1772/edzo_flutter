import 'dart:io';

import 'package:drag_and_drop_lists/drag_and_drop_lists.dart';
import 'package:edzo/controllers/add_course_controller.dart';
import 'package:edzo/controllers/edit_course_controller.dart';
import 'package:edzo/controllers/upload_video_controller.dart';
import 'package:edzo/core/constance/app_router_keys.dart';
import 'package:edzo/core/helpers/app_form_validator.dart';
import 'package:edzo/core/services/app_services.dart';
import 'package:edzo/core/widgets/app_text_button.dart';
import 'package:edzo/core/widgets/app_text_form.dart';
import 'package:edzo/core/widgets/scaffold/app_scaffold.dart';
import 'package:edzo/models/course_model.dart';
import 'package:edzo/views/edit_course/widgets/add_video_dialog.dart';
import 'package:edzo/views/edit_course/widgets/edit_course_form_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class EditCourseScreen extends StatelessWidget {
  EditCourseScreen({super.key});

  final EditCourseController controller = Get.find<EditCourseController>();

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: "تعديل الدورة",
      body: GetBuilder<EditCourseController>(
        init: controller,
        builder: (_) => RefreshIndicator(
          onRefresh: () => controller.getCourseVideos(),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics(),
            ),
            child: Center(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  double width = constraints.maxWidth;
                  if (constraints.maxWidth > 500) {
                    width = 500;
                  }

                  return SizedBox(
                    width: width,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        SizedBox(height: 20.h),

                        /// فورم تعديل الكورس
                        Obx(() => controller.isDelete.value
                            ? _buildDeletedView(context)
                            : EditCourseFormWidget()),

                        Obx(() => controller.isDelete.value
                            ? SizedBox(height: 20.h)
                            : _buildVideosSection(context)),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDeletedView(BuildContext context) {
    return Center(
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
            Icon(Icons.check, color: Colors.green, size: 60.sp),
            SizedBox(height: 20.h),
            Text(
              "تم حذف الدورة",
              style: TextStyle(fontSize: 20.sp.clamp(20, 24)),
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
    );
  }

  Widget _buildVideosSection(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 20.h),
        AppTextButton(
          title: "عرض الاكواد",
          onPressed: () {
            Get.toNamed(
              AppRouterKeys.courseCodes,
              arguments: {"courseId": controller.courseModel.id},
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
                fontSize: 20.sp.clamp(20, 24),
              ),
            ),
            Spacer(),
            IconButton(
              onPressed: () {
                int courseId = controller.courseModel.id ?? 0;
                Get.dialog(AddVideoDialog(courseId: courseId));
              },
              icon: Icon(Icons.add, size: 30.sp.clamp(30, 34)),
            ),
          ],
        ),
        SizedBox(height: 10.h),

        /// القائمة القابلة للسحب والإفلات
        Obx(() {
          if (controller.videos.isEmpty && !controller.isLoading.value) {
            return Center(child: Text("لا يوجد دروس حتى الان"));
          } else if (controller.isLoading.value) {
            return Center(child: CircularProgressIndicator());
          }

          return SizedBox(
  height: MediaQuery.of(context).size.height * 0.3, // أو ارتفاع ثابت مثل 400
  child: DragAndDropLists(
    listPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    listDraggingWidth: MediaQuery.of(Get.context!).size.width * 0.95,
    children: [
      DragAndDropList(
        children: List.generate(controller.videos.length, (index) {
          final video = controller.videos[index];
          return DragAndDropItem(
            child: Card(
              margin: EdgeInsets.symmetric(vertical: 5.h),
              child: ListTile(
                title: Text(
                  video.title ?? "",
                  style: TextStyle(fontSize: 18.sp),
                ),
                trailing: IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    Get.dialog(
                      AlertDialog(
                        title: Text("هل أنت متأكد من حذف الفيديو؟"),
                        actions: [
                          AppTextButton(
                            isLoading: controller.isLoading.value,
                            title: "نعم",
                            onPressed: () {
                              controller.deleteCourseVideo(video.id ?? 0);
                            },
                            color: Colors.red.shade300,
                          ),
                          AppTextButton(
                            title: "لا",
                            onPressed: () => Get.back(),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                onTap: () {
                  Get.toNamed(
                    AppRouterKeys.videoPlayerScreen,
                    arguments: {
                      "videoModel": video,
                      "courseVideos": controller.videos,
                      "courseModel": controller.courseModel,
                    },
                  );
                },
              ),
            ),
          );
        }),
      )
    ],
    onListReorder: (oldListIndex, newListIndex) => {},
    onItemReorder: (oldItemIndex, oldListIndex, newItemIndex, newListIndex) {
      controller.videos.insert(
        newItemIndex,
        controller.videos.removeAt(oldItemIndex),
      );
      controller.updateOrder();
    },
    contentsWhenEmpty: Center(child: Text("لا يوجد فيديوهات")),
  ),
);
        }),

        SizedBox(height: 20.h),
        AppTextButton(
          title: "قوائم التشغيل",
          onPressed: () {
            Get.toNamed(
              AppRouterKeys.teacherPlaylistsScreen,
              arguments: controller.courseModel.id ?? 0,
            );
          },
        ),
      ],
    );
  }
}
