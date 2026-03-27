import 'package:edzo/controllers/course_codes_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class CourseCodesFilterSection extends StatelessWidget {
  final CourseCodesController controller;

  const CourseCodesFilterSection({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: Obx(
        () => Row(
          children: [
            _buildFilterChip("الكل", -1),
            SizedBox(width: 8.w),
            _buildFilterChip("غير المستخدم", 0),
            SizedBox(width: 8.w),
            _buildFilterChip("المنسوخ", 1),
            SizedBox(width: 8.w),
            _buildFilterChip("المستخدم", 2),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label, int value) {
    bool isSelected = controller.selectedFilter.value == value;
    final primaryColor = Get.theme.primaryColor;

    return ChoiceChip(
      label: Text(
        label,
        style: TextStyle(
          color: isSelected ? Colors.white : primaryColor,
          fontSize: 14.sp,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
        ),
      ),
      selected: isSelected,
      onSelected: (selected) {
        if (selected) controller.changeFilter(value);
      },
      selectedColor: primaryColor,
      backgroundColor: primaryColor.withAlpha(30),
      showCheckmark: false,
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.r),
        side: BorderSide(
          color: isSelected ? primaryColor : primaryColor.withAlpha(60),
          width: 1,
        ),
      ),
    );
  }
}
