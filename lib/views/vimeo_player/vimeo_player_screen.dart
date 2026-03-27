import 'dart:async';
import 'dart:io';
import 'package:edzo/models/video_model.dart';
import 'package:edzo/repos/courses/courses_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:edzo/controllers/edit_course_controller.dart';
import 'package:edzo/controllers/bunny_upload_controller.dart';
import 'package:edzo/core/constance/app_router_keys.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:edzo/core/constance/app_constance.dart';
import 'package:edzo/core/helpers/local_storage.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class VimeoPlayerScreen extends StatefulWidget {
  const VimeoPlayerScreen({super.key});

  @override
  State<VimeoPlayerScreen> createState() => _VimeoPlayerScreenState();
}

class _VimeoPlayerScreenState extends State<VimeoPlayerScreen>
    with WidgetsBindingObserver {
  late final VideoModel videoModel;
  late final CoursesRepo _coursesRepo;

  WebViewController? _controller;
  bool _isLoadingData = true;
  bool _isLoadingPage = true;
  String? _errorMessage;
  bool _isTakingScreenshot = false;
  bool _showControls = true;
  Timer? _controlsTimer;

  static const platform = MethodChannel("flutter/secure");

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    videoModel = Get.arguments['videoModel'] as VideoModel;
    _coursesRepo = Get.find<CoursesRepo>();
    if (Platform.isAndroid) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        platform.invokeMethod("setSecure", {"enable": true});
      });
    }
    _fetchAndLoad();
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
    debugPrint("Starting controls timer...");
    _controlsTimer?.cancel();
    _controlsTimer = Timer(const Duration(seconds: 3), () {
      debugPrint("Timer finished! Hiding controls.");
      if (mounted) {
        setState(() => _showControls = false);
      }
    });
  }

  void _toggleControls() {
    debugPrint("Toggling controls. Current state: $_showControls");
    setState(() {
      _showControls = !_showControls;
    });
    if (_showControls) {
      _startControlsTimer();
    }
  }

  @override
  void dispose() {
    _controlsTimer?.cancel();
    _exitFullScreenMode();
    WidgetsBinding.instance.removeObserver(this);
    if (Platform.isAndroid) {
      platform.invokeMethod("setSecure", {"enable": false});
    }
    super.dispose();
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

  Future<void> _fetchAndLoad() async {
    setState(() {
      _isLoadingData = true;
      _errorMessage = null;
    });

    try {
      final token = await LocalStorage.getToken();
      final vimeoId = videoModel.id;

      if (vimeoId == null) {
        setState(() {
          _errorMessage = 'رقم الفيديو (Vimeo ID) غير متوفر';
          _isLoadingData = false;
        });
        return;
      }

      final savedPosition = LocalStorage.getVideoLastWatchedSecond(videoModel.id.toString()) ?? 0;
      final playerUrl =
          "${AppConstance.baseUrl}/video-player/$vimeoId?token=$token&t=$savedPosition&playsinline=1";

      setState(() => _isLoadingData = false);
      await _initWebView(playerUrl);
    } catch (e) {
      setState(() {
        _errorMessage = 'حدث خطأ أثناء تجهيز المشغل';
        _isLoadingData = false;
      });
    }
  }

  Future<void> _initWebView(String url) async {
    late final PlatformWebViewControllerCreationParams params;
    if (Platform.isIOS) {
      params = WebKitWebViewControllerCreationParams(
        allowsInlineMediaPlayback: true,
      );
    } else {
      params = const PlatformWebViewControllerCreationParams();
    }

    final webViewController = WebViewController.fromPlatformCreationParams(
      params,
    );

    if (webViewController.platform is AndroidWebViewController) {
      final androidController =
          webViewController.platform as AndroidWebViewController;
      await androidController.setMediaPlaybackRequiresUserGesture(false);
    }

    // Correct User Agent for iOS
    const String androidUserAgent =
        "Mozilla/5.0 (Linux; Android 10; SM-G973F) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/80.0.3987.149 Mobile Safari/537.36";
    const String iosUserAgent =
        "Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Mobile/15E148 Safari/604.1";

    await webViewController.setUserAgent(Platform.isIOS ? iosUserAgent : androidUserAgent);

    await webViewController.setJavaScriptMode(JavaScriptMode.unrestricted);
    await webViewController.setBackgroundColor(Colors.black);

    await webViewController.addJavaScriptChannel(
      'SavePositionChannel',
      onMessageReceived: (JavaScriptMessage message) async {
        final double? t = double.tryParse(message.message);
        if (t != null && t > 0) {
          await LocalStorage.saveVideoLastWatchedSecond(
            videoModel.id.toString(),
            t.toInt(),
          );
        }
      },
    );

    await webViewController.setNavigationDelegate(
      NavigationDelegate(
        onPageFinished: (String _) {
          if (mounted) setState(() => _isLoadingPage = false);
          if (Platform.isAndroid) {
            platform.invokeMethod("setSecure", {"enable": true});
          }
        },
        onWebResourceError: (WebResourceError error) {
          debugPrint("Vimeo WebView Error: ${error.description}");
        },
      ),
    );
    // Directly load the server-side player URL
    await webViewController.loadRequest(Uri.parse(url));

    if (mounted) {
      setState(() => _controller = webViewController);
      if (Platform.isAndroid) {
        platform.invokeMethod("setSecure", {"enable": true});
      }
    }
  }

  Future<void> _toggleFullScreen(BuildContext context) async {
    if (MediaQuery.of(context).orientation == Orientation.landscape) {
      await _exitFullScreenMode();
    } else {
      await _enterFullScreenMode();
    }
  }

  Future<void> _seek(int seconds) async {
    if (_controller == null) return;
    try {
      await _controller!.runJavaScript("""
        (function() {
          var offset = $seconds;
          var player = window.player || window.vimeoPlayer;
          
          if (player && typeof player.getCurrentTime === 'function' && typeof player.setCurrentTime === 'function') {
            var res = player.getCurrentTime();
            if (res && typeof res.then === 'function') {
              res.then(function(currentTime) {
                player.setCurrentTime(currentTime + offset);
              }).catch(function(e) { console.error('Seek error:', e); });
            } else {
              player.setCurrentTime(res + offset);
            }
          } else {
            // Fallback: If we can't get current time, we can't easily seek via postMessage
            // unless we know the current time, but let's try a common seekTo relative message
            // if provided by some wrappers, or just look for the iframe and try.
            var iframes = document.getElementsByTagName('iframe');
            for (var i = 0; i < iframes.length; i++) {
              // Note: Standard Vimeo doesn't support relative seek directly in postMessage
              // but we are doing our best here.
            }
          }
        })()
      """);
    } catch (e) {
      debugPrint("Seek error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: isLandscape
          ? null
          : AppBar(
              backgroundColor: Colors.grey[900],
              foregroundColor: Colors.white,
              title: Text(videoModel.title ?? 'Vimeo Player'),
              actions: [
                IconButton(
                  onPressed: _fetchAndLoad,
                  icon: const Icon(Icons.refresh),
                ),
              ],
            ),
      body: SafeArea(child: _buildBody()),
    );
  }

  Widget _buildBody() {
    if (_isLoadingData) {
      return const Center(child: CircularProgressIndicator(color: Colors.blue));
    }

    if (_errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, color: Colors.red, size: 48),
            const SizedBox(height: 12),
            Text(_errorMessage!, style: const TextStyle(color: Colors.white)),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _fetchAndLoad,
              child: const Text('إعادة'),
            ),
          ],
        ),
      );
    }

    if (_controller == null) {
      return const Center(child: CircularProgressIndicator(color: Colors.blue));
    }

    // Use platform-specific params for Hybrid Composition on Android
    PlatformWebViewWidgetCreationParams widgetParams;
    if (WebViewPlatform.instance is AndroidWebViewPlatform) {
      widgetParams = AndroidWebViewWidgetCreationParams(
        controller: _controller!.platform,
        displayWithHybridComposition: true,
      );
    } else {
      widgetParams = PlatformWebViewWidgetCreationParams(
        controller: _controller!.platform,
      );
    }

    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    return Stack(
      children: [
        Listener(
          behavior: HitTestBehavior.translucent,
          onPointerDown: (_) => _toggleControls(),
          child: WebViewWidget.fromPlatformCreationParams(params: widgetParams),
        ),
        if (_isLoadingPage)
          const Center(child: CircularProgressIndicator(color: Colors.blue)),

        // Seek Buttons with Animation
        AnimatedOpacity(
          opacity: _showControls ? 1.0 : 0.0,
          duration: const Duration(milliseconds: 300),
          child: IgnorePointer(
            ignoring: !_showControls,
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _isTakingScreenshot
                      ? SizedBox.shrink()
                      : _buildSeekOverlayButton(
                          icon: Icons.touch_app,
                          label: "10s",
                        ),
                  // Transparent center to allow interaction with player
                  SizedBox(width: 100.w),
                  _isTakingScreenshot
                      ? SizedBox.shrink()
                      : _buildSeekOverlayButton(
                          icon: Icons.touch_app,
                          label: "-10s",
                        ),
                ],
              ),
            ),
          ),
        ),

        // Other Controls (Screenshot & Fullscreen)
        Positioned(
          top: 10,
          left: 10,
          child: AnimatedOpacity(
            opacity: _showControls ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 300),
            child: IgnorePointer(
              ignoring: !_showControls,
              child: Row(
                children: [
                  FloatingActionButton.small(
                    heroTag: "scr_vimeo",
                    backgroundColor: Colors.black54,
                    onPressed: () {
                      _startControlsTimer();
                      _takeScreenshot();
                    },
                    child: const Icon(
                      Icons.camera_alt_outlined,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 8),
                  FloatingActionButton.small(
                    heroTag: "fs_vimeo",
                    backgroundColor: Colors.black54,
                    onPressed: () {
                      _startControlsTimer();
                      _toggleFullScreen(context);
                    },
                    child: Icon(
                      isLandscape ? Icons.fullscreen_exit : Icons.fullscreen,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSeekOverlayButton({
    required IconData icon,
    required String label,
  }) {
    return IgnorePointer(
      child: Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.black38,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Icon(icon, color: Colors.white, size: 40.sp),
                Text(
                  "2x",
                  style: TextStyle(color: Colors.white, fontSize: 12.sp),
                ),
              ],
            ),
            Text(
              label,
              style: TextStyle(color: Colors.white, fontSize: 12.sp),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _takeScreenshot() async {
    if (_isTakingScreenshot) return;
    try {
      setState(() => _isTakingScreenshot = true);
      if (Platform.isAndroid) {
        await platform.invokeMethod("setSecure", {"enable": false});
        await Future.delayed(const Duration(milliseconds: 300));
      }
      final status = await Permission.photos.request();
      if (!status.isGranted) {
        if (Platform.isAndroid)
          await platform.invokeMethod("setSecure", {"enable": true});
        Get.snackbar("تنبيه", "يرجى منح صلاحية الوصول للصور");
        return;
      }
      final Uint8List? pngBytes = await platform.invokeMethod<Uint8List>(
        "takeScreenshot",
      );
      if (Platform.isAndroid)
        await platform.invokeMethod("setSecure", {"enable": true});
      if (pngBytes == null) return;
      final asset = await PhotoManager.editor.saveImage(
        pngBytes,
        title: "edzo_vimeo_${DateTime.now().millisecondsSinceEpoch}",
        filename: "edzo_vimeo_${DateTime.now().millisecondsSinceEpoch}.png",
      );
      if (asset != null) Get.snackbar("بنجاح", "تم حفظ لقطة الشاشة");
    } catch (e) {
      if (Platform.isAndroid)
        await platform.invokeMethod("setSecure", {"enable": true});
    } finally {
      if (mounted) setState(() => _isTakingScreenshot = false);
    }
  }
}
