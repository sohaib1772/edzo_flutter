import 'package:cached_network_image/cached_network_image.dart';
import 'package:edzo/controllers/admin_controller.dart';
import 'package:edzo/core/constance/app_constance.dart';
import 'package:edzo/core/constance/app_router_keys.dart';
import 'package:edzo/core/helpers/role_helper.dart';
import 'package:edzo/core/widgets/app_text_button.dart';
import 'package:edzo/core/widgets/app_text_form.dart';
import 'package:edzo/core/widgets/course_card_loading_skeleton.dart';
import 'package:edzo/views/admin/widgets/admin_search_bottom_sheet.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_popup/flutter_popup.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';

class AdminScreen extends StatelessWidget {
  AdminScreen({super.key});
  AdminController controller = Get.put(AdminController());
  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        await controller.getTeachers();
      },
      child: SingleChildScrollView(
        physics:  BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
      
          children: [
            Center(
              child: AppTextButton(
                width: double.infinity,
                color: Colors.grey.shade700,
                onPressed: () {
                  Get.bottomSheet(AdminSearchBottomSheet());
                },
                title: "بحث عن مستخدم",
                icon: Icons.search,
              ),
            ),
      
            Obx(
              () => controller.teachers.isEmpty && !controller.isLoading.value
                  ? Center(child: Text("لا يوجد مدربين"))
                  : controller.isLoading.value
                  ? CourseCardLoadingSkeleton(
                      onRefresh: () async {
                        await controller.getTeachers();
                      },
                  )
                  : ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: controller.teachers.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          onTap: () {
                            Get.toNamed(AppRouterKeys.teacherReportsScreen,
                                arguments: {
                                  "teachersInfoModel":
                                      controller.teachers[index]
                                });
                          },
                          leading: CircleAvatar(
                            radius: 24.r,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(24.r),
                              child:
                                  controller
                                          .teachers[index]
                                          .user
                                          ?.teacherInfo
                                          ?.image !=
                                      null
                                  ? CachedNetworkImage(
                                      imageUrl:
                                          "${AppConstance.baseUrl}/storage/${controller.teachers[index].user?.teacherInfo?.image}",
                                    )
                                  : Image.asset("assets/images/edzo_logo.png"),
                            ),
                          ),
                          title: Text(
                            controller.teachers[index].user?.name ?? "",
                          ),
                          subtitle: Text(
                            RoleHelper.getRole(
                              controller.teachers[index].user?.role ?? "",
                            ),
                          ),
                          trailing: Text("عدد الكورسات ${controller.teachers[index].user?.totalCoursesCount ?? 0}"),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
