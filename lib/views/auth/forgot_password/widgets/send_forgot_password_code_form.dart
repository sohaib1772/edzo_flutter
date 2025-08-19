import 'package:edzo/controllers/auth/forgot_password_controller.dart';
import 'package:edzo/core/helpers/app_form_validator.dart';
import 'package:edzo/core/widgets/app_text_button.dart';
import 'package:edzo/core/widgets/app_text_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';

class SendForgotPasswordCodeForm extends StatelessWidget {
  SendForgotPasswordCodeForm({super.key});
  ForgotPasswordController controller = Get.find<ForgotPasswordController>();
  GlobalKey<FormState> sendCodeFormKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Form(
      key: sendCodeFormKey,
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: AppTextForm(
              hint: "البريد الالكتروني",
              controller: controller.emailController,
              prefixIcon: Icons.email_outlined,
              validator: (value) {
                if (AppFormValidator.isEmpty(value ?? ""))
                  return 'البريد الالكتروني مطلوب';
                if (!AppFormValidator.isEmailValid(value ?? ""))
                  return 'البريد الالكتروني غير صحيح';
                return null;
              },
            ),
          ),
          SizedBox(width: 5.w),
          Expanded(
            flex: 1,
            child: GetBuilder<ForgotPasswordController>(
              init: controller,
              builder: (_) => Obx(
                () => AppTextButton(
                  isLoading: controller.sendCodeLoading.value,
                  title: controller.canSendCode.value
                      ? "إرسال"
                      : controller.countdown.toString(),
                  onPressed: controller.canSendCode.value
                      ? () async {
                          if (!sendCodeFormKey.currentState!.validate()) return;
                          await controller.sendCode();
                        }
                      : null, // تعطيل الزر أثناء الانتظار
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
