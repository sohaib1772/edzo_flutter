import 'package:edzo/controllers/edit_course_controller.dart';
import 'package:edzo/core/constance/app_router_keys.dart';
import 'package:edzo/core/widgets/app_text_button.dart';
import 'package:edzo/core/widgets/scaffold/app_scaffold.dart';
import 'package:edzo/views/edit_course/widgets/add_video_dialog.dart';
import 'package:edzo/views/edit_course/widgets/add_vimeo_video_dialog.dart';
import 'package:edzo/controllers/vimeo_upload_controller.dart';
import 'package:edzo/models/video_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:edzo/controllers/bunny_upload_controller.dart';

class CourseVideosListScreen extends StatelessWidget {
  CourseVideosListScreen({super.key});
  final EditCourseController controller = Get.find<EditCourseController>();

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: "الدروس",
      actions: [
        IconButton(
          onPressed: () {
            int courseId = controller.courseModel.id ?? 0;
            Get.dialog(AddVideoDialog(courseId: courseId));
          },
          icon: Icon(Icons.link, size: 28.sp.clamp(24, 32)),
          tooltip: "اضافة رابط",
        ),
        IconButton(
          onPressed: () {
            int courseId = controller.courseModel.id ?? 0;
            Get.dialog(AddVimeoVideoDialog(courseId: courseId));
          },
          icon: Icon(Icons.upload, size: 28.sp.clamp(24, 32)),
          tooltip: "رفع على السيرفر",
        ),
        IconButton(
          onPressed: () => Get.toNamed(AppRouterKeys.uploadsMonitoringScreen),
          icon: Obx(() {
            final vimeoController = Get.find<VimeoUploadController>();
            final bunnyController = Get.find<BunnyUploadController>();
            final hasActive = vimeoController.tasks.any(
                  (t) => t.status.value == UploadStatus.uploading,
                ) ||
                bunnyController.tasks.any(
                  (t) => t.status.value == UploadStatus.uploading,
                );
            return Stack(
              children: [
                Icon(Icons.cloud_upload_outlined, size: 28.sp.clamp(24, 32)),
                if (hasActive)
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 10,
                        minHeight: 10,
                      ),
                    ),
                  ),
              ],
            );
          }),
          tooltip: "مراقبة الرفع",
        ),
      ],
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
              key: ValueKey(
                video.id ?? index,
              ), // ضروري جداً لـ ReorderableListView
              margin: EdgeInsets.symmetric(vertical: 5.h),
              child: ListTile(
                title: Text(
                  video.title ?? "",
                  style: TextStyle(fontSize: 18.sp.clamp(18, 22)),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.blue),
                      onPressed: () {
                        final TextEditingController titleController =
                            TextEditingController(text: video.title);
                        Get.dialog(
                          AlertDialog(
                            title: const Text("تعديل عنوان الفيديو"),
                            content: TextField(
                              controller: titleController,
                              decoration: const InputDecoration(
                                hintText: "العنوان الجديد",
                              ),
                            ),
                            actions: [
                              AppTextButton(
                                title: "تعديل",
                                onPressed: () {
                                  if (titleController.text.isNotEmpty) {
                                    controller.updateVideoTitle(
                                      video.id ?? 0,
                                      titleController.text,
                                    );
                                    Get.back();
                                  }
                                },
                              ),
                              AppTextButton(
                                title: "إلغاء",
                                onPressed: () => Get.back(),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    IconButton(
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
                                  Get.back();
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
                  ],
                ),
                onTap: () {
                  final arguments = {
                    "videoModel": video,
                    "courseVideos": controller.videos,
                    "courseModel": controller.courseModel,
                  };
                  if (video.isVimeo) {
                    Get.toNamed(
                      AppRouterKeys.vimeoPlayerScreen,
                      arguments: arguments,
                    );
                  } else if (video.isBunny) {
                    Get.toNamed(
                      AppRouterKeys.bunnyPlayerScreen,
                      arguments: arguments,
                    );
                  } else if (video.isYoutube) {
                    Get.toNamed(
                      AppRouterKeys.videoPlayerScreen,
                      arguments: arguments,
                    );
                  }
                },
              ),
            );
          },
        );
      }),
    );
  }
}
