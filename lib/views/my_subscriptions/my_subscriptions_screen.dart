import 'package:Edzo/controllers/my_subscriptions_controller.dart';
import 'package:Edzo/core/widgets/course_card_loading_skeleton.dart';
import 'package:Edzo/core/widgets/course_card_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class MySubscriptionsScreen extends StatelessWidget {
   MySubscriptionsScreen({super.key});
  MySubscriptionsController controller = Get.put(MySubscriptionsController());
  @override
  Widget build(BuildContext context) {
    return  GetX(
      init: controller,
      builder: (controller) => controller.isLoading.value
          ? CourseCardLoadingSkeleton(
              onRefresh: () => controller.getCourses(),
          )
          : controller.courses.isEmpty ? RefreshIndicator(
            onRefresh: () => controller.getCourses(),
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.hourglass_empty_outlined,size: 50.sp,),  
                    SizedBox(height: 20.h),
                    Text("لا يوجد دورات مشترك بها",
                      style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ) : RefreshIndicator(
            onRefresh: () => controller.getCourses(),
            child: ListView.builder(
                    physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                    itemCount: controller.courses.length,
                    itemBuilder: (context, index) {
            return CourseCardWidget(course: controller.courses[index]);
                    },
                  ),
          ),
    );
  }
}