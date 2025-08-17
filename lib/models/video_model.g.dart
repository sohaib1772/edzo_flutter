// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'video_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VideosResponseModel _$VideosResponseModelFromJson(Map<String, dynamic> json) =>
    VideosResponseModel(
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => VideoModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$VideosResponseModelToJson(
  VideosResponseModel instance,
) => <String, dynamic>{'data': instance.data};

VideoModel _$VideoModelFromJson(Map<String, dynamic> json) => VideoModel(
  id: (json['id'] as num?)?.toInt(),
  title: json['title'] as String?,
  url: json['url'] as String?,
  isPaid: json['is_paid'] as bool?,
  courseId: (json['course_id'] as num?)?.toInt(),
);

Map<String, dynamic> _$VideoModelToJson(VideoModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'is_paid': instance.isPaid,
      'course_id': instance.courseId,
      'url': instance.url,
    };
