// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'playlist_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PlaylistModel _$PlaylistModelFromJson(Map<String, dynamic> json) =>
    PlaylistModel(
      id: (json['id'] as num?)?.toInt(),
      title: json['title'] as String?,
      videos: (json['videos'] as List<dynamic>?)
          ?.map((e) => VideoModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$PlaylistModelToJson(PlaylistModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'videos': instance.videos,
    };

AddPlaylistModel _$AddPlaylistModelFromJson(Map<String, dynamic> json) =>
    AddPlaylistModel(
      title: json['title'] as String?,
      courseId: (json['course_id'] as num).toInt(),
      id: (json['id'] as num?)?.toInt(),
    );

Map<String, dynamic> _$AddPlaylistModelToJson(AddPlaylistModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'course_id': instance.courseId,
    };
