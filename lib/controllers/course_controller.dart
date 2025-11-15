import 'package:edzo/controllers/home_controller.dart';
import 'package:edzo/core/helpers/session_helper.dart';
import 'package:edzo/core/network/api_result.dart';
import 'package:edzo/models/course_model.dart';
import 'package:edzo/models/playlist_model.dart';
import 'package:edzo/models/video_model.dart';
import 'package:edzo/repos/courses/courses_repo.dart';
import 'package:edzo/repos/courses/public_courses_repo.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CourseController extends GetxController {
  TextEditingController codeController = TextEditingController();
  RxBool isLoading = false.obs;
  CoursesRepo coursesRepo = Get.find<CoursesRepo>();
  PublicCoursesRepo publicCoursesRepo = Get.find<PublicCoursesRepo>();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  RxList<VideoModel> videos = <VideoModel>[].obs;
  RxList<PlaylistModel> playlists = <PlaylistModel>[].obs;
  CourseModel courseModel = Get.arguments['courseModel'];
RxInt totalDuration = 0.obs;

  @override
  void onInit() async {
    print(courseModel.title);
    super.onInit();
    await getVideos();
  }

  void subscribe(int courseId) async {
    isLoading.value = true;
    var res = await coursesRepo.subscribe(codeController.text, courseId);
    if (!res.status) {
      Get.snackbar(
        "خطاء في الاشتراك",
        res.errorHandler!.getErrorsList(),
        colorText: Colors.red.shade300,
      );
      isLoading.value = false;
      return;
    }
    Get.back();
    Get.snackbar(
      "تم الاشتراك بنجاح",
      "تم الاشتراك بالدورة بنجاح",
      colorText: Colors.green.shade300,
    );
    courseModel.isSubscribed = true;
    courseModel.subscribersCount = courseModel.subscribersCount! + 1;
    Get.find<HomeController>().courses
            .where((element) => element.id == courseModel.id)
            .first
            .subscribersCount =
        courseModel.subscribersCount;
    Get.find<HomeController>().courses
            .where((element) => element.id == courseModel.id)
            .first
            .isSubscribed =
        true;
    Get.find<HomeController>().update();
    update();
    isLoading.value = false;
  }

  Future<void> getVideos() async {
    isLoading.value = true;

    late ApiResult<VideosResponseModel> res;

    if (SessionHelper.user == null) {
      res = await publicCoursesRepo.getCourseVideos(courseModel.id!);
    } else {
      res = await coursesRepo.getCourseVideos(courseModel.id!);
    }
    if (!res.status) {
      Get.snackbar(
        "خطاء في جلب الدروس",
        res.errorHandler!.getErrorsList(),
        colorText: Colors.red.shade300,
      );
      isLoading.value = false;
      return;
    }
    videos.value = res.data?.directVideos ?? [];
    playlists.value = res.data?.playlists ?? [];
    getTotalDuration();
    isLoading.value = false;
    update();
  }

  RxString durationFromSeconds(int seconds) {
  int hours = seconds ~/ 3600;
  int minutes = (seconds % 3600) ~/ 60;
  int remainingSeconds = seconds % 60;

  String twoDigits(int n) => n.toString().padLeft(2, "0");

  return "${hours > 0 ? "${twoDigits(hours)}:" : ""}"
         "${twoDigits(minutes)}:"
         "${twoDigits(remainingSeconds)}".obs;
}

  void getTotalDuration() {
    var total = 0;
    for (var video in videos) {
      if (video.duration == null || video.duration == 0 || video.duration == "null") {
        continue;
      }
      total += video.duration ?? 0;
    }
    totalDuration.value = total;
  }
}
