import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppTextForm extends StatelessWidget {
  AppTextForm({
    super.key,
    required this.hint,
    this.textInputAction = TextInputAction.next,
    this.prefixIcon,
    this.showText = false,
    this.suffix,
    required this.controller,
    this.validator,
    this.onChanged,
    this.maxLines = 1,
    this.enabled = true,
    this.textInputType,
  });
  String hint;
  TextInputAction? textInputAction;
  IconData? prefixIcon;
  bool showText = false;
  Widget? suffix;
  TextEditingController controller;
  Function(String?)? validator;
  Function(String)? onChanged;
  int maxLines;
  bool enabled;
  TextInputType? textInputType;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: textInputType,
      enabled: enabled,
      maxLines: maxLines,
      onChanged: (value) {
        if (value.isNotEmpty) {
          // تحويل الأرقام العربية إلى إنجليزية
          String converted = value.replaceAllMapped(RegExp(r'[٠-٩]'), (match) {
            // الرقم العربي
            final arabicDigit = match.group(0);
            // تحويله إلى رقم إنجليزي حسب الفارق بين Unicode
            return (arabicDigit!.codeUnitAt(0) - 0x0660).toString();
          });

          // إذا النص بعد التحويل مختلف عن النص الأصلي، حدث الـ controller
          if (converted != value) {
            controller.value = controller.value.copyWith(
              text: converted,
              selection: TextSelection.collapsed(offset: converted.length),
            );
          }
        }
        if (onChanged != null) {
          onChanged!(controller.text);
        }
      },
      validator: (value) {
        if (validator != null) {
          return validator!(value);
        }
        return null;
      },
      controller: controller,
      textInputAction: textInputAction,
      obscureText: showText,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(horizontal: 10.w.clamp(10, 12), vertical: 15.h.clamp(15, 18)),
        prefixIcon: prefixIcon == null ? null : Icon(prefixIcon, size: 24.sp.clamp(24, 28)),
        suffixIcon: suffix,
        hintText: hint,
        filled: true,
        fillColor: Theme.of(context).focusColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
