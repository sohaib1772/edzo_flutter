
import 'package:edzo/models/video_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'playlist_model.g.dart';
@JsonSerializable()
class PlaylistModel{
  int? id;
  String? title;
  List<VideoModel>? videos;

  PlaylistModel({this.id, this.title, this.videos});

  factory PlaylistModel.fromJson(Map<String, dynamic> json) => _$PlaylistModelFromJson(json);

  Map<String, dynamic> toJson() => _$PlaylistModelToJson(this);
}

@JsonSerializable()
class AddPlaylistModel{
  int? id;
  String? title;
  @JsonKey(name: "course_id")
  int courseId;
  AddPlaylistModel({this.title,required this.courseId,this.id});

  factory AddPlaylistModel.fromJson(Map<String, dynamic> json) => _$AddPlaylistModelFromJson(json);

  Map<String, dynamic> toJson() => _$AddPlaylistModelToJson(this);

}