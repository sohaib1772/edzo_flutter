import 'dart:io';

import 'package:chewie/chewie.dart';
import 'package:edzo/controllers/course_controller.dart';
import 'package:edzo/controllers/video_player_controller.dart';

import 'package:edzo/core/widgets/scaffold/app_scaffold.dart';
import 'package:edzo/models/course_model.dart';
import 'package:edzo/models/video_model.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
class VideoPlayerScreen extends StatefulWidget {
  final VideoModel videoModel = Get.arguments['videoModel'];
  final CourseModel courseModel = Get.arguments['courseModel'];

  VideoPlayerScreen({Key? key}) : super(key: key);

  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen>
    with WidgetsBindingObserver {
  
  final CourseController courseController = Get.find();

  late final VideoController controller;
static const platform = MethodChannel("flutter/secure");
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addObserver(this);

    // إنشاء VideoController مرة واحدة فقط
    controller = Get.put(VideoController(
      id: widget.videoModel.id ?? 0,
      title: widget.videoModel.title ?? "",
      courseId: widget.videoModel.courseId ?? 0,
      videoId: widget.videoModel.id ?? 0,
    ));

    if (Platform.isAndroid) {
      platform.invokeMethod("setSecure", {"enable": true});
    }
  }

  Future<void> _enterFullScreenMode() async {
    await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  Future<void> _exitFullScreenMode() async {
    await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  }

  Future<void> _toggleFullScreen(BuildContext context) async {
    if (MediaQuery.of(context).orientation == Orientation.landscape) {
      await _exitFullScreenMode();
    } else {
      await _enterFullScreenMode();
    }
  }

  @override
  void dispose() {
    if (Platform.isAndroid) {
      platform.invokeMethod("setSecure", {"enable": false});
    }
    _exitFullScreenMode();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    return 
    AppScaffold(
      padding: 0,
      showAppBar: !isLandscape,
      body: Obx(() => controller.isLoading.value
          ? const Center(child: CircularProgressIndicator())
          : GestureDetector(
              onDoubleTap: () => _toggleFullScreen(context),
              child: Column(
                children: [
                  if (!isLandscape) ...[
                    Text(widget.videoModel.title ?? ""),
                    SizedBox(height: 10.h),
                  ],
                  Expanded(
                    child: Stack(
                      children: [
                        Positioned.fill(
                          child: YoutubePlayer(
                            
                            controller: controller.videoPlayerController,
                            liveUIColor: Colors.transparent,
                            showVideoProgressIndicator: false,
                            bufferIndicator:
                                const Center(child: CircularProgressIndicator()),
                            topActions: [
                              if (!isLandscape)
                                IconButton(
                                  onPressed: () =>
                                      _toggleFullScreen(context),
                                  icon: const Icon(
                                    Icons.fullscreen,
                                    color: Colors.white,
                                  ),
                                ),
                              if (isLandscape)
                                IconButton(
                                  onPressed: () =>
                                      _toggleFullScreen(context),
                                  icon: const Icon(
                                    Icons.fullscreen_exit,
                                    color: Colors.white,
                                  ),
                                ),
                            ],
                            bottomActions:  [
                            
                              RemainingDuration(),
                              PlaybackSpeedButton(),
                              ProgressBar(isExpanded: true),
                              CurrentPosition(),
                            ],
                          ),
                        ),
                       
                      ],
                    ),
                  ),
                ],
              ),
            )),
    );
  }
}