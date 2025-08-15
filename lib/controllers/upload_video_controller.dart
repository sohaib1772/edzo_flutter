import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:edzo/controllers/edit_course_controller.dart';
import 'package:edzo/core/helpers/local_storage.dart';
import 'package:edzo/models/upload_video_model.dart';
import 'package:edzo/repos/courses/courses_repo.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide MultipartFile;

import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class UploadVideoController extends GetxController {
  RxBool isPaid = false.obs;
  TextEditingController titleController = TextEditingController();

  final ImagePicker picker = ImagePicker();
  final int chunkSize = 1024 * 1024;
  final CoursesRepo repo = Get.find(); // إضافة الـ repo هنا
  var isUploading = false.obs;
  var progress = 0.0.obs;
  XFile? pickedFile;
  Rx isPicked = false.obs;
  Uint8List? thumbnailBytes;
  RxBool unableToUpload = false.obs;
  Future<void> pickVideo() async {
    pickedFile = await picker.pickVideo(source: ImageSource.gallery);
    if (pickedFile != null) {
      thumbnailBytes = await VideoThumbnail.thumbnailData(
        video: pickedFile!.path,
        imageFormat: ImageFormat.JPEG,
      );
      isPicked.value = true;
    }
  }

  Future<void> uploadVideo(int courseId) async {
    if (pickedFile == null) {
      Get.snackbar(
        "يرجى اختيار الفيديو اولا",
        "",
        colorText: Colors.red.shade300,
      );
      return;
    }
    await _upload(
      File(pickedFile!.path),
      titleController.text,
      courseId,
      isPaid.value,
    );
  }

  Future<void> _upload(
    File file,
    String title,
    int courseId,
    bool isPaid,
  ) async {
    isUploading.value = true;
    progress.value = 0.0;

    String fileNameWithoutExt = basename(file.path).split(".").first;
    String fileName = basename(file.path);
    int fileSize = await file.length();
    int totalChunks = (fileSize / chunkSize).ceil();
    String identifier = "${fileNameWithoutExt}_$fileSize";

    int lastUploadedChunk =
        await LocalStorage.getLastChunkNumber(fileNameWithoutExt) ?? 0;

    RandomAccessFile raf = await file.open();

    for (
      int chunkNumber = lastUploadedChunk;
      chunkNumber < totalChunks;
      chunkNumber++
    ) {
      int start = chunkNumber * chunkSize;
      int end = (start + chunkSize > fileSize) ? fileSize : start + chunkSize;
      int length = end - start;

      raf.setPositionSync(start);
      List<int> chunkData = raf.readSync(length);

      final multipartFile = MultipartFile.fromBytes(
        chunkData,
        filename: fileName,
      );

      final model = UploadVideoModel(
        title: title,
        courseId: courseId,
        isPaid: isPaid,
        chunkNumber: chunkNumber + 1,
        totalChunks: totalChunks,
        filename: fileName,
        identifier: identifier,
        totalSize: fileSize,
        chunkSize: chunkSize,
        video: multipartFile,
      );

      final res = await repo.uploadVideo(model);
      if (!res.status) {
        Get.snackbar(
          "خطاء في رفع الفيديو",
          res.errorHandler!.getErrorsList(),
          colorText: Colors.red.shade300,
        );
        isUploading.value = false;
        unableToUpload.value = true;
        return;
      }

      await LocalStorage.saveLastChunkNumber(
        fileNameWithoutExt,
        chunkNumber + 1,
      );
      progress.value = (chunkNumber + 1) / totalChunks;
    }

    await raf.close();

    if ((await LocalStorage.getLastChunkNumber(fileNameWithoutExt) ?? 0) >=
        totalChunks) {
      await LocalStorage.removeLastChunkNumber(fileNameWithoutExt);
          await Get.find<EditCourseController>().getCourseVideos();

      clear();
      Get.snackbar(
        "تم رفع الفيديو بنجاح",
        "",
        colorText: Colors.green.shade300,
      );
    }
    isUploading.value = false;
  }

  void clear(){
    titleController.clear();
    isPaid.value = false;
    isPicked.value = false;
    pickedFile = null;
    unableToUpload.value = false;
    thumbnailBytes = null;
    isUploading.value = false;
    progress.value = 0.0;
  }
}
