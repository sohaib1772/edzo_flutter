import 'package:edzo/controllers/bunny_upload_controller.dart';
import 'package:edzo/core/constance/app_router_keys.dart';
import 'package:edzo/core/widgets/app_text_button.dart';
import 'package:edzo/core/widgets/app_text_form.dart';
import 'package:edzo/models/course_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class AddBunnyVideoDialog extends StatefulWidget {
  const AddBunnyVideoDialog({super.key, this.courseId, this.playlistId});
  final int? courseId;
  final int? playlistId;

  @override
  State<AddBunnyVideoDialog> createState() => _AddBunnyVideoDialogState();
}

class _AddBunnyVideoDialogState extends State<AddBunnyVideoDialog> {
  late BunnyUploadController controller;
  late CourseModel courseModel;

  @override
  void initState() {
    super.initState();
    controller = Get.find<BunnyUploadController>();
    if (widget.courseId == null) {
      courseModel = Get.arguments['courseModel'];
    } else {
      courseModel = CourseModel(
        id: widget.courseId,
        isSubscribed: false,
        isPin: false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      constraints: BoxConstraints(maxWidth: 500.w),
      child: Container(
        padding: EdgeInsets.all(20.r),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "رفع فيديو على السيرفر",
                style: TextStyle(
                  fontSize: 20.sp.clamp(20, 24),
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20.h),

              // ── Title Field ──
              AppTextForm(
                hint: "عنوان الفيديو",
                controller: controller.titleController,
              ),
              SizedBox(height: 16.h),

              // ── Pick Video Button ──
              Obx(
                () => GestureDetector(
                  onTap: () => controller.pickVideo(),
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(14.r),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.r),
                      border: Border.all(
                        color: controller.filePicked.value
                            ? Colors.green
                            : Theme.of(context).dividerColor,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          controller.filePicked.value
                              ? Icons.check_circle
                              : Icons.video_library_outlined,
                          color: controller.filePicked.value
                              ? Colors.green
                              : null,
                        ),
                        SizedBox(width: 10.w),
                        Expanded(
                          child: Text(
                            controller.filePicked.value
                                ? controller.fileName.value
                                : "اختر فيديو من الجهاز",
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontSize: 14.sp),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16.h),

              // ── Paid Checkbox ──
              Obx(
                () => Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Checkbox(
                      value: controller.isPaid.value,
                      onChanged: (v) => controller.isPaid.value = v!,
                    ),
                    Text(
                      "مدفوع ؟",
                      style: TextStyle(
                        fontSize: 18.sp.clamp(18, 20),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20.h),

              // ── Upload Button ──
              AppTextButton(
                title: "بدء الرفع",
                onPressed: () {
                  if (controller.pickedFile != null &&
                      controller.titleController.text.trim().isNotEmpty) {
                    controller.uploadBunny(
                      courseModel.id ?? 0,
                      widget.playlistId,
                    );
                    Get.back(); // Close dialog immediately
                    Get.snackbar(
                      "بدأ الرفع",
                      "يمكنك متابعة التقدم من شاشة المراقبة",
                      duration: const Duration(seconds: 4),
                      mainButton: TextButton(
                        onPressed: () =>
                            Get.toNamed(AppRouterKeys.uploadsMonitoringScreen),
                        child: const Text("مراقبة"),
                      ),
                    );
                  } else {
                    Get.snackbar("خطأ", "يرجى إكمال البيانات");
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
