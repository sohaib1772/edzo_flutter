import 'package:chewie/chewie.dart';
import 'package:edzo/core/constance/app_constance.dart';
import 'package:edzo/core/helpers/local_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:video_player/video_player.dart';

class VideoController extends GetxController {
  final String title;
  final int courseId;
  final int videoId;
  final int id;
  bool isError = false;
  bool isLoading = false;

  RxBool isFullScreen = false.obs;

  late VideoPlayerController videoPlayerController;
  ChewieController? chewieController;

  VideoController({
    required this.id,
    required this.title,
    required this.courseId,
    required this.videoId,
  });


  Future<void> initVideo() async {
    
    isLoading = true;
    update();
    String? token = await LocalStorage.getToken();
    final videoUrl =
        '${AppConstance.baseUrl}/api/courses/videos/courses_videos/$courseId/$title?token=$token&id=$id';

    videoPlayerController = VideoPlayerController.networkUrl(
      Uri.parse(videoUrl),
    );

    videoPlayerController
        .initialize()
        .then((_) {
          chewieController = ChewieController(
            videoPlayerController: videoPlayerController,
            autoPlay: false,
            looping: false,

            // عند الدخول في fullscreen اجعلها أفقية
            deviceOrientationsOnEnterFullScreen: [
              DeviceOrientation.landscapeRight,
              DeviceOrientation.landscapeLeft,
            ],

            // عند الخروج من fullscreen ارجع للوضع العمودي
            deviceOrientationsAfterFullScreen: [DeviceOrientation.portraitUp],
          );
          update();
        })
        .catchError((error) {
          print("Error initializing video: $error");
          isError = true;
          update();
          // عرض رسالة خطأ أو Snackbar
        });

    isLoading = false;
    update();
  }

  @override
  void onInit() async {
    super.onInit();
    await initVideo();
  }

  @override
  void onClose() {
    videoPlayerController.dispose();
    chewieController?.dispose();
    super.onClose();
  }
}
