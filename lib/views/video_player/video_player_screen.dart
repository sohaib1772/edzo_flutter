import 'dart:io';

import 'package:chewie/chewie.dart';
import 'package:edzo/controllers/video_player_controller.dart';
import 'package:edzo/core/constance/app_router_keys.dart';
import 'package:edzo/core/helpers/local_storage.dart';
import 'package:edzo/core/widgets/app_text_button.dart';
import 'package:edzo/core/widgets/scaffold/app_scaffold.dart';
import 'package:edzo/models/video_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';

class VideoPlayerScreen extends StatefulWidget {
  final VideoModel videoModel = Get.arguments['videoModel'];
   VideoPlayerScreen({Key? key});
   

  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  bool _isScreenCaptured = false;

  static const platform = MethodChannel("flutter/secure");

  @override
  void initState() {
    super.initState();

    if (Platform.isAndroid) {
      // تفعيل FLAG_SECURE لمنع تصوير الشاشة
      platform.invokeMethod("setSecure", {"enable": true});
    }

    if (Platform.isIOS) {
      // الاستماع لحالة تسجيل الشاشة من Native
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

  @override
  void dispose() {
    if (Platform.isAndroid) {
      // السماح بالتصوير عند الخروج
      platform.invokeMethod("setSecure", {"enable": false});
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<VideoController>(
      init: VideoController(
        id: widget.videoModel.id ?? 0,
        title: widget.videoModel.url?.split('/').last ?? "",
        courseId: widget.videoModel.courseId ?? 0,
        videoId: widget.videoModel.id ?? 0,
      ),
      builder: (controller) {
        return Stack(
          children: [
            AppScaffold(
              leading: IconButton(
                onPressed: () {
                  Get.back(result: Get.arguments['courseModel']);
                },
                icon: Icon(Icons.arrow_back_ios_new_outlined),
              ),
              body: RefreshIndicator(
                onRefresh: () async {
                  controller.initVideo();
                },
                child: SingleChildScrollView(
                  physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                  child: Center(
                    child:
                        controller.chewieController != null &&
                             !controller.isLoading && controller.videoPlayerController.value.isInitialized
                        ? controller.isError ? AppTextButton(
                            title: "حاول مرة اخرى",
                            onPressed: ()async {
                              await  controller.initVideo();
                              controller.isError = false;
                              controller.update();
                            }
                        ) : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                widget.videoModel.title ?? "",
                                style: TextStyle(
                                  fontSize: 20.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 20.h),
                              SizedBox(
                                height: 300.h,
                                child: Chewie(
                                  controller: controller.chewieController!,
                                ),
                              ),
                            ],
                          )
                        : Container(
                          
                          height: 300.h,
                          width: double.infinity,
                          padding: EdgeInsets.all(20.r),
                          margin: EdgeInsets.all(20.r),
                          decoration: BoxDecoration(
                            color: Theme.of(context).cardColor,
                            borderRadius: BorderRadius.circular(16.r),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                            Text("جاري تحميل الفيديو ...",style: TextStyle(fontSize: 20.sp,)),
                            Text("يرجى الانتظار قليلا",style: TextStyle(fontSize: 14.sp,)),
                            SizedBox(height: 20.h),
                            LinearProgressIndicator(),
                          ],),
                        ),
                  ),
                ),
              ),
            ),
            if (_isScreenCaptured)
              Container(
                color: Colors.black,
                child: Center(
                  child: Text(
                    'تم اكتشاف تسجيل الشاشة!',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
