import 'dart:async';
import 'dart:io';

import 'package:edzo/core/network/main_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';

import 'package:edzo/core/helpers/local_storage.dart';
import 'package:edzo/core/helpers/session_helper.dart';
import 'package:edzo/models/video_model.dart';
import 'package:photo_manager/photo_manager.dart';

import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/rendering.dart';

class BunnyPlayerScreen extends StatefulWidget {
  const BunnyPlayerScreen({super.key});

  @override
  State<BunnyPlayerScreen> createState() => _BunnyPlayerScreenState();
}

class _BunnyPlayerScreenState extends State<BunnyPlayerScreen>
    with WidgetsBindingObserver {
  late final VideoModel videoModel;
  late final MainApi _mainApi;

  WebViewController? _controller;
  bool _isLoadingUrl = true;
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
    _mainApi = Get.find<MainApi>();
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
  
  void _startControlsTimer() {
    _controlsTimer?.cancel();
    _controlsTimer = Timer(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() => _showControls = false);
      }
    });
  }

  void _toggleControls() {
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

  Future<void> _fetchAndLoad() async {
    setState(() {
      _isLoadingUrl = true;
      _errorMessage = null;
    });

    try {
      final guid = videoModel.guid ?? '';
      dynamic res;
      if (SessionHelper.user != null) {
        res = await _mainApi.getBunnyVideoUrl(guid);
      } else {
        res = await _mainApi.getPublicBunnyVideoUrl(guid);
      }

      final url = (res as Map?)?['url'] as String?;
      if (url == null || url.isEmpty) {
        setState(() {
          _errorMessage = 'لم يتم الحصول على رابط الفيديو';
          _isLoadingUrl = false;
        });
        return;
      }

      setState(() => _isLoadingUrl = false);
      await _initWebView(url);
    } catch (e) {
      setState(() {
        _errorMessage = 'حدث خطأ في تحميل الفيديو';
        _isLoadingUrl = false;
      });
    }
  }

  Future<void> _initWebView(String url) async {
    final savedPositionInt =
        LocalStorage.getVideoLastWatchedSecond(videoModel.id.toString()) ?? 0;
    final double savedPosition = savedPositionInt.toDouble();

    final params = const PlatformWebViewControllerCreationParams();
    final webViewController = WebViewController.fromPlatformCreationParams(
      params,
    );

    try {
      if (webViewController.platform is AndroidWebViewController) {
        await (webViewController.platform as AndroidWebViewController)
            .setMediaPlaybackRequiresUserGesture(false);
      }
    } catch (_) {
      // قد يفشل على بعض الأجهزة — نتجاهل الخطأ ونكمل
    }

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
          webViewController.runJavaScript('''
            function initPlayer() {
              var video = document.querySelector('video');
              if (video) {
                if ($savedPosition > 0) {
                  video.currentTime = $savedPosition;
                }
                
                // تحديث الوقت كل ثانيتين لدقة أعلى
                setInterval(function() {
                  if (!video.paused) {
                    SavePositionChannel.postMessage(video.currentTime.toString());
                  }
                }, 2000);

                // عند انتهاء الفيديو تماماً
                video.onended = function() {
                  SavePositionChannel.postMessage(video.duration.toString());
                };
                
                // لا نقوم بعمل video.play() هنا للسماح للمشغل الأصلي بالتحكم
                // فقط نضبط الوقت إذا كان موجوداً
                if ($savedPosition > 0 && video.currentTime < $savedPosition) {
                   video.currentTime = $savedPosition;
                }

              } else {
                setTimeout(initPlayer, 500);
              }
            }
            initPlayer();
          ''');
        },
      ),
    );

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
              title: Text(
                videoModel.title ?? '',
                style: const TextStyle(color: Colors.white),
              ),
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
      final status = await Permission.photos.request();
      if (!status.isGranted) {
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

  Widget _buildBody() {
    if (_isLoadingUrl) {
      return const Center(child: CircularProgressIndicator(color: Colors.red));
    }

    if (_errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, color: Colors.red, size: 48),
            const SizedBox(height: 12),
            Text(
              _errorMessage!,
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _fetchAndLoad,
              child: const Text('إعادة المحاولة'),
            ),
          ],
        ),
      );
    }

    if (_controller == null) {
      return const Center(child: CircularProgressIndicator(color: Colors.red));
    }

    // Build platform-aware WebViewWidget
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
          const Center(child: CircularProgressIndicator(color: Colors.red)),
        // Control Buttons Overlay (Screenshot + Fullscreen)
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
                    heroTag: "screenshot_btn",
                    backgroundColor: Colors.black54,
                    onPressed: _takeScreenshot,
                    child: const Icon(
                      Icons.camera_alt_outlined,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 8),
                  FloatingActionButton.small(
                    heroTag: "fullscreen_btn",
                    backgroundColor: Colors.black54,
                    onPressed: () => _toggleFullScreen(context),
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
}
