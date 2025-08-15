import 'dart:math';

import 'package:card_loading/card_loading.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CourseCardLoadingSkeleton extends StatelessWidget {
  CourseCardLoadingSkeleton({super.key, required this.onRefresh});
  Function onRefresh;
  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        onRefresh();
      }, 
      child: SingleChildScrollView(
        physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
        child: Column(
          children: List.generate(
            5,
            (index) => Padding(
              padding: EdgeInsets.symmetric(vertical: 10.h),
              child:
                  Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16.r),
                          color: Theme.of(context).cardColor,
                        ),
                        height: (100 + Random().nextInt(250).toDouble()).h,
                        width: double.infinity,
                      )
                      .animate(
                        delay: Duration(seconds: Random().nextInt(3)),
                        onPlay: (controller) =>
                            controller.repeat(reverse: true, max: 1, min: 0),
                      )
                      .fade(duration: Duration(seconds: 1)),
            ),
          ),
        ),
      ),
    );
  }
}
