import 'package:cached_network_image/cached_network_image.dart';
import '../../controllers/admin_controller.dart';
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
  TeachersInfoModel? teachersInfoModel;

  @override
  void initState() {
    super.initState();
    teachersInfoModel = Get.arguments?['teachersInfoModel'];
    if (teachersInfoModel != null) {
      print(
        "teachersInfoModel courses length: ${teachersInfoModel!.user?.teacherCoursesModel?.length}",
      );
    } else {
      print("teachersInfoModel is NULL in arguments!");
    }
  }

  @override
  Widget build(BuildContext context) {
    if (teachersInfoModel == null) {
      return AppScaffold(
        body: Center(child: Text("لا توجد بيانات لهذا المعلم")),
      );
    }
    return AppScaffold(
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          children: [
            SizedBox(
              height: 100.h.clamp(100, 105),
              width: 100.w.clamp(100, 105),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child:
                    (teachersInfoModel!.image != null &&
                        teachersInfoModel!.image!.isNotEmpty)
                    ? CachedNetworkImage(
                        fit: BoxFit.cover,
                        imageUrl:
                            "${AppConstance.baseUrl}/storage/${teachersInfoModel!.image}",
                      )
                    : teachersInfoModel!.user?.teacherInfo?.image != null
                    ? CachedNetworkImage(
                        fit: BoxFit.cover,
                        imageUrl:
                            "${AppConstance.baseUrl}/storage/${teachersInfoModel!.user?.teacherInfo?.image}",
                      )
                    : Image.asset("assets/images/edzo_logo.png"),
              ),
            ),
            SizedBox(height: 20.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  teachersInfoModel!.name ?? teachersInfoModel!.user?.name ?? "",
                  style: TextStyle(
                    fontSize: 20.sp.clamp(20, 24),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(width: 10.w),
                GetBuilder<AdminController>(
                  init: Get.find<AdminController>(),
                  builder: (adminController) {
                    // Update local model reference if it was updated in the controller
                    var updatedTeacher = adminController.teachers.firstWhereOrNull((t) => t.id == teachersInfoModel!.id);
                    if (updatedTeacher != null) {
                      teachersInfoModel!.isPin = updatedTeacher.isPin;
                    }
                    return IconButton(
                      onPressed: () {
                        adminController.pinTeacher(teachersInfoModel!.id!);
                      },
                      icon: Icon(
                        (teachersInfoModel!.isPin ?? false)
                            ? Icons.push_pin
                            : Icons.push_pin_outlined,
                        color: (teachersInfoModel!.isPin ?? false)
                            ? Colors.blue
                            : Colors.grey,
                      ),
                    );
                  }
                ),
              ],
            ),
            SizedBox(height: 10.h),
            Text(
              teachersInfoModel!.user?.email ?? "",
              style: TextStyle(
                fontSize: 20.sp.clamp(20, 24),
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10.h),
            Text(
              teachersInfoModel!.bio ??
                  teachersInfoModel!.user?.teacherInfo?.bio ??
                  "",
              style: TextStyle(fontSize: 20.sp.clamp(20, 24)),
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Text(
                  "الكورسات - ${teachersInfoModel!.coursesCount ?? teachersInfoModel!.courses?.length ?? 0}",
                  style: TextStyle(fontSize: 20.sp.clamp(20, 24)),
                ),
                Spacer(),
                Text(
                  "المشتركين - ${teachersInfoModel!.totalStudentsCount ?? 0}",
                  style: TextStyle(fontSize: 20.sp.clamp(20, 24)),
                ),
              ],
            ),
            Divider(),

            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: teachersInfoModel!.courses?.length ?? 0,
              itemBuilder: (c, index) {
                TeacherCoursesModel? teacherCoursesModel =
                    teachersInfoModel!.courses?[index];

                return ExpansionTile(
                  subtitle: Text(
                    "عدد المشتركين - ${teacherCoursesModel?.totalSubscribers ?? 0}",
                    style: TextStyle(fontSize: 20.sp.clamp(20, 24)),
                  ),
                  title: Text(teacherCoursesModel?.title ?? ""),
                  children: List.generate(
                    teacherCoursesModel?.monthlySubscribers?.length ?? 0,
                    (innerIndex) {
                      MonthlySubscribersModel? monthlySubscribersModel =
                          teacherCoursesModel?.monthlySubscribers?[innerIndex];
                      String dateText = "";
                      try {
                        if (monthlySubscribersModel?.date != null) {
                          dateText = DateFormat.yMMMM("ar").format(
                            DateTime.parse(
                              "${monthlySubscribersModel?.date}-01",
                            ),
                          );
                        }
                      } catch (e) {
                        dateText = monthlySubscribersModel?.date ?? "";
                      }
                      return ListTile(
                        title: Text(dateText),
                        trailing: Text(
                          "عدد المشتركين - ${monthlySubscribersModel?.count ?? 0}",
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
