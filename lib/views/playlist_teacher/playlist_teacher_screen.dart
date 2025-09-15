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
  PlaylistTeacherScreen({super.key});

  @override
  State<PlaylistTeacherScreen> createState() => _PlaylistTeacherScreenState();
}

class _PlaylistTeacherScreenState extends State<PlaylistTeacherScreen> {
  TeacherPlaylistController controller = Get.find();
  int courseId = Get.arguments;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller.getPlaylists(courseId);

  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      body: Obx(() =>controller.isLoading.value?Center(child: CircularProgressIndicator()):
      SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(
          parent: BouncingScrollPhysics()
        ),
        child: Column(
          children: [
            SizedBox(height: 20.h,),

            AppTextButton(title: "اضافة",onPressed: (){
              Get.dialog(
                AddPlaylistDialog(  courseId)
              );
            },),
            SizedBox(height: 20.h,),
            ListView.builder(
              shrinkWrap: true,
              itemCount: controller.playlists.length,
              itemBuilder: (_, index) {
                return ExpansionTile(
                  title: Text(controller.playlists[index].title ?? ""),
                  trailing: IconButton(icon: Icon(Icons.edit),onPressed: (){
                    Get.dialog(
                      UpdatePlaylistDialog( controller.playlists[index], courseId)
                    );
                  },),
                  children: [
                    AppTextButton(title: "اضافة فيديو", onPressed: (){
                      Get.dialog(AddVideoDialog(
                        courseId: courseId,
                        playlistId: controller.playlists[index].id,
                      ));
                    }, ),
                    SizedBox(height: 10.h,),
                    Column(children: List.generate(
                    controller.playlists[index].videos?.length ?? 0,
                    (generator) => Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              controller
                                      .playlists[index]
                                      .videos![generator]
                                      .title ??
                                  "",
                                  overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Obx(
                            ()=> Get.find<EditCourseController>().isLoading.value ? Container(
                              padding: EdgeInsets.all(10.r),
                              height: 40.h,
                              width: 40.w,
                              child: CircularProgressIndicator(
                                
                              ),
                            ):
                            IconButton(onPressed: (){
                              Get.find<EditCourseController>().deleteCourseVideo(
                                controller.playlists[index].videos![generator].id ?? 0,
                                courseId: courseId,
                              );
                            }, icon: Icon(Icons.delete)),
                          )
                        ],
                      ),
                    ),
                  ),)
                  ]
                );
              },
            ),
          ],
        ),
      ),)
    );
  }
}
