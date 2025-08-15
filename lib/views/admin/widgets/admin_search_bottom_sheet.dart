import 'package:edzo/controllers/admin_controller.dart';
import 'package:edzo/core/helpers/role_helper.dart';
import 'package:edzo/core/widgets/app_text_form.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_popup/flutter_popup.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class AdminSearchBottomSheet extends StatelessWidget {
  AdminSearchBottomSheet({super.key});

  final controller = Get.find<AdminController>();

  
  @override
  Widget build(BuildContext context) {
    return Container(
                  padding: EdgeInsets.all(20),
                  height: MediaQuery.of(context).size.height * 0.8,
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  child: Column(
                    children: [
                      AppTextForm(
                        hint: "ابحث",
                        controller: controller.searchController,
                        onChanged: (p0) {
                          controller.userSearch();
                        },
                      ),
                      SizedBox(height: 20.h),
                      Obx(
                        () => controller.isSearchLoading.value
                            ? Center(child: CircularProgressIndicator())
                            : ListView.builder(
                                shrinkWrap: true,
                                itemCount: controller.users.length,
                                itemBuilder: (context, index) {
                                  return GetBuilder<AdminController>(
                                    init: controller,
                                    builder: (_)=>ListTile(
                                      leading: Icon(Icons.person),
                                      title: Text(
                                        controller.users[index].name.toString(),
                                      ),
                                      subtitle: Text(
                                        RoleHelper.getRole(controller.users[index].role ?? ""),
                                      ),
                                      trailing: CustomPopup(
                                        backgroundColor: Colors.transparent,
                                        content: Container(
                                          padding: EdgeInsets.all(5),
                                          width: 150.w,
                                          decoration: BoxDecoration(
                                            color: Theme.of(context).cardColor,
                                            borderRadius: BorderRadius.circular(
                                              20,
                                            ),
                                          ),
                                          child: Obx(
                                            () =>
                                                controller.isSetRoleLoading.value
                                                ? Center(
                                                    child:
                                                        CircularProgressIndicator(),
                                                  )
                                                : Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment.start,
                                                    children: [
                                                      TextButton(
                                                        onPressed: () {
                                                          controller.setUserRole(
                                                            Role.teacher.name,
                                                            controller
                                                                    .users[index]
                                                                    .id ??
                                                                0,
                                                          );
                                                        },
                                                        child: Text(
                                                          "تعيين كمدرس",
                                                        ),
                                                      ),
                                                      Divider(),
                                                      TextButton(
                                                        onPressed: () {
                                                          controller.setUserRole(
                                                            Role.student.name,
                                                            controller
                                                                    .users[index]
                                                                    .id ??
                                                                0,
                                                          );
                                                        },
                                                        child: Text(
                                                          "تعيين كطالب",
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                          ),
                                        ),
                                        child: Icon(Icons.more_vert),
                                      ),
                                    ),
                                  );
                                },
                              ),
                      ),
                    ],
                  ),
                );
  }
}