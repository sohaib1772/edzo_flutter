import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:edzo/controllers/pin_course_controller.dart';
import 'package:edzo/core/constance/app_constance.dart';
import 'package:edzo/core/constance/app_router_keys.dart';
import 'package:edzo/core/helpers/role_helper.dart';
import 'package:edzo/core/helpers/session_helper.dart';
import 'package:edzo/core/widgets/app_text_button.dart';
import 'package:edzo/models/course_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_popup/flutter_popup.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';

class CourseCardWidget extends StatelessWidget {
  final CourseModel course;
  final bool isTeacher;
  final bool fromTeacherProfile;
   CourseCardWidget({
    super.key,
    required this.course,
    this.isTeacher = false,
    this.fromTeacherProfile = false
  });


  PinCourseController pinCourseController = Get.find();
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () {
        if (isTeacher) {
          Get.toNamed(
            AppRouterKeys.editCourseScreen,
            arguments: {"courseModel": course},
          );
        } else {
         
          Get.toNamed(
            AppRouterKeys.courseScreen,
            arguments: {"courseModel": course},
          );
        }
      },
      child: Container(
        height: 120.h.clamp(120, 140),
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(8),
          border: RoleHelper.role == Role.admin && course.isPin
              ? Border.all(
                  color: Colors.green,
                  width: 2,
                
              ) : null,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Stack(
            children: [
              // الرسم الخلفي الشفاف
              Positioned.fill(
                child: CustomPaint(painter: CourseCardBackgroundPainter()),
              ),

              // المحتوى الأساسي
              Row(
                children: [
                  // النصوص على اليسار
                  Expanded(
                    flex: 2,
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8.w,
                        vertical: 12.h,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // العنوان
                          Text(
                            course.title ?? "",
                            style: TextStyle(
                              fontSize: screenWidth > 600 ? 18 : 16,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(
                                context,
                              ).colorScheme.inverseSurface,
                              height: 1.2,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),

                          const SizedBox(height: 8),
                          // اسم المعلم
                          Text(
                            course.teacherName ?? "",
                            style: TextStyle(
                              fontSize: screenWidth > 600 ? 16 : 14,
                              color: Colors.teal,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Spacer(),
                          // السعر وعدد الطلاب
                          Row(
                            children: [
                              // السعر
                              Text(
                                " د.ع ${NumberFormat('#,###').format(course.price)}",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: screenWidth > 600 ? 16 : 13,
                                  color: Colors.green.shade700,
                                ),
                              ),
                              const Spacer(),
                              // عدد الطلاب
                              Row(
                                children: [
                                  Text(
                                    course.subscribersCount == null
                                        ? "0"
                                        : course.subscribersCount.toString(),
                                    style: TextStyle(
                                      fontSize: screenWidth > 600 ? 18 : 16,
                                      color: Colors.grey.shade600,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  Icon(
                                    Icons.people,
                                    size: screenWidth > 600 ? 18 : 16,
                                    color: Colors.grey.shade600,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(8),
                        bottomLeft: Radius.circular(8),
                      ),
                      child: Stack(
                        children: [
                          Container(
                            height: 120.h.clamp(120, 140),
                            child: CachedNetworkImage(
                              imageUrl:
                                  "${AppConstance.baseUrl}/storage/${course.image}",
                              fit: BoxFit.cover,
                              placeholder: (c, s) => Container(
                                color: Colors.grey.shade200,
                                child: const Center(
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                ),
                              ),
                              errorWidget: (c, s, e) => Container(
                                color: Colors.grey.shade200,
                                child: const Center(
                                  child: Icon(
                                    Icons.image_not_supported,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          RoleHelper.role == Role.admin
                              ?
                            Positioned(
                              top: 0,
                              left: 0,
                              child: CustomPopup(
                                child: Icon(
                                  Icons.more_horiz,
                                  color: Colors.black,
                                  size: 30.r,
                                ),
                                backgroundColor: Colors.transparent,
                                content: Container(
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).cardColor,
                                    borderRadius: BorderRadius.circular(10.r),
                                  ),
                                  width: 180.w,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Obx(
                                        ()=> AppTextButton(
                                          isLoading: pinCourseController.isLoading.value,
                                          title: course.isPin ? "الغاء التثبيت" :"تثبيت الدورة",
                                          onPressed: () {
                                            if(course.isPin){
                                              pinCourseController.unPinCourse(course.id!);
                                            }
                                            else{
                                              pinCourseController.pinCourse(course.id!);
                                            }
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ) : SizedBox.shrink(),
                        ],
                      ),
                    ),
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

// فئة الرسام المخصص للخلفية
class CourseCardBackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // تدرج لوني جميل في الخلفية
    final gradientPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Colors.blue.withOpacity(0.03),
          Colors.purple.withOpacity(0.02),
          Colors.teal.withOpacity(0.04),
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      gradientPaint,
    );

    // رسم أشكال هندسية منحنية
    final shapePaint = Paint()
      ..color = Colors.indigo.withOpacity(0.06)
      ..style = PaintingStyle.fill;

    // شكل هندسي في الزاوية العلوية
    final path1 = Path();
    path1.moveTo(size.width * 0.7, 0);
    path1.quadraticBezierTo(
      size.width * 0.9,
      size.height * 0.2,
      size.width,
      size.height * 0.4,
    );
    path1.lineTo(size.width, 0);
    path1.close();
    canvas.drawPath(path1, shapePaint);

    // شكل دائري متموج في المنتصف
    final wavePaint = Paint()
      ..color = Colors.cyan.withOpacity(0.05)
      ..style = PaintingStyle.fill;

    final path2 = Path();
    path2.moveTo(0, size.height * 0.6);
    for (double i = 0; i <= size.width; i += 20) {
      path2.lineTo(i, size.height * 0.6 + sin(i * 0.02) * 15);
    }
    path2.lineTo(size.width, size.height);
    path2.lineTo(0, size.height);
    path2.close();
    canvas.drawPath(path2, wavePaint);

    // رسم دوائر متدرجة الحجم
    final circlePaint = Paint()
      ..color = Colors.amber.withOpacity(0.08)
      ..style = PaintingStyle.fill;

    for (int i = 0; i < 5; i++) {
      canvas.drawCircle(
        Offset(size.width * 0.2 + (i * 15), size.height * 0.3 + (i * 10)),
        (5 - i) * 3.0,
        circlePaint,
      );
    }

    // خطوط منحنية متقاطعة للزينة
    final decorativePaint = Paint()
      ..color = Colors.green.withOpacity(0.06)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    for (int i = 0; i < 3; i++) {
      final path = Path();
      path.moveTo(size.width * 0.1, size.height * (0.2 + i * 0.3));
      path.quadraticBezierTo(
        size.width * 0.4,
        size.height * (0.1 + i * 0.3),
        size.width * 0.7,
        size.height * (0.3 + i * 0.3),
      );
      canvas.drawPath(path, decorativePaint);
    }

    // نقاط متناثرة بأحجام مختلفة
    final sparklesPaint = Paint()
      ..color = Colors.orange.withOpacity(0.1)
      ..style = PaintingStyle.fill;

    final sparklePositions = [
      Offset(size.width * 0.15, size.height * 0.2),
      Offset(size.width * 0.4, size.height * 0.15),
      Offset(size.width * 0.6, size.height * 0.4),
      Offset(size.width * 0.8, size.height * 0.7),
      Offset(size.width * 0.3, size.height * 0.8),
    ];

    for (int i = 0; i < sparklePositions.length; i++) {
      canvas.drawCircle(sparklePositions[i], (i % 3 + 1) * 2.0, sparklesPaint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
