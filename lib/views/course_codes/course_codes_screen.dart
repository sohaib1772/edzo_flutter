import 'package:edzo/controllers/course_codes_controller.dart';
import 'package:edzo/core/widgets/app_text_button.dart';
import 'package:edzo/core/widgets/course_card_loading_skeleton.dart';
import 'package:edzo/core/widgets/scaffold/app_scaffold.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class CourseCodesScreen extends StatelessWidget {
  CourseCodesScreen({super.key});
  CourseCodesController controller = Get.find();
  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: "الاكواد",
      body: Obx(
        () => controller.isLoading.value
            ? CourseCardLoadingSkeleton(
                onRefresh: () async {
                  await controller.getCourseCodes();
                },
            )
            : SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Column(
                  children: [
                    SizedBox(height: 20.h),
                    controller.codes.length < 10
                        ? AppTextButton(
                            isLoading: controller.isLoading.value,
                            onPressed: () => controller.addNewCodes(),
                            title: "طلب اكواد اضافية",
                          )
                        : SizedBox.shrink(),
                    SizedBox(height: 20.h),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: controller.codes.length,
                      itemBuilder: (_, index) {
                        return GestureDetector(
                          onTap: () => controller.copyCode(
                            controller.codes[index].code ?? "",
                            index,
                          ),
                          child: Obx(
                            () => Container(
                              alignment: Alignment.center,
                              margin: EdgeInsets.symmetric(
                                vertical: 5.h,
                                horizontal: 10.w,
                              ),
                              padding: EdgeInsets.symmetric(
                                horizontal: 10.w,
                                vertical: 5.h,
                              ),
                              height: 60.h,
                              decoration: BoxDecoration(
                                color: controller.selectedIndex.value == index ? Colors.green.shade300.withAlpha(40) :  Theme.of(context).cardColor,
                                borderRadius: BorderRadius.circular(16.r),
                                border: controller.selectedIndex.value == index
                                    ? Border.all(
                                        color: Colors.green.shade300,
                                        width: 2.w,
                                      )
                                    : null,
                              ),

                              child: Text(
                                "########### ${index + 1}" ,
                                style: TextStyle(
                                  fontSize: 36.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
