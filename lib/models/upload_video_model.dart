import 'package:dio/dio.dart';

class UploadVideoModel {
  String title;
  int courseId;
  bool isPaid;
  int chunkNumber;
  int totalChunks;
  String filename;
  String identifier;
  int totalSize;
  int chunkSize;
  MultipartFile video;

  UploadVideoModel({
    required this.title,
    required this.courseId,
    required this.isPaid,
    required this.chunkNumber,
    required this.totalChunks,
    required this.filename,
    required this.identifier,
    required this.totalSize,
    required this.chunkSize,
    required this.video,
  });

  
}