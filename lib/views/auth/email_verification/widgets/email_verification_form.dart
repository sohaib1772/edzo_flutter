import 'package:edzo/controllers/auth/email_verification_controller.dart';
import 'package:edzo/controllers/auth/login_controller.dart';
import 'package:edzo/controllers/auth/register_controller.dart';
import 'package:edzo/core/helpers/app_form_validator.dart';
import 'package:edzo/core/widgets/app_text_button.dart';
import 'package:edzo/core/widgets/app_text_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

class EmailVerificationForm extends StatelessWidget {
  EmailVerificationForm({super.key});
  final controller = Get.find<EmailVerificationController>();
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
                await controller.emailVerification();
              },
            ),
          ),
        ],
      ),
    );
  }
}
