import 'package:edzo/controllers/auth/phone_verification_controller.dart';
import 'package:edzo/core/helpers/app_form_validator.dart';
import 'package:edzo/core/widgets/app_text_button.dart';
import 'package:edzo/core/widgets/app_text_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class PhoneVerificationForm extends StatelessWidget {
  PhoneVerificationForm({super.key});
  final controller = Get.find<PhoneVerificationController>();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        children: [
          AppTextForm(
            validator: (value) {
              if (AppFormValidator.isEmpty(value ?? ""))
                return 'رمز التحقق مطلوب';

              return null;
            },
            controller: controller.codeController,
            hint: 'رمز التحقق',
            suffix: Obx(
              () =>
                  IconButton(
                        onPressed: () {
                          controller.getCodeFormClipboard();
                        },
                        icon: Icon(Icons.copy),
                      )
                      .animate(
                        onPlay: (acontroller) {
                          acontroller.repeat();
                        },
                      )
                      .shake(
                        hz: controller.stopAnimation.value ? 0 : 1.8,
                        duration: Duration(milliseconds: 4000),
                      ),
            ),
          ),
          SizedBox(height: 18.h),

          Obx(
            () => AppTextButton(
              isLoading: controller.isLoading.value,
              title: 'تحقق',
              onPressed: () async {
                if (!formKey.currentState!.validate()) return;
                await controller.phoneVerification();
              },
            ),
          ),
        ],
      ),
    );
  }
}
