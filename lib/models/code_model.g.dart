// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'code_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CodesResponseModel _$CodesResponseModelFromJson(Map<String, dynamic> json) =>
    CodesResponseModel(
      (json['data'] as List<dynamic>?)
          ?.map((e) => CodeModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$CodesResponseModelToJson(CodesResponseModel instance) =>
    <String, dynamic>{'data': instance.data};

SingleCodesResponseModel _$SingleCodesResponseModelFromJson(
  Map<String, dynamic> json,
) => SingleCodesResponseModel(
  json['data'] == null
      ? null
      : CodeModel.fromJson(json['data'] as Map<String, dynamic>),
);

Map<String, dynamic> _$SingleCodesResponseModelToJson(
  SingleCodesResponseModel instance,
) => <String, dynamic>{'data': instance.data};

CodeModel _$CodeModelFromJson(Map<String, dynamic> json) => CodeModel(
  id: (json['id'] as num?)?.toInt(),
  code: json['code'] as String?,
  courseId: (json['course_id'] as num?)?.toInt(),
  status: (json['status'] as num?)?.toInt(),
  userId: (json['user_id'] as num?)?.toInt(),
  user: json['user'] == null
      ? null
      : UserModel.fromJson(json['user'] as Map<String, dynamic>),
  createdAt: json['created_at'] as String?,
  updatedAt: json['updated_at'] as String?,
);

Map<String, dynamic> _$CodeModelToJson(CodeModel instance) => <String, dynamic>{
  'id': instance.id,
  'code': instance.code,
  'course_id': instance.courseId,
  'status': instance.status,
  'user_id': instance.userId,
  'user': instance.user,
  'created_at': instance.createdAt,
  'updated_at': instance.updatedAt,
};
