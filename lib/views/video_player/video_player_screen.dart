import 'dart:io';

import 'package:chewie/chewie.dart';
import 'package:edzo/controllers/course_controller.dart';
import 'package:edzo/controllers/video_player_controller.dart';
import 'package:edzo/core/constance/app_router_keys.dart';
import 'package:edzo/core/helpers/local_storage.dart';
import 'package:edzo/core/widgets/app_text_button.dart';
import 'package:edzo/core/widgets/course_card_loading_skeleton.dart';
import 'package:edzo/core/widgets/scaffold/app_scaffold.dart';
import 'package:edzo/models/course_model.dart';
import 'package:edzo/models/video_model.dart';
import 'package:edzo/repos/courses/courses_repo.dart';
import 'package:edzo/views/cource/widgets/course_videos_list_widget.dart';
import 'package:edzo/views/video_player/widgets/videos_list_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
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
  bool _isScreenCaptured = false;

  static const platform = MethodChannel("flutter/secure");
  final CourseController courseController = Get.find();

  @override
  void initState() {
    super.initState();

    if (Platform.isAndroid) {
      platform.invokeMethod("setSecure", {"enable": true}); // منع التصوير
    }

    if (Platform.isIOS) {
      platform.setMethodCallHandler((call) async {
        if (call.method == "screenCaptured") {
          bool captured = call.arguments as bool;
          setState(() {
            _isScreenCaptured = captured;
          });
        }
      });
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
      platform.invokeMethod("setSecure", {
        "enable": false,
      }); // رجع الوضع الطبيعي
    }
    _exitFullScreenMode();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    return GetBuilder<VideoController>(
      init: VideoController(
        id: widget.videoModel.id ?? 0,
        title: widget.videoModel.title ?? "",
        courseId: widget.videoModel.courseId ?? 0,
        videoId: widget.videoModel.id ?? 0,
      ),
      builder: (controller) {
        return AppScaffold(
          showAppBar: !isLandscape, // أخفي الـ AppBar في وضع landscape
          body: controller.isLoading
              ? const Center(child: CircularProgressIndicator())
              : GestureDetector(
                  onDoubleTap: () => _toggleFullScreen(context),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      if (!isLandscape)
                        Column(
                          children: [
                            Text(widget.videoModel.title ?? ""),
                            SizedBox(height: 10.h),
                          ],
                        ),
                      Expanded(
                        flex: !isLandscape ? 0 : 1,
                        child: Stack(
                          children: [
                            YoutubePlayer(
                              liveUIColor: Colors.transparent,
                              showVideoProgressIndicator: false,
                              bottomActions: const [
                                RemainingDuration(),
                                PlaybackSpeedButton(),
                                ProgressBar(isExpanded: true),
                                //speed
                                CurrentPosition(),
                              ],
                              bufferIndicator: const Center(
                                child: CircularProgressIndicator(),
                              ),
                              controller: controller.videoPlayerController,
                              topActions: [
                                IconButton(
                                  onPressed: () => _toggleFullScreen(context),
                                  icon: Icon(
                                    isLandscape
                                        ? Icons.fullscreen_exit
                                        : Icons.fullscreen,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                            Obx(
                              () => controller.isBufferingNow.value
                                  ? Container(
                                      height: isLandscape
                                          ? double.infinity
                                          : 200.h,
                                      width: double.infinity,
                                      alignment: Alignment.center,
                                      color: Colors.black,
                                      child: const CircularProgressIndicator(),
                                    )
                                  : const SizedBox.shrink(),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
        );
      },
    );
  }
}
