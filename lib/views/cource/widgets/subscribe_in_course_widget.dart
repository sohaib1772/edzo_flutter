import 'package:edzo/controllers/course_controller.dart';
import 'package:edzo/core/constance/app_router_keys.dart';
import 'package:edzo/core/helpers/app_form_validator.dart';
import 'package:edzo/core/helpers/role_helper.dart';
import 'package:edzo/core/helpers/session_helper.dart';
import 'package:edzo/core/routing/app_router.dart';
import 'package:edzo/core/widgets/app_text_button.dart';
import 'package:edzo/core/widgets/app_text_form.dart';
import 'package:edzo/models/course_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class SubscribeInCourseWidget extends StatelessWidget {
  SubscribeInCourseWidget({super.key});
  CourseController courseController = Get.find();
  CourseModel courseModel = Get.arguments['courseModel'];
  @override
  Widget build(BuildContext context) {
    return RoleHelper.role == Role.full ? SizedBox.shrink() :  Row(
      children: [
        
        SizedBox(width: 10.w),
       courseModel.price.toString() == "0" ? SizedBox.shrink() :  Expanded(
        flex: 1,
          child: AppTextButton(
            title: "اشترك الان",
            color: Colors.green.shade300,
            icon: Icons.check,
            onPressed: () {
              if(courseController.isLoading.value) return;
              if(SessionHelper.user == null){
                Get.snackbar("لا يمكنك الاشتراك", "اضغط لتسجيل الدخول اولاً",onTap: (snack) {
                  Get.offAllNamed(AppRouterKeys.loginScreen);
                },backgroundColor: Theme.of(context).cardColor,);
                return;
              }
              Get.dialog(
                AlertDialog(
                  title: Text("اشترك الان !"),
                  content: Form(
                    key: courseController.formKey,
                    child: AppTextForm(
                      hint: "رمز الاشتراك",
                      controller: courseController.codeController,
                      validator: (p0) {
                        if (AppFormValidator.isEmpty(p0 ?? "")) {
                          return "رمز الاشتراك مطلوب";
                        }
                        return null;
                      },
                    ),
                  ),
                  actions: [
                    Obx(
                      () => AppTextButton(
                        isLoading: courseController.isLoading.value,
                        onPressed: () => Get.back(),
                        title: 'الغاء',
                        color: Colors.red.shade300,
                      ),
                    ),
                    SizedBox(height: 10.w),
                    Obx(
                      () => AppTextButton(
                        isLoading: courseController.isLoading.value,
                        onPressed: () {
                          if (courseController.formKey.currentState!
                              .validate()) {
                            courseController.subscribe(courseModel.id!);
                          }
                        },
                        title: 'تأكيد',
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        Expanded(
          child: Container(
            alignment: Alignment.center,           
            child: Text(
              
              courseModel.price.toString() == "0"
                  ? "مجاني"
                  : NumberFormat("#,###").format(courseModel.price) + " د",
              style: TextStyle(
                color: courseModel.price.toString() == "0"
                  ? Colors.green.shade300
                  : Colors.red.shade300,
                fontSize: 18.sp.clamp(18, 22),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
