import 'dart:async';
import 'dart:io';

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
import 'package:photo_manager/photo_manager.dart';

import 'package:permission_handler/permission_handler.dart';

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

  bool _isTakingScreenshot = false;
  bool _showControls = true;
  Timer? _controlsTimer;
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addObserver(this);

    // إنشاء VideoController مرة واحدة فقط
    controller = Get.put(
      VideoController(
        id: widget.videoModel.id ?? 0,
        title: widget.videoModel.title ?? "",
        courseId: widget.videoModel.courseId ?? 0,
        videoId: widget.videoModel.id ?? 0,
      ),
    );

    if (Platform.isAndroid) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        platform.invokeMethod("setSecure", {"enable": true});
      });
    }
    _startControlsTimer();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      if (Platform.isAndroid) {
        platform.invokeMethod("setSecure", {"enable": true});
      }
    }
  }

  void _startControlsTimer() {
    debugPrint("Starting controls timer (Youtube)...");
    _controlsTimer?.cancel();
    _controlsTimer = Timer(const Duration(seconds: 3), () {
      debugPrint("Timer finished (Youtube)! Hiding controls.");
      if (mounted) {
        setState(() => _showControls = false);
      }
    });
  }

  void _toggleControls() {
    debugPrint("Toggling controls (Youtube). Current state: $_showControls");
    setState(() {
      _showControls = !_showControls;
    });
    if (_showControls) {
      _startControlsTimer();
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
    _controlsTimer?.cancel();
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

    return AppScaffold(
      padding: 0,
      showAppBar: !isLandscape,
      body: Obx(
        () => controller.isLoading.value
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
                            child: Listener(
                              behavior: HitTestBehavior.translucent,
                              onPointerDown: (_) => _toggleControls(),
                              child: YoutubePlayer(
                                controller: controller.videoPlayerController,
                                liveUIColor: Colors.transparent,
                                showVideoProgressIndicator: false,

                                bufferIndicator: const Center(
                                  child: CircularProgressIndicator(),
                                ),
                                topActions: [
                                  if (!isLandscape)
                                    IconButton(
                                      onPressed: () {
                                        _startControlsTimer();
                                        _toggleFullScreen(context);
                                      },
                                      icon: const Icon(
                                        Icons.fullscreen,
                                        color: Colors.white,
                                      ),
                                    ),
                                  if (isLandscape)
                                    IconButton(
                                      onPressed: () {
                                        _startControlsTimer();
                                        _toggleFullScreen(context);
                                      },
                                      icon: const Icon(
                                        Icons.fullscreen_exit,
                                        color: Colors.white,
                                      ),
                                    ),
                                  IconButton(
                                    onPressed: () {
                                      _startControlsTimer();
                                      _takeScreenshot();
                                    },
                                    icon: Icon(
                                      Icons.camera_alt_outlined,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                                bottomActions: [
                                  RemainingDuration(),
                                  PlaybackSpeedButton(),
                                  ProgressBar(isExpanded: true),
                                  CurrentPosition(),
                                ],
                              ),
                            ),
                          ),

                          // Screenshot Button Overlay with Animation
                        ],
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildSeekOverlayButton({
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.black38,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: Colors.white, size: 40.sp),
      ),
    );
  }

  Future<void> _takeScreenshot() async {
    if (_isTakingScreenshot) return;

    try {
      setState(() => _isTakingScreenshot = true);

      // Disable secure flag temporarily to allow capture
      if (Platform.isAndroid) {
        await platform.invokeMethod("setSecure", {"enable": false});
        // Delay to let the OS update the window flags
        await Future.delayed(const Duration(milliseconds: 300));
      }

      // Check permissions
      final photoStatus = await Permission.photos.request();
      if (!photoStatus.isGranted) {
        if (Platform.isAndroid) {
          await platform.invokeMethod("setSecure", {"enable": true});
        }
        Get.snackbar("تنبيه", "يرجى منح صلاحية الوصول للصور لحفظ لقطة الشاشة");
        return;
      }

      // Capture using Native Method (PixelCopy on Android side)
      final Uint8List? pngBytes = await platform.invokeMethod<Uint8List>(
        "takeScreenshot",
      );

      // Re-enable secure flag immediately after capture
      if (Platform.isAndroid) {
        await platform.invokeMethod("setSecure", {"enable": true});
      }

      if (pngBytes == null) {
        Get.snackbar("خطأ", "فشل التقاط صورة الشاشة من النظام");
        return;
      }

      // Save to Gallery
      final AssetEntity? asset = await PhotoManager.editor.saveImage(
        pngBytes,
        title: "edzo_${DateTime.now().millisecondsSinceEpoch}",
        filename: "edzo_${DateTime.now().millisecondsSinceEpoch}.png",
      );

      if (asset != null) {
        Get.snackbar("بنجاح", "تم حفظ لقطة الشاشة في المعرض");
      } else {
        Get.snackbar("خطأ", "فشل حفظ الملف في المعرض");
      }
    } catch (e) {
      // Ensure protection is back ON even on error
      if (Platform.isAndroid) {
        await platform.invokeMethod("setSecure", {"enable": true});
      }
      Get.snackbar("خطأ", "حدث خطأ أثناء أخذ لقطة الشاشة: $e");
    } finally {
      if (mounted) {
        setState(() => _isTakingScreenshot = false);
      }
    }
  }
}
