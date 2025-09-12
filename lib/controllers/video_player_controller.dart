import 'dart:convert';
import 'dart:io';

import 'package:chewie/chewie.dart';
import 'package:edzo/core/helpers/local_storage.dart';
import 'package:edzo/core/helpers/session_helper.dart';
import 'package:edzo/core/network/api_result.dart';
import 'package:edzo/repos/courses/courses_repo.dart';
import 'package:edzo/repos/courses/public_courses_repo.dart';

import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VideoController extends GetxController {
  final String title;
  final int courseId;
  final int videoId;
  final int id;
  bool isError = false;
  RxBool isLoading = false.obs;
  RxBool isBufferingNow = true.obs;
  RxBool isFullScreen = false.obs;

  late YoutubePlayerController videoPlayerController;
  ChewieController? chewieController;

  final CoursesRepo repo = Get.find();
  final PublicCoursesRepo publicRepo = Get.find();

  VideoController({
    required this.id,
    required this.title,
    required this.courseId,
    required this.videoId,
  });

  //  Future<void> initVideo() async {
  //   isLoading = true;
  //   update();

  //   String token = await LocalStorage.getToken() ?? '';

  //   final url = Uri.parse(AppConstance.baseUrl)
  //     .replace(
  //       path: '/api/stream-proxy/$courseId/$videoId/$title/playlist.m3u8',
  //       queryParameters: {
  //       },
  //     )
  //     .toString();
  // print(url);
  //   // تمرير URL الـ Master Playlist مباشرة
  //   videoPlayerController = VideoPlayerController.networkUrl(
  //     Uri.parse(url),
  //   );

  //   try {
  //     await videoPlayerController.initialize();
  //     chewieController = ChewieController(
  //       videoPlayerController: videoPlayerController,
  //       autoPlay: false,
  //       looping: false,
  //       deviceOrientationsOnEnterFullScreen: [
  //         DeviceOrientation.landscapeRight,
  //         DeviceOrientation.landscapeLeft,
  //       ],
  //       deviceOrientationsAfterFullScreen: [DeviceOrientation.portraitUp],
  //     );
  //   } catch (error) {
  //     print("Error initializing video: $error");
  //     isError = true;
  //   }

  //   isLoading = false;
  //   update();
  // }
  Future<void> initVideo() async {
    isLoading.value = true;
    update();
    ApiResult res;
    if (SessionHelper.user == null) {
      res = await publicRepo.getVideo(courseId, videoId);
    } else {
      res = await repo.getVideo(courseId, videoId);
    }

    if (!res.status) {
      isError = true;
      Get.snackbar("خطاء في جلب الفيديو", res.errorHandler!.getErrorsList());
      update();
      return;
    }
    videoPlayerController = YoutubePlayerController(
      initialVideoId: res.data!.url ?? "",
      flags: const YoutubePlayerFlags(
        
        autoPlay: true,
        mute: false,
        showLiveFullscreenButton: false,
        disableDragSeek: false,
        controlsVisibleAtStart: true,
        useHybridComposition: true,
        forceHD: false,
        hideControls: false,
        enableCaption: false,
        hideThumbnail: true,

      ),
    );
    videoPlayerController.addListener(() async{

        final currentPosition = videoPlayerController.value.position.inSeconds;
        await LocalStorage.saveVideoLastWatchedSecond(videoId.toString(), currentPosition);

      if (videoPlayerController.value.isFullScreen) {
        isFullScreen.value = true;
      } else {
        isFullScreen.value = false;
      }
      
    
      if (videoPlayerController.value.playerState == PlayerState.playing) {
        isBufferingNow.value = false;
      } else if (videoPlayerController.value.playerState ==
          PlayerState.buffering) {
        isBufferingNow.value = true;

      }
    });
    isLoading.value = false;
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
