import 'package:edzo/controllers/teacher_playlist_controller.dart';
import 'package:edzo/core/helpers/app_form_validator.dart';
import 'package:edzo/core/widgets/app_text_button.dart';
import 'package:edzo/core/widgets/app_text_form.dart';
import 'package:edzo/models/playlist_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

class UpdatePlaylistDialog extends StatefulWidget {
   UpdatePlaylistDialog(
    this.playlist,
    this.courseId,
   );

   PlaylistModel playlist;
  int courseId;

  @override
  State<UpdatePlaylistDialog> createState() => _UpdatePlaylistDialogState();
}

class _UpdatePlaylistDialogState extends State<UpdatePlaylistDialog> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final TextEditingController titleController = TextEditingController();

  TeacherPlaylistController controller = Get.find();
  

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    titleController.text = widget.playlist.title ?? "";
    
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      constraints: BoxConstraints(
        maxWidth: 500.w,
      ),
                  actionsAlignment: MainAxisAlignment.spaceBetween,
alignment: Alignment.center,
                  title: Text("تعديل القائمة"),
                  content: Form(
                    key: formKey,
                    child: AppTextForm(
                      maxLines: 4,
                      hint: "العنوان",
                      validator: (value) {
                        if (AppFormValidator.isEmpty(value ?? ""))
                          return 'العنوان مطلوب';
                        return null;
                      },
                      controller: titleController,
                    ),
                  ),
                  actions: [
                    Obx(
                      ()=> AppTextButton(
                        width: double.infinity,
                        isLoading: controller.isLoading.value,
                        onPressed: ()async{
                          await controller.deletePlaylist(widget.playlist.id ?? 0);
                      }, title: "حذف",color: Colors.red,),
                    ),
                    SizedBox(height: 10.w,),
                    Obx(
                      ()=> AppTextButton(
                         width: double.infinity,
                        isLoading: controller.isLoading.value,
                        onPressed: ()async{
                        if(formKey.currentState!.validate()){
                          controller.updatePlaylist(
                            AddPlaylistModel(
                              title: titleController.text,
                              courseId:widget.courseId,
                              id:widget.playlist.id,
                            ),
                          );
                        }
                      }, title: "حفظ"),
                    ),
                
                   
                  ]
                  );
  }
}