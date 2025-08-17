import 'package:Edzo/controllers/main_layout_controller.dart';
import 'package:Edzo/core/constance/app_router_keys.dart';
import 'package:Edzo/core/helpers/session_helper.dart';
import 'package:Edzo/core/widgets/app_text_button.dart';
import 'package:Edzo/core/widgets/app_text_form.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_popup/flutter_popup.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:get/get_core/src/get_main.dart';

class AppBarDefaultLeading extends StatelessWidget {
  AppBarDefaultLeading({super.key});
  MainLayoutController controller = Get.find();
  @override
  Widget build(BuildContext context) {
    return CustomPopup(
      backgroundColor: Colors.transparent,

      content: Obx(
        () => Container(
          padding: EdgeInsets.all(10.w),
          decoration: BoxDecoration(
            color: controller.isDarkMode.value
                ? Colors.grey.shade900
                : Colors.white,
            borderRadius: BorderRadius.circular(10.r),
          ),

          width: 180.w,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextButton(
                onPressed: () {
                  controller.changeTheme();
                },
                child: Row(
                  children: [
                    Icon(
                      !controller.isDarkMode.value
                          ? Icons.dark_mode
                          : Icons.light_mode,
                      color: Theme.of(context).colorScheme.tertiary,
                    ),
                    SizedBox(width: 10.w),
                    Text(
                      controller.isDarkMode.value
                          ? "الوضع الفاتح"
                          : "الوضع الليلي",
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.tertiary,
                      ),
                    ),
                  ],
                ),
              ),
              Divider(height: 18.h),
              TextButton(
                onPressed: () {
                  Get.toNamed(AppRouterKeys.privacyPolicy);
                },
                child: Text("الشروط و الاحكام"),
              ),
              Divider(height: 18.h),
            SessionHelper.user == null ? TextButton(onPressed: (){
              Get.toNamed(AppRouterKeys.loginScreen);
            }, child: Text("تسجيل الدخول")) :  Column(children: [
                controller.isLoading.value
                  ? Center(child: CircularProgressIndicator())
                  : TextButton(
                      child: Text(
                        "تسجيل الخروج",
                        style: TextStyle(color: Colors.red.shade300),
                      ),
                      onPressed: () {
                        controller.logout();
                      },
                    ),
              Divider(height: 28.h),
              controller.isLoading.value
                  ? Center(child: CircularProgressIndicator())
                  : TextButton(
                      child: Text(
                        "حذف الحساب",
                        style: TextStyle(color: Colors.red.shade300),
                      ),
                      onPressed: () {
                        Get.dialog(
                          AlertDialog(
                            title: Text("حذف الحساب"),
                            content: Text("هل تريد حذف الحساب؟"),
                            actions: [
                              Form(
                                key: controller.formKey,
                                child: AppTextForm(
                                  hint: "يرجى كتابة نعم لاتمام العملية",
                                  controller: controller.deleteAccountConfirmationController,
                                  validator: (p0) {
                                    if (p0 != "نعم") {
                                      return "يرجى كتابة نعم لاتمام العملية";
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              SizedBox(height: 10.h),
                              Obx(
                                ()=> Column(
                                  children: [
                                    AppTextButton(
                                      isLoading: controller.isLoading.value,
                                      color: Colors.red.shade300,
                                      title: "نعم",
                                      onPressed: () {
                                        controller.deleteAccount();
                                      },
                                    ),
                                    SizedBox(height: 10.h),
                                    AppTextButton(
                                      isLoading: controller.isLoading.value,
                                      title: "لا",
                                      onPressed: () {
                                        Get.back();
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
              ],)
            ],
          ),
        ),
      ),
      child: Icon(Icons.more_vert),
    );
  }
}
