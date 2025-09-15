import 'package:edzo/models/playlist_model.dart';
import 'package:json_annotation/json_annotation.dart';
part 'video_model.g.dart';
@JsonSerializable()
class VideosResponseModel {
  @JsonKey(name: 'direct_videos')
  List<VideoModel>? directVideos;

  List<PlaylistModel>? playlists;

  VideosResponseModel({this.directVideos,this.playlists});
  factory VideosResponseModel.fromJson(Map<String, dynamic> json) =>
      _$VideosResponseModelFromJson(json);
      Map<String, dynamic> toJson() => _$VideosResponseModelToJson(this);
} 
@JsonSerializable()
class VideoModel {
  int? id;
  String? title;
  //@JsonKey(name: 'path')
  //String? url;
  @JsonKey(name: 'is_paid')
  bool? isPaid;
  @JsonKey(name: 'course_id')
  int? courseId;
  
  String? url;

  int? duration;

  VideoModel({
    this.id,
    this.title,
    this.url,
    this.isPaid,
    this.courseId,
    this.duration
  });

  factory VideoModel.fromJson(Map<String, dynamic> json) =>
      _$VideoModelFromJson(json);
      Map<String, dynamic> toJson() => _$VideoModelToJson(this);
}


