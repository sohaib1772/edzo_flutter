// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'course_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CoursesResponseModel _$CoursesResponseModelFromJson(
  Map<String, dynamic> json,
) => CoursesResponseModel(
  data: (json['data'] as List<dynamic>?)
      ?.map((e) => CourseModel.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$CoursesResponseModelToJson(
  CoursesResponseModel instance,
) => <String, dynamic>{'data': instance.data};

CourseModel _$CourseModelFromJson(Map<String, dynamic> json) =>
    CourseModel(
        id: (json['id'] as num?)?.toInt(),
        title: json['title'] as String?,
        description: json['description'] as String?,
        image: json['image'] as String?,
        price: (json['price'] as num?)?.toInt(),
        createdAt: json['createdAt'] as String?,
        teacherId: (json['user_id'] as num?)?.toInt(),
        isSubscribed: json['is_subscribe'] as bool,
        teacherName: json['teacher_name'] as String?,
        teacherImage: json['teacher_image'] as String?,
        subscribersCount: (json['subscribers_count'] as num?)?.toInt(),
        codes: (json['codes'] as List<dynamic>?)
            ?.map((e) => CodeModel.fromJson(e as Map<String, dynamic>))
            .toList(),
        telegramUrl: json['telegram_url'] as String?,
      )
      ..teacherInfo = json['teacher_info'] == null
          ? null
          : TeacherInfoModel.fromJson(
              json['teacher_info'] as Map<String, dynamic>,
            );

Map<String, dynamic> _$CourseModelToJson(CourseModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'image': instance.image,
      'price': instance.price,
      'createdAt': instance.createdAt,
      'user_id': instance.teacherId,
      'is_subscribe': instance.isSubscribed,
      'teacher_name': instance.teacherName,
      'teacher_image': instance.teacherImage,
      'subscribers_count': instance.subscribersCount,
      'telegram_url': instance.telegramUrl,
      'codes': instance.codes,
      'teacher_info': instance.teacherInfo,
    };
