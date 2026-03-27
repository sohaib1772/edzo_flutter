import 'package:edzo/controllers/main_layout_controller.dart';
import 'package:edzo/core/constance/app_router_keys.dart';
import 'package:edzo/core/helpers/session_helper.dart';
import 'package:edzo/core/widgets/app_text_button.dart';
import 'package:edzo/core/widgets/app_text_form.dart';
import 'package:edzo/core/helpers/app_form_validator.dart';
import 'package:edzo/core/widgets/scaffold/app_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsScreen extends StatelessWidget {
  SettingsScreen({super.key});

  final MainLayoutController controller = Get.find<MainLayoutController>();

  Widget _buildSettingsTile(
    BuildContext context, {
    required String title,
    required IconData icon,
    required VoidCallback onTap,
    Color? textColor,
    Color? iconColor,
    Widget? trailing,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      decoration: BoxDecoration(
        color: controller.isDarkMode.value
            ? Colors.grey.shade900
            : Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
        leading: Container(
          padding: EdgeInsets.all(8.w),
          decoration: BoxDecoration(
            color: (iconColor ?? Theme.of(context).primaryColor).withOpacity(
              0.1,
            ),
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Icon(
            icon,
            color: iconColor ?? Theme.of(context).primaryColor,
            size: 22.sp,
          ),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            color: textColor ?? Theme.of(context).colorScheme.tertiary,
          ),
        ),
        trailing:
            trailing ??
            Icon(Icons.arrow_forward_ios, size: 16.sp, color: Colors.grey),
        onTap: onTap,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
      ),
    );
  }

  void _showAddPhoneDialog(BuildContext context) {
    TextEditingController phoneController = TextEditingController();
    Get.dialog(
      AlertDialog(
        title: Text("إضافة رقم هاتف"),
        content: AppTextForm(
          controller: phoneController,
          hint: "اكتب رقم الهاتف هنا",
        ),
        actions: [
          Obx(
            () => AppTextButton(
              isLoading: controller.isLoading.value,
              title: "إرسال الكود",
              onPressed: () {
                if (phoneController.text.isNotEmpty &&
                    AppFormValidator.isPhoneValid(phoneController.text)) {
                  controller.addPhone(phoneController.text);
                } else {
                  Get.snackbar(
                    "خطأ",
                    "رقم الهاتف غير صالح",
                    colorText: Colors.red.shade300,
                  );
                }
              },
            ),
          ),
          SizedBox(height: 10.h),
          AppTextButton(title: "إلغاء", onPressed: () => Get.back()),
        ],
      ),
    );
  }

  void _showAddEmailDialog(BuildContext context) {
    TextEditingController emailController = TextEditingController();
    Get.dialog(
      AlertDialog(
        title: Text("إضافة بريد إلكتروني"),
        content: AppTextForm(
          controller: emailController,
          hint: "اكتب البريد الإلكتروني هنا",
        ),
        actions: [
          Obx(
            () => AppTextButton(
              isLoading: controller.isLoading.value,
              title: "إرسال الرابط/الكود",
              onPressed: () {
                if (emailController.text.isNotEmpty &&
                    AppFormValidator.isEmailValid(emailController.text)) {
                  controller.addEmail(emailController.text);
                } else {
                  Get.snackbar(
                    "خطأ",
                    "البريد الإلكتروني غير صالح",
                    colorText: Colors.red.shade300,
                  );
                }
              },
            ),
          ),
          SizedBox(height: 10.h),
          AppTextButton(title: "إلغاء", onPressed: () => Get.back()),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: "الإعدادات",
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.h),
        child: Obx(
          () => Column(
            children: [
              _buildSettingsTile(
                context,
                title: controller.isDarkMode.value
                    ? "الوضع الفاتح"
                    : "الوضع الليلي",
                icon: !controller.isDarkMode.value
                    ? Icons.dark_mode
                    : Icons.light_mode,
                onTap: () {
                  controller.changeTheme();
                },
                trailing: Switch(
                  value: controller.isDarkMode.value,
                  onChanged: (val) {
                    controller.changeTheme();
                  },
                  activeColor: Theme.of(context).primaryColor,
                ),
              ),
              _buildSettingsTile(
                context,
                title: "الشروط و الاحكام",
                icon: Icons.privacy_tip_outlined,
                onTap: () {
                  Get.toNamed(AppRouterKeys.privacyPolicy);
                },
              ),
              if (SessionHelper.user != null)
                SessionHelper.user!.phone != null &&
                        SessionHelper.user!.phone!.isNotEmpty
                    ? _buildSettingsTile(
                        context,
                        title: "",
                        icon: Icons.check_circle,
                        iconColor: Colors.green,
                        trailing: Text(
                          SessionHelper.user!.phone!,
                          style: TextStyle(color: Colors.grey, fontSize: 14.sp),
                        ),
                        onTap: () {},
                      )
                    : _buildSettingsTile(
                        context,
                        title: "إضافة رقم هاتف",
                        icon: Icons.phone_android,
                        iconColor: Colors.blue,
                        onTap: () {
                          _showAddPhoneDialog(context);
                        },
                      ),
              if (SessionHelper.user != null)
                SessionHelper.user!.email != null &&
                        SessionHelper.user!.email!.isNotEmpty
                    ? _buildSettingsTile(
                        context,
                        title: "",
                        icon: Icons.mark_email_read,
                        iconColor: Colors.green,
                        trailing: Text(
                          SessionHelper.user!.email!,
                          style: TextStyle(color: Colors.grey, fontSize: 14.sp),
                        ),
                        onTap: () {},
                      )
                    : _buildSettingsTile(
                        context,
                        title: "إضافة بريد إلكتروني",
                        icon: Icons.email,
                        iconColor: Colors.orange,
                        onTap: () {
                          _showAddEmailDialog(context);
                        },
                      ),
              SessionHelper.user == null
                  ? _buildSettingsTile(
                      context,
                      title: "تسجيل الدخول",
                      icon: Icons.login,
                      iconColor: Colors.blue,
                      onTap: () {
                        Get.toNamed(AppRouterKeys.loginScreen);
                      },
                    )
                  : Column(
                      children: [
                        _buildSettingsTile(
                          context,
                          title: "تسجيل الخروج",
                          icon: Icons.logout,
                          textColor: Colors.red.shade400,
                          iconColor: Colors.red.shade400,
                          onTap: () {
                            controller.logout();
                          },
                        ),
                        _buildSettingsTile(
                          context,
                          title: "الدعم الفني",
                          icon: Icons.support_agent,
                          iconColor: Colors.green.shade400,
                          onTap: () async {
                            try {
                              await launchUrl(
                                Uri.parse("tg://resolve?domain=Edzo_Support"),
                                mode: LaunchMode.externalApplication,
                              );
                            } catch (e) {
                              await launchUrl(
                                Uri.parse("https://t.me/Edzo_Support"),
                                mode: LaunchMode.externalApplication,
                              );
                            }
                          },
                        ),
                        SizedBox(height: 24.h),
                        _buildSettingsTile(
                          context,
                          title: "حذف الحساب",
                          icon: Icons.delete_forever,
                          textColor: Colors.red.shade800,
                          iconColor: Colors.red.shade800,
                          onTap: () {
                            Get.dialog(
                              AlertDialog(
                                title: Text("حذف الحساب"),
                                content: Text("هل تريد حذف الحساب؟"),
                                actions: [
                                  Form(
                                    key: controller.formKey,
                                    child: AppTextForm(
                                      hint: "يرجى كتابة نعم لاتمام العملية",
                                      controller: controller
                                          .deleteAccountConfirmationController,
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
                                    () => Column(
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
                      ],
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
