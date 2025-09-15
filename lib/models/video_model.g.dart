// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'video_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VideosResponseModel _$VideosResponseModelFromJson(Map<String, dynamic> json) =>
    VideosResponseModel(
      directVideos: (json['direct_videos'] as List<dynamic>?)
          ?.map((e) => VideoModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      playlists: (json['playlists'] as List<dynamic>?)
          ?.map((e) => PlaylistModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$VideosResponseModelToJson(
  VideosResponseModel instance,
) => <String, dynamic>{
  'direct_videos': instance.directVideos,
  'playlists': instance.playlists,
};

VideoModel _$VideoModelFromJson(Map<String, dynamic> json) => VideoModel(
  id: (json['id'] as num?)?.toInt(),
  title: json['title'] as String?,
  url: json['url'] as String?,
  isPaid: json['is_paid'] as bool?,
  courseId: (json['course_id'] as num?)?.toInt(),
  duration: (json['duration'] as num?)?.toInt(),
);

Map<String, dynamic> _$VideoModelToJson(VideoModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'is_paid': instance.isPaid,
      'course_id': instance.courseId,
      'url': instance.url,
      'duration': instance.duration,
    };
