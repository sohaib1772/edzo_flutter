import 'package:drag_and_drop_lists/drag_and_drop_list.dart';
import 'package:drag_and_drop_lists/drag_and_drop_lists.dart';
import 'package:edzo/controllers/edit_course_controller.dart';
import 'package:edzo/core/constance/app_router_keys.dart';
import 'package:edzo/core/widgets/app_text_button.dart';
import 'package:edzo/core/widgets/scaffold/app_scaffold.dart';
import 'package:edzo/views/edit_course/widgets/add_video_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class CourseVideosListScreen extends StatelessWidget {
  CourseVideosListScreen({super.key});
  final EditCourseController controller = Get.find<EditCourseController>();

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: "الدروس",
      leading: IconButton(
        onPressed: () {
          int courseId = controller.courseModel.id ?? 0;
          Get.dialog(AddVideoDialog(courseId: courseId));
        },
        icon: Icon(Icons.add, size: 30.sp.clamp(30, 34)),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.videos.isEmpty) {
          return const Center(child: Text("لا يوجد دروس حتى الآن"));
        }

        return ReorderableListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          itemCount: controller.videos.length,
          onReorder: (oldIndex, newIndex) {
            if (newIndex > oldIndex) newIndex--;
            final item = controller.videos.removeAt(oldIndex);
            controller.videos.insert(newIndex, item);
            controller.updateOrder(); // تحديث الترتيب في السيرفر أو DB
          },
          itemBuilder: (context, index) {
            final video = controller.videos[index];
            return Card(
              key: ValueKey(video.id ?? index), // ضروري جداً لـ ReorderableListView
              margin: EdgeInsets.symmetric(vertical: 5.h),
              child: ListTile(
                title: Text(
                  video.title ?? "",
                  style: TextStyle(fontSize: 18.sp.clamp(18, 22)),
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    Get.dialog(
                      AlertDialog(
                        title: const Text("هل أنت متأكد من حذف الفيديو؟"),
                        actions: [
                          AppTextButton(
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
            );
          },
        );
      }),
    );
  }
}
