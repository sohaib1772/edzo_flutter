import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppTextButton extends StatelessWidget {
  AppTextButton({
    super.key,
    this.width = 250,
    this.title,
    this.color,
    this.onPressed,
    this.icon,
    this.isLoading = false,
  });
  bool isLoading;
  double? width;
  String? title;
  Color? color;
  IconData? icon;
  Function()? onPressed;

  @override

  Widget build(BuildContext context) {

    double height = 50.h;
    if(MediaQuery.of(context).orientation == Orientation.landscape){
      height = 50.h.clamp(50, 55);
    }else{
      height = 50.h;
    }
    return SizedBox(
      width: 250.w,
      height: height,
      child: isLoading
          ? ClipRRect(
              borderRadius: BorderRadius.circular(10.r),
              child:
                  Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.r),
                          border: Border.all(
                            color:
                                color ??
                                Theme.of(context).primaryColor.withAlpha(80),
                          ),
                          color:
                              color ??
                              Theme.of(context).primaryColor.withAlpha(40),
                        ),
                      )
                      .animate(
                        onPlay: (controller) =>
                            controller.repeat(reverse: true, min: 0, max: 1),
                      )
                      .shimmer(
                        duration: 1500.ms,
                        color:
                            color ??
                            Theme.of(context).primaryColor.withAlpha(80),
                        blendMode: BlendMode.multiply,
                        size: .35,
                      )
                      .fade(),
            )
          : TextButton.icon(
              icon: icon == null
                  ? null
                  : Icon(
                      icon,
                      size: 20.sp,
                      color: color ?? Theme.of(context).primaryColor,
                    ),
              style: ButtonStyle(
                backgroundColor: WidgetStatePropertyAll(
                  color?.withAlpha(40) ??
                      Theme.of(context).primaryColor.withAlpha(40),
                ),
                shape: WidgetStatePropertyAll<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.r),
                    side: BorderSide(
                      color:
                          color?.withAlpha(80) ??
                          Theme.of(context).primaryColor.withAlpha(80),
                    ),
                  ),
                ),
              ),
              onPressed: () {
                if (onPressed != null && !isLoading) {
                  onPressed!();
                }
              },
              label: Text(
                title!,
                style: TextStyle(
                  color: color ?? Theme.of(context).primaryColor,
                  fontSize: 18.sp.clamp(18, 22),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
    );
  }
}
