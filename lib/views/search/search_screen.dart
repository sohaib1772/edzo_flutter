import 'package:Edzo/controllers/app_search_controller.dart';
import 'package:Edzo/core/widgets/app_text_form.dart';
import 'package:Edzo/core/widgets/course_card_widget.dart';
import 'package:Edzo/core/widgets/course_card_loading_skeleton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class SearchScreen extends StatelessWidget {
  SearchScreen({super.key});
  AppSearchController searchController = Get.find();
  @override
  Widget build(BuildContext context) {
    return GetX(
      init: searchController,
      builder: (controller) => controller.isLoading.value
          ? CourseCardLoadingSkeleton(
              onRefresh: () => controller.search(),
          )
          : SingleChildScrollView(
            child: Column(
                children: [
                  SizedBox(height: 16.h),
                  AppTextForm(
                    hint: "ابحث عن دورة",
                    controller: searchController.searchController,
                    onChanged: (value) {
                      searchController.search();
                    },
                    
                  ),
                  SizedBox(height: 16.h),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: BouncingScrollPhysics(),
                    itemCount: controller.courses.length,
                    itemBuilder: (context, index) {
                      return CourseCardWidget(course: controller.courses[index]);
                    },
                  ),
                ],
              ),
          ),
    );
  }
}
