import 'package:edzo/controllers/auth/mandatory_phone_controller.dart';
import 'package:edzo/core/widgets/app_text_button.dart';
import 'package:edzo/core/widgets/app_text_form.dart';
import 'package:edzo/core/widgets/scaffold/app_scaffold.dart';
import 'package:edzo/views/auth/widgets/telegram_support_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class MandatoryPhoneScreen extends StatelessWidget {
  const MandatoryPhoneScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(MandatoryPhoneController());

    return AppScaffold(
      showAppBar: false,
      body: WillPopScope(
        onWillPop: () async => false, // Prevent going back
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.phone_android_rounded,
                size: 80.sp,
                color: Theme.of(context).primaryColor,
              ),
              SizedBox(height: 24.h),
              Text(
                "تحديث أمان مطلوب",
                style: TextStyle(
                  fontSize: 22.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 12.h),
              Text(
                "يرجى إضافة رقم هاتفك للمتابعة. هذا الإجراء مطلوب لجميع الحسابات القديمة لضمان أمان حسابك.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Colors.grey,
                ),
              ),
              SizedBox(height: 32.h),
              AppTextForm(
                controller: controller.phoneController,
                hint: "رقم الهاتف (مثال: 07700000000)",
                textInputType: TextInputType.phone,
                prefixIcon: Icons.phone_outlined,
              ),
              SizedBox(height: 24.h),
              Obx(
                () => AppTextButton(
                  title: "إرسال كود التحقق",
                  isLoading: controller.isLoading.value,
                  onPressed: controller.submitPhone,
                ),
              ),
              SizedBox(height: 16.h),
              TextButton(
                onPressed: () {
                    // Option to logout if they want to switch accounts
                    Get.defaultDialog(
                        title: "تسجيل الخروج",
                        middleText: "هل تريد تسجيل الخروج من هذا الحساب؟",
                        textConfirm: "نعم",
                        textCancel: "إلغاء",
                        confirmTextColor: Colors.white,
                        onConfirm: () {
                            controller.logout();
                        }
                    );
                },
                child: Text("تسجيل الخروج"),
              ),
              TelegramSupportWidget(),
            ],
          ),
        ),
      ),
    );
  }
}
