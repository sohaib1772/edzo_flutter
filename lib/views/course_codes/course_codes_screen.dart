import 'package:edzo/controllers/course_codes_controller.dart';
import 'package:edzo/core/widgets/app_text_button.dart';
import 'package:edzo/core/widgets/scaffold/app_scaffold.dart';
import 'package:edzo/views/course_codes/widgets/course_code_card.dart';
import 'package:edzo/views/course_codes/widgets/course_codes_filter_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class CourseCodesScreen extends StatelessWidget {
  CourseCodesScreen({super.key});
  final CourseCodesController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: "إدارة الأكواد",
      body: Obx(
        () => controller.isLoading.value
            ? const Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  Padding(
                    padding: EdgeInsets.all(16.r),
                    child: AppTextButton(
                      isLoading: controller.isLoading.value,
                      onPressed: () => controller.addNewCodes(),
                      title: "طلب أكواد جديدة",
                    ),
                  ),
                  CourseCodesFilterSection(controller: controller),
                  Expanded(
                    child: Obx(
                      () => ListView.builder(
                        padding: EdgeInsets.symmetric(horizontal: 4.w),
                        itemCount: controller.filteredCodes.length,
                        itemBuilder: (_, index) {
                          final code = controller.filteredCodes[index];
                          return CourseCodeCard(
                            code: code,
                            index: index,
                            controller: controller,
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
