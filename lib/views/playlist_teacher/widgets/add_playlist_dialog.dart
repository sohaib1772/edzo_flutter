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

class AddPlaylistDialog extends StatefulWidget {
  AddPlaylistDialog(this.courseId);

  int courseId;

  @override
  State<AddPlaylistDialog> createState() => _AddPlaylistDialogState();
}

class _AddPlaylistDialogState extends State<AddPlaylistDialog> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final TextEditingController titleController = TextEditingController();

  TeacherPlaylistController controller = Get.find();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      actionsAlignment: MainAxisAlignment.spaceBetween,

      title: Text("تعديل القائمة"),
      content: Form(
        key: formKey,
        child: AppTextForm(
          maxLines: 4,
          hint: "العنوان",
          validator: (value) {
            if (AppFormValidator.isEmpty(value ?? "")) return 'العنوان مطلوب';
            return null;
          },
          controller: titleController,
        ),
      ),
      actions: [
        Obx(
          () => AppTextButton(
            isLoading: controller.isLoading.value,
            onPressed: () async {
              if (formKey.currentState!.validate()) {
                controller.addPlaylist(
                  AddPlaylistModel(
                    title: titleController.text,
                    courseId: widget.courseId,
                  ),
                );
              }
            },
            title: "حفظ",
          ),
        ),
      ],
    );
  }
}
