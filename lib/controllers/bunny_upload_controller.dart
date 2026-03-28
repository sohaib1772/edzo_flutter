import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:edzo/controllers/edit_course_controller.dart';
import 'package:edzo/controllers/teacher_playlist_controller.dart';
import 'package:edzo/core/helpers/local_storage.dart';
import 'package:edzo/models/bunny_upload_response_model.dart';
import 'package:edzo/models/video_model.dart';
import 'package:edzo/repos/courses/courses_repo.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide MultipartFile;
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';

class UploadTask {
  final String id;
  final String title;
  final int courseId;
  final int? playlistId;
  final String fileName;
  final String filePath;
  final bool isPaid;

  final RxDouble progress = 0.0.obs;
  final RxInt duration = 0.obs;
  final Rx<UploadStatus> status = UploadStatus.uploading.obs;
  CancelToken cancelToken = CancelToken();

  String? uploadUrl;
  BunnyUploadResponseModel? bunny;
  int? laravelId;

  UploadTask({
    required this.id,
    required this.title,
    required this.courseId,
    this.playlistId,
    required this.fileName,
    required this.filePath,
    required this.isPaid,
    this.laravelId,
    this.bunny,
    this.uploadUrl,
    UploadStatus? initialStatus,
  }) {
    if (initialStatus != null) status.value = initialStatus;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'courseId': courseId,
      'playlistId': playlistId,
      'fileName': fileName,
      'filePath': filePath,
      'isPaid': isPaid,
      'laravelId': laravelId,
      'bunny': bunny?.toJson(),
      'uploadUrl': uploadUrl,
      'progress': progress.value,
      'duration': duration.value,
      'status': status.value.index,
    };
  }

  factory UploadTask.fromJson(Map<String, dynamic> json) {
    return UploadTask(
      id: json['id'],
      title: json['title'],
      courseId: json['courseId'],
      playlistId: json['playlistId'],
      fileName: json['fileName'],
      filePath: json['filePath'],
      isPaid: json['isPaid'] ?? false,
      laravelId: json['laravelId'],
      bunny: json['bunny'] != null
          ? BunnyUploadResponseModel.fromJson(json['bunny'])
          : null,
      uploadUrl: json['uploadUrl'],
      initialStatus: json['status'] != null
          ? UploadStatus.values[json['status']]
          : UploadStatus.failed,
    )
      ..duration.value = json['duration'] ?? 0
      ..progress.value = json['progress'] ?? 0.0;
  }
}

class BunnyUploadController extends GetxController {
  final CoursesRepo repo = Get.find();

  // Tasks list for monitoring
  RxList<UploadTask> tasks = <UploadTask>[].obs;
  RxList<VideoModel> pendingVideos = <VideoModel>[].obs;
  RxBool isLoadingPending = false.obs;

  // Form state
  RxBool isPicking = false.obs;
  RxBool isPaid = false.obs;
  RxBool filePicked = false.obs;
  RxString fileName = ''.obs;

  TextEditingController titleController = TextEditingController();

  XFile? pickedFile;
  int _videoDuration = 0;

  static const String _storageKey = 'bunny_upload_tasks';

  // ──────────── Pick Video ────────────
  Future<void> pickVideo() async {
    final picker = ImagePicker();
    final video = await picker.pickVideo(source: ImageSource.gallery);
    if (video == null) return;

    pickedFile = video;
    fileName.value = video.name;

    try {
      final playerController = VideoPlayerController.file(File(video.path));
      await playerController.initialize();
      _videoDuration = playerController.value.duration.inSeconds;
      await playerController.dispose();
    } catch (_) {
      _videoDuration = 0;
    }

    filePicked.value = true;
  }

  // ──────────── Persistence ────────────
  void _saveTasks() {
    final List<String> taskJsonList = tasks
        .map((t) => jsonEncode(t.toJson()))
        .toList();
    LocalStorage.sharedPreferences.setStringList(_storageKey, taskJsonList);
  }

  void _loadPendingTasks() {
    final List<String>? taskJsonList = LocalStorage.sharedPreferences
        .getStringList(_storageKey);
    if (taskJsonList != null) {
      final List<UploadTask> loadedTasks = taskJsonList
          .map((s) => UploadTask.fromJson(jsonDecode(s)))
          .toList();

      for (var task in loadedTasks) {
        if (task.status.value == UploadStatus.uploading) {
          task.status.value =
              UploadStatus.failed; // Marked as failed on restart
        }
      }
      tasks.assignAll(loadedTasks);
    }
  }

  // ──────────── Upload Orchestration ────────────
  Future<void> uploadBunny(int courseId, int? playlistId) async {
    if (pickedFile == null || titleController.text.trim().isEmpty) return;

    final taskTitle = titleController.text.trim();
    final taskFilePath = pickedFile!.path;
    final taskDuration = _videoDuration;
    final taskIsPaid = isPaid.value;
    final taskFileName = fileName.value;
    final taskId = DateTime.now().millisecondsSinceEpoch.toString();

    final newTask = UploadTask(
      id: taskId,
      title: taskTitle,
      courseId: courseId,
      playlistId: playlistId,
      fileName: taskFileName,
      filePath: taskFilePath,
      isPaid: taskIsPaid,
    )..duration.value = taskDuration;

    tasks.add(newTask);
    _saveTasks();
    clearPicker();

    _processTask(newTask, taskDuration);
  }

  Future<void> _processTask(UploadTask task, int duration) async {
    try {
      task.status.value = UploadStatus.uploading;
      final file = File(task.filePath);
      if (!await file.exists()) {
        _handleTaskError(task, "ملف الفيديو لم يعد موجوداً في المسار المحدد");
        return;
      }

      final fileSize = await file.length();
      int attempts = 0;
      const int maxAttempts = 3;

      while (attempts < maxAttempts) {
        attempts++;

        // 1️⃣ Prepare / Refresh Signature if needed
        bool isExpired =
            task.bunny == null ||
            (DateTime.now().millisecondsSinceEpoch / 1000) >
                (task.bunny!.authorizationExpire - 300);

        if (task.laravelId == null || isExpired) {
          debugPrint(
            "Preparing/Refreshing Bunny Signature (Attempt $attempts)",
          );
          final prepRes = await repo.prepareBunnyUpload(
            courseId: task.courseId,
            title: task.title,
            isPaid: task.isPaid,
            duration: duration,
            playlistId: task.playlistId,
            cancelToken: task.cancelToken,
          );

          if (!prepRes.status) {
            _handleTaskError(task, "خطأ في تجهيز الفيديو: ${prepRes.message}");
            return;
          }

          final bunny = BunnyUploadResponseModel.fromJson(prepRes.data!);
          task.bunny = bunny;
          task.laravelId = bunny.id;
          // If signature was refreshed, old uploadUrl is definitely invalid
          task.uploadUrl = null;
          _saveTasks();
        }

        // 2️⃣ Initiate TUS Session
        if (task.uploadUrl == null) {
          debugPrint("Initiating TUS Session (Attempt $attempts)");
          if (task.status.value == UploadStatus.cancelled) return;
          final location = await _tusInitiate(
            task.bunny!,
            fileSize,
            task.cancelToken,
          );
          if (location == null) {
            // Wait a bit and retry the loop
            debugPrint("Initiate failed. Retrying in 2s...");
            await Future.delayed(const Duration(seconds: 2));
            continue;
          }
          task.uploadUrl = location.startsWith('http')
              ? location
              : 'https://video.bunnycdn.com$location';
          _saveTasks();
        }

        // 3️⃣ Get Offset
        final offset = await _tusGetOffset(task);

        if (offset == -2) {
          // Session expired (404), clear URL to force a new TUS session for the same video
          task.uploadUrl = null;
          continue;
        }

        if (offset == -1) {
          debugPrint("فشل استرداد الـ Offset بعد محاولات متعددة.");
          await Future.delayed(const Duration(seconds: 5));
          continue;
        }

        // Now offset holds the correct value from the server
        debugPrint("استكمال الرفع من النقطة: $offset");

        // 4️⃣ PATCH Upload
        if (task.status.value == UploadStatus.cancelled) return;
        final success = await _tusPatch(
          task.bunny!,
          task.uploadUrl!,
          file,
          fileSize,
          task,
          offset: offset, // Stream starts from here
        );

        if (success) {
          debugPrint("Upload Success: ${task.title}");
          task.status.value = UploadStatus.success;
          _onUploadSuccess(task.courseId);
          _saveTasks();
          return;
        } else {
          if (task.status.value == UploadStatus.cancelled) return;
          debugPrint("PATCH failed. Retrying global process loop...");
          await Future.delayed(const Duration(seconds: 2));
        }
      }

      _handleTaskError(task, "فشل استئناف الرفع بعد عدة محاولات");
    } catch (e) {
      if (e is DioException && e.type == DioExceptionType.cancel) {
        task.status.value = UploadStatus.cancelled;
      } else {
        _handleTaskError(task, "حدث خطأ غير متوقع: $e");
      }
    }
  }

  Future<void> retryUpload(String taskId) async {
    final task = tasks.firstWhereOrNull((t) => t.id == taskId);
    if (task == null) return;
    task.cancelToken = CancelToken();
    _processTask(task, task.duration.value);
  }

  // ──────────── TUS Methods ────────────

  Future<int> _tusGetOffset(UploadTask task) async {
    if (task.uploadUrl == null) return 0;

    final dio = Dio();
    int retries = 5;

    while (retries > 0) {
      try {
        final response = await dio.head(
          task.uploadUrl!,
          options: Options(
            headers: {
              'Tus-Resumable': '1.0.0',
              'LibraryId': task.bunny!.libraryId,
              'AuthorizationSignature': task.bunny!.authorizationSignature,
              'AuthorizationExpire': task.bunny!.authorizationExpire.toString(),
              'VideoId': task.bunny!.videoId,
            },
            // Allow 404 and 423 to handle them manually
            validateStatus: (status) => status != null && status < 500,
          ),
        );

        if (response.statusCode == 423) {
          debugPrint(
            "الملف مغلق حالياً (Locked)، سأنتظر 3 ثواني... المحاولات المتبقية: $retries",
          );
          await Future.delayed(const Duration(seconds: 3));
          retries--;
          continue;
        }

        if (response.statusCode == 404) {
          debugPrint(
            "الجلسة انتهت (404). يجب بدء جلسة جديدة ولكن مع نفس الـ VideoId",
          );
          return -2; // Special code to trigger TUS re-initiation
        }

        final offsetStr = response.headers.value('upload-offset');
        return int.tryParse(offsetStr ?? '0') ?? 0;
      } catch (e) {
        debugPrint("خطأ أثناء جلب الـ Offset: $e");
        await Future.delayed(const Duration(seconds: 2));
        retries--;
      }
    }
    return -1; // Final failure to get Offset
  }

  Future<String?> _tusInitiate(
    BunnyUploadResponseModel bunny,
    int fileSize,
    CancelToken cancelToken,
  ) async {
    final dio = Dio();
    try {
      final response = await dio.post(
        bunny.tusEndpoint,
        cancelToken: cancelToken,
        options: Options(
          headers: {
            'AuthorizationSignature': bunny.authorizationSignature,
            'AuthorizationExpire': bunny.authorizationExpire.toString(),
            'VideoId': bunny.videoId,
            'LibraryId': bunny.libraryId,
            'Tus-Resumable': '1.0.0',
            'Upload-Length': fileSize.toString(),
            'Content-Length': '0',
          },
          validateStatus: (status) => status != null && status < 400,
          followRedirects: false,
        ),
      );
      return response.headers.value('location');
    } catch (e) {
      debugPrint("TUS initiate error: $e");
      return null;
    }
  }

  Future<bool> _tusPatch(
    BunnyUploadResponseModel bunny,
    String uploadUrl,
    File file,
    int fileSize,
    UploadTask task, {
    int offset = 0,
  }) async {
    final dio = Dio();
    try {
      // Memory efficient streaming with progress wrap
      final stream = _wrapStream(file.openRead(offset), task, offset, fileSize);
      final remainingSize = fileSize - offset;

      await dio.patch(
        uploadUrl,
        cancelToken: task.cancelToken,
        data: stream,
        options: Options(
          headers: {
            'Tus-Resumable': '1.0.0',
            'Upload-Offset': offset.toString(),
            'Content-Type': 'application/offset+octet-stream',
            'Content-Length': remainingSize.toString(),
            'LibraryId': bunny.libraryId,
            'AuthorizationSignature': bunny.authorizationSignature,
            'AuthorizationExpire': bunny.authorizationExpire.toString(),
            'VideoId': bunny.videoId,
          },
          validateStatus: (status) => status != null && status < 400,
        ),
        onSendProgress: (sent, total) {
          // Wrapped stream handles progress
        },
      );
      return true;
    } catch (e) {
      debugPrint("Bunny PATCH error: $e");
      return false;
    }
  }

  Stream<List<int>> _wrapStream(Stream<List<int>> stream, UploadTask task, int offset, int totalSize) async* {
    int sent = 0;
    await for (final chunk in stream) {
      sent += chunk.length;
      double currentProgress = (offset + sent) / totalSize;
      if (currentProgress > task.progress.value) {
        task.progress.value = currentProgress;
      }
      yield chunk;
    }
  }

  void cancelUpload(String taskId) {
    final task = tasks.firstWhereOrNull((t) => t.id == taskId);
    if (task != null && task.status.value == UploadStatus.uploading) {
      task.cancelToken.cancel("User cancelled");
      task.status.value = UploadStatus.cancelled;
      if (task.uploadUrl != null && task.bunny != null) {
        _tusDelete(task.uploadUrl!, task.bunny!);
      }
      if (task.laravelId != null) {
        repo.deleteCourseVideo(task.laravelId!);
      }
      _saveTasks();
    }
  }

  Future<void> _tusDelete(
    String uploadUrl,
    BunnyUploadResponseModel bunny,
  ) async {
    final dio = Dio();
    try {
      await dio.delete(
        uploadUrl,
        options: Options(
          headers: {
            'Tus-Resumable': '1.0.0',
            'LibraryId': bunny.libraryId,
            'AuthorizationSignature': bunny.authorizationSignature,
            'AuthorizationExpire': bunny.authorizationExpire.toString(),
            'VideoId': bunny.videoId,
          },
        ),
      );
    } catch (_) {}
  }

  void removeTask(String taskId) {
    tasks.removeWhere((t) => t.id == taskId);
    _saveTasks();
  }

  void _handleTaskError(UploadTask task, String message) {
    task.status.value = UploadStatus.failed;
    Get.snackbar(
      "خطأ في رفع ${task.title}",
      message,
      colorText: Colors.red.shade300,
    );
    _saveTasks();
  }

  void _onUploadSuccess(int courseId) async {
    Get.find<EditCourseController>().getCourseVideos();
    final pc = Get.find<TeacherPlaylistController>();
    if (pc.playlists.isNotEmpty) pc.getPlaylists(courseId);
  }

  Future<void> fetchPendingVideos() async {
    isLoadingPending.value = true;
    final res = await repo.getPendingVideos();
    isLoadingPending.value = false;
    if (res.status && res.data != null) {
      pendingVideos.value = res.data!.allVideos;
    }
  }

  Future<void> deletePendingVideo(int id) async {
    final res = await repo.deleteCourseVideo(id);
    if (res.status) {
      pendingVideos.removeWhere((v) => v.id == id);
      Get.snackbar("بنجاح", "تم حذف الفيديو المعلق");
    }
  }

  void clearPicker() {
    titleController.clear();
    isPaid.value = false;
    filePicked.value = false;
    fileName.value = '';
    pickedFile = null;
    _videoDuration = 0;
  }

  @override
  void onInit() {
    super.onInit();
    _loadPendingTasks();
    fetchPendingVideos();
  }

  @override
  void onClose() {
    titleController.dispose();
    super.onClose();
  }
}
