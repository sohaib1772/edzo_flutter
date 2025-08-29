import 'package:cached_network_image/cached_network_image.dart';
import 'package:edzo/core/constance/app_constance.dart';
import 'package:edzo/core/widgets/scaffold/app_scaffold.dart';
import 'package:edzo/models/monthly_subscribers_model.dart';
import 'package:edzo/models/teachers_response_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';

class TeacherReportsScreen extends StatefulWidget {
  TeacherReportsScreen({super.key});

  @override
  State<TeacherReportsScreen> createState() => _TeacherReportsScreenState();
}

class _TeacherReportsScreenState extends State<TeacherReportsScreen> {
  TeachersInfoModel teachersInfoModel = Get.arguments['teachersInfoModel'];
@override
  void initState() {
    super.initState();
    print("teachersInfoModel ${teachersInfoModel.user?.teacherCoursesModel?.length}");
  }
  
  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          children: [
            SizedBox(
              height: 100.h,
              width: 100.w,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: teachersInfoModel.user?.teacherInfo?.image != null
                    ? CachedNetworkImage(
                        fit: BoxFit.cover,
                        imageUrl: "${AppConstance.baseUrl}/storage/${teachersInfoModel.user?.teacherInfo?.image}",
                      )
                    : Image.asset("assets/images/edzo_logo.png"),
              ),
            ),
            SizedBox(height: 20.h),
            Text(teachersInfoModel.user?.name ?? "",
                style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold)),
            SizedBox(height: 10.h),
            Text(teachersInfoModel.user?.email ?? ""),
            SizedBox(height: 10.h),
            Text(teachersInfoModel.user?.teacherInfo?.bio ?? ""),
            SizedBox(height: 20),
            Row(children: [
                Text("عدد الكورسات - ${teachersInfoModel.user?.teacherCoursesModel?.length}"),
                Spacer(),
                Text("عدد المشتركين - ${teachersInfoModel.user?.totalSubscriptionsCount}"),
            ],),
            Divider(),
        
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: teachersInfoModel.user?.teacherCoursesModel?.length,
              itemBuilder: (c, index) {    
                TeacherCoursesModel? teacherCoursesModel = teachersInfoModel.user?.teacherCoursesModel?[index];

                return ExpansionTile(
                  subtitle: Text("عدد المشتركين - ${teacherCoursesModel?.monthlySubscribers?.length}"),
                 title: Text(teacherCoursesModel?.title ?? ""),
                  children: List.generate(
                    teacherCoursesModel?.monthlySubscribers?.length ?? 0,
                    (innerIndex) {
                      MonthlySubscribersModel? monthlySubscribersModel =
                          teacherCoursesModel?.monthlySubscribers?[innerIndex];
                      return ListTile(
                        title: Text(DateFormat.yMMMM("ar").format(DateTime.parse( "${monthlySubscribersModel?.date}-01"),)),
                        trailing: Text(
                          "عدد المشتركين - ${monthlySubscribersModel?.count.toString()}",
                        ),
                      );
                    },
                  ),
               );
              },
            ),
          ],
        ),
      ),
    );
  }
}
