import 'package:drag_and_drop_lists/drag_and_drop_lists.dart';
import 'package:edzo/controllers/edit_course_controller.dart';
import 'package:edzo/controllers/teacher_playlist_controller.dart';
import 'package:edzo/core/helpers/app_form_validator.dart';
import 'package:edzo/core/widgets/app_text_button.dart';
import 'package:edzo/core/widgets/app_text_form.dart';
import 'package:edzo/core/widgets/scaffold/app_scaffold.dart';
import 'package:edzo/models/playlist_model.dart';
import 'package:edzo/views/edit_course/widgets/add_video_dialog.dart';
import 'package:edzo/views/playlist_teacher/widgets/add_playlist_dialog.dart';
import 'package:edzo/views/playlist_teacher/widgets/update_playlist_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class PlaylistTeacherScreen extends StatefulWidget {
  const PlaylistTeacherScreen({super.key});

  @override
  State<PlaylistTeacherScreen> createState() => _PlaylistTeacherScreenState();
}

class _PlaylistTeacherScreenState extends State<PlaylistTeacherScreen> {
  TeacherPlaylistController controller = Get.find();
  int courseId = Get.arguments;
  int? targetListIndex; // لتتبع القائمة المستهدفة

  @override
  void initState() {
    super.initState();
    controller.getPlaylists(courseId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("القوائم"), actions: [
        IconButton(
          onPressed: () {
            Get.dialog(AddPlaylistDialog(courseId));
          },
          icon: const Icon(Icons.add),
        )
      ]),
      body: Obx(
        () => controller.isLoading.value
            ? const Center(child: CircularProgressIndicator())
            : DragAndDropLists(listDraggingWidth: MediaQuery.of(context).size.width * 0.95,
                listPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                children: List.generate(controller.playlists.length, (
                  listIndex,
                ) {
                  final playlist = controller.playlists[listIndex];

                  return DragAndDropList(
                    key: ValueKey("playlist_${playlist.id}"),
                    decoration: BoxDecoration(
                            color: Theme.of(context).cardColor,
                            borderRadius: BorderRadius.circular(8),
                          ),
                    header: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Text(
                            playlist.title ?? "Untitled",
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Spacer(),
                          IconButton(
                            onPressed: () {
                              Get.dialog(UpdatePlaylistDialog(
                                  controller.playlists[listIndex], courseId));
                            },
                            icon: const Icon(Icons.edit),
                          ),
                          IconButton(
                            onPressed: () {
                              Get.dialog(AddVideoDialog(
                                courseId: courseId,
                                playlistId: controller.playlists[listIndex].id,
                              ));
                            },
                            icon: const Icon(Icons.add),
                          )
                        ],
                      ),
                    ),
                    children: List.generate(playlist.videos?.length ?? 0, (
                      itemIndex,
                    ) {
                      final video = playlist.videos![itemIndex];
                      return DragAndDropItem(
                        key: ValueKey("video_${video.id}"),
                        child: Card(
                          color: Theme.of(context).colorScheme.onPrimary,
                          child: ListTile(
                            title: Text(video.title ?? ""),
                            trailing: IconButton(
                              onPressed: () {
                                Get.find<EditCourseController>()
                                    .deleteCourseVideo(
                                  controller.playlists[listIndex]
                                          .videos![itemIndex].id ??
                                      0,
                                  courseId: courseId,
                                );
                              },
                              icon: const Icon(Icons.delete),
                            ),
                          ),
                        ),
                      );
                    }),
                  );
                }),
                onItemReorder:
                    (oldItemIndex, oldListIndex, newItemIndex, newListIndex) {
                  setState(() {
                    targetListIndex = null; // إلغاء التأثير بعد الإفلات
                    
                    // خذ الفيديو من القائمة القديمة
                    final movedVideo = controller.playlists[oldListIndex]
                        .videos!
                        .removeAt(oldItemIndex);

                    // لو نفس القائمة: نضيفه في مكانه الجديد
                    if (oldListIndex == newListIndex) {
                      controller.playlists[oldListIndex].videos!.insert(
                        newItemIndex,
                        movedVideo,
                      );
                    } else {
                      // قائمة جديدة: نضيفه للقائمة الجديدة
                      controller.playlists[newListIndex].videos!.insert(
                        newItemIndex,
                        movedVideo,
                      );
                    }
                  });

                  print("oldItemIndex: $oldItemIndex");
                  print("oldListIndex: $oldListIndex");
                  print("newItemIndex: $newItemIndex");
                  print("newListIndex: $newListIndex");
                  controller.updateOrder();
                },
                contentsWhenEmpty: AppTextButton(
                  onPressed: () {
                    Get.dialog(AddPlaylistDialog(courseId));
                  },
                  title: "اضافة",
                ),
                onListReorder: (oldListIndex, newListIndex) {
                  setState(() {
                    final movedList = controller.playlists.removeAt(
                      oldListIndex,
                    );
                    controller.playlists.insert(newListIndex, movedList);
                  });
                  controller.updatePlaylistsOrder();
                },
                listDecorationWhileDragging: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
      ),
    );
  }
}