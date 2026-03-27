import 'package:edzo/models/playlist_model.dart';
import 'package:json_annotation/json_annotation.dart';
part 'video_model.g.dart';

enum UploadStatus { uploading, success, failed, cancelled }

@JsonSerializable()
class VideosResponseModel {
  @JsonKey(name: 'direct_videos')
  List<VideoModel>? directVideos;

  @JsonKey(name: 'videos')
  List<VideoModel>? videos;

  List<PlaylistModel>? playlists;

  List<VideoModel> get allVideos => directVideos ?? videos ?? [];

  VideosResponseModel({this.directVideos, this.videos, this.playlists});
  factory VideosResponseModel.fromJson(Map<String, dynamic> json) =>
      _$VideosResponseModelFromJson(json);
  Map<String, dynamic> toJson() => _$VideosResponseModelToJson(this);
}

@JsonSerializable()
class VideoModel {
  int? id;
  String? guid;
  String? title;
  @JsonKey(name: 'is_paid')
  bool? isPaid;
  @JsonKey(name: 'course_id')
  int? courseId;
  @JsonKey(includeFromJson: false, includeToJson: false)
  String? vimeoId;

  String? url;

  int? provider;
  @JsonKey(name: 'embed_url')
  String? embedUrl;

  int? duration;

  VideoModel({
    this.id,
    this.guid,
    this.title,
    this.url,
    this.isPaid,
    this.courseId,
    this.duration,
    this.provider,
    this.embedUrl,
  });

  factory VideoModel.fromJson(Map<String, dynamic> json) {
    return _$VideoModelFromJson(json);
  }

  bool get isVimeo => provider == 2 || (url?.contains('vimeo.com') ?? false);
  bool get isBunny =>
      provider == 3 ||
      (guid != null && guid!.isNotEmpty) ||
      (url?.contains('bunny') ?? false);
  bool get isYoutube =>
      provider == 1 ||
      (!isVimeo && !isBunny); // Default to Youtube if not Vimeo or Bunny

  Map<String, dynamic> toJson() => _$VideoModelToJson(this);
}
