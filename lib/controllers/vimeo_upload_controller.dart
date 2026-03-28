import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:edzo/controllers/edit_course_controller.dart';
import 'package:edzo/controllers/teacher_playlist_controller.dart';
import 'package:edzo/core/helpers/local_storage.dart';
import 'package:edzo/models/video_model.dart';
import 'package:edzo/repos/courses/courses_repo.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide MultipartFile;
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';

// enum UploadStatus { uploading, success, failed, cancelled }

class VimeoUploadTask {
  final String id;
  final String title;
  final int courseId;
  final int? playlistId;
  final String fileName;
  final String filePath;
  final bool isPaid;

  int totalSize = 0;
  final RxDouble progress = 0.0.obs;
  final RxInt duration = 0.obs;
  final Rx<UploadStatus> status = UploadStatus.uploading.obs;
  CancelToken cancelToken = CancelToken();

  String? uploadUrl;
  int? laravelId;
  String? vimeoId;

  VimeoUploadTask({
    required this.id,
    required this.title,
    required this.courseId,
    this.playlistId,
    required this.fileName,
    required this.filePath,
    required this.isPaid,
    this.laravelId,
    this.vimeoId,
    this.uploadUrl,
    this.totalSize = 0,
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
      'vimeoId': vimeoId,
      'uploadUrl': uploadUrl,
      'totalSize': totalSize,
      'progress': progress.value,
      'duration': duration.value,
      'status': status.value.index,
    };
  }

  factory VimeoUploadTask.fromJson(Map<String, dynamic> json) {
    return VimeoUploadTask(
      id: json['id'],
      title: json['title'],
      courseId: json['courseId'],
      playlistId: json['playlistId'],
      fileName: json['fileName'],
      filePath: json['filePath'],
      isPaid: json['isPaid'] ?? false,
      laravelId: json['laravelId'],
      vimeoId: json['vimeoId'],
      uploadUrl: json['uploadUrl'],
      totalSize: json['totalSize'] ?? 0,
      initialStatus: json['status'] != null
          ? UploadStatus.values[json['status']]
          : UploadStatus.failed,
    )
      ..duration.value = json['duration'] ?? 0
      ..progress.value = json['progress'] ?? 0.0;
  }
}

class VimeoUploadController extends GetxController {
  final CoursesRepo repo = Get.find();

  RxList<VimeoUploadTask> tasks = <VimeoUploadTask>[].obs;
  RxList<VideoModel> pendingVideos = <VideoModel>[].obs;
  RxBool isLoadingPending = false.obs;

  RxBool isPicking = false.obs;
  RxBool isPaid = false.obs;
  RxBool filePicked = false.obs;
  RxString fileName = ''.obs;

  TextEditingController titleController = TextEditingController();
  XFile? pickedFile;
  int _videoSize = 0;
  int _videoDuration = 0;

  static const String _storageKey = 'vimeo_upload_tasks';

  Future<void> pickVideo() async {
    final picker = ImagePicker();
    final video = await picker.pickVideo(source: ImageSource.gallery);
    if (video == null) return;

    pickedFile = video;
    fileName.value = video.name;
    _videoSize = await File(video.path).length();

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
      final List<VimeoUploadTask> loadedTasks = taskJsonList
          .map((s) => VimeoUploadTask.fromJson(jsonDecode(s)))
          .toList();

      for (var task in loadedTasks) {
        if (task.status.value == UploadStatus.uploading) {
          task.status.value = UploadStatus.failed;
        }
      }
      tasks.assignAll(loadedTasks);
    }
  }

  Future<void> uploadVimeo(int courseId, int? playlistId) async {
    if (pickedFile == null || titleController.text.trim().isEmpty) return;

    final taskTitle = titleController.text.trim();
    final taskFilePath = pickedFile!.path;
    final taskIsPaid = isPaid.value;
    final taskFileName = fileName.value;
    final taskSize = _videoSize;
    final taskDuration = _videoDuration;
    final taskId = DateTime.now().millisecondsSinceEpoch.toString();

    final newTask = VimeoUploadTask(
      id: taskId,
      title: taskTitle,
      courseId: courseId,
      playlistId: playlistId,
      fileName: taskFileName,
      filePath: taskFilePath,
      isPaid: taskIsPaid,
      totalSize: taskSize,
    )..duration.value = taskDuration;

    tasks.add(newTask);
    _saveTasks();
    clearPicker();

    _processTask(newTask, taskSize, taskDuration);
  }

  Future<void> _processTask(VimeoUploadTask task, int size, int duration) async {
    try {
      task.status.value = UploadStatus.uploading;
      final file = File(task.filePath);
      if (!await file.exists()) {
        _handleTaskError(task, "ملف الفيديو لم يعد موجوداً");
        return;
      }

      // Ensure we have a valid totalSize (especially after app restart)
      if (task.totalSize <= 0) {
        task.totalSize = await file.length();
        _saveTasks();
      }
      final size = task.totalSize;

      int attempts = 0;
      const int maxAttempts = 3;

      while (attempts < maxAttempts) {
        attempts++;

        if (task.uploadUrl == null) {
          final prepRes = await repo.prepareVimeoUpload(
            courseId: task.courseId,
            title: task.title,
            isPaid: task.isPaid,
            size: size,
            duration: duration,
            playlistId: task.playlistId,
            cancelToken: task.cancelToken,
          );

          if (!prepRes.status) {
            _handleTaskError(task, "خطأ في تجهيز الفيديو: ${prepRes.message}");
            return;
          }

          task.uploadUrl = prepRes.data!['upload_link'];
          task.laravelId = prepRes.data!['video']['id'];
          task.vimeoId = prepRes.data!['vimeo_id'];
          _saveTasks();
        }

        final offset = await _tusGetOffset(task);
        if (offset == -2) {
          // Session expired or 404, force re-preparation
          debugPrint("Vimeo Session expired (404). Re-preparing...");
          task.uploadUrl = null;
          continue;
        }

        if (offset == -1) {
          await Future.delayed(const Duration(seconds: 5));
          continue;
        }

        final success = await _tusPatch(task, file, size, offset);
        if (success) {
          task.status.value = UploadStatus.success;
          _onUploadSuccess(task.courseId);
          _saveTasks();
          return;
        } else {
          await Future.delayed(const Duration(seconds: 2));
        }
      }
      _handleTaskError(task, "فشل الرفع بعد عدة محاولات");
    } catch (e) {
      if (e is DioException && e.type == DioExceptionType.cancel) {
        task.status.value = UploadStatus.cancelled;
      } else {
        _handleTaskError(task, "خطأ غير متوقع: $e");
      }
    }
  }

  Future<int> _tusGetOffset(VimeoUploadTask task) async {
    final dio = Dio();
    try {
      final response = await dio.head(
        task.uploadUrl!,
        options: Options(
          headers: {'Tus-Resumable': '1.0.0'},
          validateStatus: (status) => status != null && status < 500,
        ),
      );
      if (response.statusCode == 404) return -2; // Session expired
      final offsetStr = response.headers.value('upload-offset');
      return int.tryParse(offsetStr ?? '0') ?? 0;
    } catch (e) {
      debugPrint("Vimeo GetOffset error: $e");
      return -1;
    }
  }

  Future<bool> _tusPatch(VimeoUploadTask task, File file, int totalSize, int offset) async {
    final dio = Dio();
    try {
      final stream = _wrapStream(file.openRead(offset), task, offset, totalSize);
      await dio.patch(
        task.uploadUrl!,
        cancelToken: task.cancelToken,
        data: stream,
        options: Options(
          headers: {
            'Tus-Resumable': '1.0.0',
            'Upload-Offset': offset.toString(),
            'Content-Type': 'application/offset+octet-stream',
            'Content-Length': (totalSize - offset).toString(),
          },
        ),
        onSendProgress: (sent, total) {
          // Dio's onSendProgress can be unreliable for raw streams.
          // We will also use the stream wrapper to ensure progress updates.
        },
      );
      return true;
    } catch (e) {
      debugPrint("Vimeo PATCH error: $e");
      return false;
    }
  }

  Stream<List<int>> _wrapStream(Stream<List<int>> stream, VimeoUploadTask task, int offset, int totalSize) async* {
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
      if (task.laravelId != null) repo.deleteCourseVideo(task.laravelId!);
      _saveTasks();
    }
  }

  void retryUpload(String taskId) {
    final task = tasks.firstWhereOrNull((t) => t.id == taskId);
    if (task == null) return;
    task.cancelToken = CancelToken();
    _processTask(task, task.totalSize, task.duration.value);
  }

  void removeTask(String taskId) {
    tasks.removeWhere((t) => t.id == taskId);
    _saveTasks();
  }

  void _handleTaskError(VimeoUploadTask task, String message) {
    task.status.value = UploadStatus.failed;
    Get.snackbar("خطأ", message, colorText: Colors.red.shade300);
    _saveTasks();
  }

  void _onUploadSuccess(int courseId) {
    Get.find<EditCourseController>().getCourseVideos();
    final pc = Get.find<TeacherPlaylistController>();
    if (pc.playlists.isNotEmpty) pc.getPlaylists(courseId);
  }

  void clearPicker() {
    titleController.clear();
    isPaid.value = false;
    filePicked.value = false;
    fileName.value = '';
    pickedFile = null;
    _videoSize = 0;
  }

  @override
  void onInit() {
    super.onInit();
    _loadPendingTasks();
  }
}
