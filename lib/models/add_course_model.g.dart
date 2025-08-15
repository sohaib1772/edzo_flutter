// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'add_course_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AddCourseResponseModel _$AddCourseResponseModelFromJson(
  Map<String, dynamic> json,
) => AddCourseResponseModel(
  json['message'] as String?,
  json['data'] == null
      ? null
      : CourseModel.fromJson(json['data'] as Map<String, dynamic>),
);

Map<String, dynamic> _$AddCourseResponseModelToJson(
  AddCourseResponseModel instance,
) => <String, dynamic>{'message': instance.message, 'data': instance.data};
