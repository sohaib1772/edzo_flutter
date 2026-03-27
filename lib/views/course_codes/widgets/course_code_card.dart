import 'package:edzo/controllers/course_codes_controller.dart';
import 'package:edzo/models/code_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CourseCodeCard extends StatelessWidget {
  final CodeModel code;
  final int index;
  final CourseCodesController controller;

  const CourseCodeCard({
    super.key,
    required this.code,
    required this.index,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    Color statusColor;
    String statusText;
    Color textColor;
    IconData statusIcon;

    switch (code.status) {
      case 1:
        statusColor = Theme.of(context).cardColor;
        statusText = "تم النسخ";
        textColor = Colors.grey.shade800;
        statusIcon = Icons.content_copy_outlined;
        break;
      case 2:
        statusColor = Theme.of(context).cardColor;
        statusText = "مستعمل";
        textColor = Colors.grey.shade400;
        statusIcon = Icons.check_circle_outline;
        break;
      default:
        statusColor = Theme.of(context).cardColor;
        statusText = "لم يستعمل";
        textColor = Colors.grey.shade400;
        statusIcon = Icons.hourglass_empty;
    }

    final bool isUsed = code.status == 2;
    final String codeText = code.code ?? "";

    return Card(
      margin: EdgeInsets.only(bottom: 12.h),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      color: statusColor,
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        title: isUsed
            ? Text(
                codeText,
                style: TextStyle(
                  color: textColor,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                  decoration: TextDecoration.lineThrough,
                  decorationThickness: 2,
                ),
              )
            : SelectableText(
                codeText,
                style: TextStyle(
                  color: textColor,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 4.h),
            Row(
              children: [
                Icon(statusIcon, size: 16.sp, color: textColor),
                SizedBox(width: 4.w),
                Text(
                  statusText,
                  style: TextStyle(fontSize: 14.sp, color: textColor),
                ),
              ],
            ),
            if (isUsed && code.user != null) ...[
              SizedBox(height: 4.h),
              Text(
                "بواسطة: ${code.user?.name ?? 'طالب مجهول'}",
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.green.shade800,
                ),
              ),
            ],
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (!isUsed) ...[
              IconButton(
                icon: const Icon(Icons.share, color: Colors.blue),
                onPressed: () => controller.shareCode(code, index),
                tooltip: "مشاركة الكود",
              ),
              IconButton(
                icon: const Icon(Icons.copy),
                onPressed: () => controller.copyCode(code, index),
                tooltip: "نسخ الكود",
              ),
            ],
            SizedBox(width: 4.w),
            Text(
              "${index + 1}",
              style: TextStyle(
                color: textColor,
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
