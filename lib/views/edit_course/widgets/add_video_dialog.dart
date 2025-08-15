import 'package:edzo/controllers/upload_video_controller.dart';
import 'package:edzo/core/helpers/app_form_validator.dart';
import 'package:edzo/core/widgets/app_text_button.dart';
import 'package:edzo/core/widgets/app_text_form.dart';
import 'package:edzo/models/course_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

class AddVideoDialog extends StatelessWidget {
  AddVideoDialog({super.key});
  UploadVideoController uploadVideoController = Get.find();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  CourseModel courseModel = Get.arguments['courseModel'];
  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        padding: EdgeInsets.all(20.r),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Form(
          key: formKey,
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "اضافة درس",
                  style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20.h),
                Obx(
                  () => Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16.r),
                      color: Theme.of(context).colorScheme.surface,
                    ),
                    height: 200.h,
                    width: double.infinity,
                    child: uploadVideoController.isPicked.value
                        ? GestureDetector(
                            onTap: () async {
                              if(uploadVideoController.isUploading.value) return;
                              await uploadVideoController.pickVideo();
                            },
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(16.r),
                              child: Image.memory(
                                uploadVideoController.thumbnailBytes!,
            
                                fit: BoxFit.cover,
                              ),
                            ),
                          )
                        : GestureDetector(
                            onTap: () async {
                               if(uploadVideoController.isUploading.value) return;
                              await uploadVideoController.pickVideo();
                            },
                            child: Container(
                              padding: EdgeInsets.all(20.r),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16.r),
                                color: Theme.of(context).colorScheme.surface,
                              ),
                              alignment: Alignment.center,
                              height: 100.h,
                              width: double.infinity,
                              child: Text(
                                "لم يتم اختيار الفيديو",
                                style: TextStyle(
                                  fontSize: 20.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                  ),
                ),
                SizedBox(height: 20.h),
                Obx(
                  ()=> AppTextForm(
                    enabled: !uploadVideoController.isUploading.value,
                    hint: "العنوان",
                    validator: (value) {
                      if (AppFormValidator.isEmpty(value ?? ""))
                        return 'العنوان مطلوب';
                      return null;
                    },
                    controller: uploadVideoController.titleController,
                  ),
                ),
                SizedBox(height: 20.h),
                Obx(
                  () => Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Checkbox(
                        value: uploadVideoController.isPaid.value,
                        onChanged: (value) {
                           if(uploadVideoController.isUploading.value) return;
                            uploadVideoController.isPaid.value = value!;},
                      ),
                      Text(
                        "مدفوع ؟",
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10.h),
                Obx(
                  () => uploadVideoController.isUploading.value
                      ? Column(
                          children: [
                            Text(
                              '${(uploadVideoController.progress.value * 100).toStringAsFixed(0)}%',
                            ),
                            SizedBox(height: 10.h),
                            LinearProgressIndicator(
                              value: uploadVideoController.progress.value,
                            ),
                            SizedBox(height: 10.h),
                          
                            Text(
                              "لا تغادر التطبيق اثناء رفع الفيديو",
                              style: TextStyle(
                                fontSize: 18.sp,
                                fontWeight: FontWeight.bold,
                                color: Colors.red.shade300,
                              ),
                            ),
                          ],
                        )
                      : SizedBox.shrink(),
                ),
                SizedBox(height: 10.h),
                Obx(
                  ()=> AppTextButton(
                    isLoading: uploadVideoController.isUploading.value,
                    title: uploadVideoController.unableToUpload.value ? "اعادة المحاولة" : "اضافة",
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        uploadVideoController.uploadVideo(courseModel.id ?? 0);
                      }
                    },
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
