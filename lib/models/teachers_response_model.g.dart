// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'teachers_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TeachersResponseModel _$TeachersResponseModelFromJson(
  Map<String, dynamic> json,
) => TeachersResponseModel(
  data: (json['data'] as List<dynamic>?)
      ?.map((e) => TeachersInfoModel.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$TeachersResponseModelToJson(
  TeachersResponseModel instance,
) => <String, dynamic>{'data': instance.data};

TeachersInfoModel _$TeachersInfoModelFromJson(Map<String, dynamic> json) =>
    TeachersInfoModel(
      id: (json['id'] as num?)?.toInt(),
      name: json['name'] as String?,
      bio: json['bio'] as String?,
      image: json['image'] as String?,
      coursesCount: (json['courses_count'] as num?)?.toInt(),
      totalStudentsCount: (json['total_students_count'] as num?)?.toInt(),
      user: json['user'] == null
          ? null
          : UserModel.fromJson(json['user'] as Map<String, dynamic>),
      courses: (json['courses'] as List<dynamic>?)
          ?.map((e) => TeacherCoursesModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      isPin: json['is_pin'] as bool?,
    );

Map<String, dynamic> _$TeachersInfoModelToJson(TeachersInfoModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'bio': instance.bio,
      'image': instance.image,
      'courses_count': instance.coursesCount,
      'total_students_count': instance.totalStudentsCount,
      'user': instance.user,
      'courses': instance.courses,
      'is_pin': instance.isPin,
    };

TeacherCoursesModel _$TeacherCoursesModelFromJson(Map<String, dynamic> json) =>
    TeacherCoursesModel(
      id: (json['id'] as num?)?.toInt(),
      title: json['title'] as String?,
      totalSubscribers: (json['total_subscribers'] as num?)?.toInt(),
      monthlySubscribers: (json['monthly_stats'] as List<dynamic>?)
          ?.map(
            (e) => MonthlySubscribersModel.fromJson(e as Map<String, dynamic>),
          )
          .toList(),
    );

Map<String, dynamic> _$TeacherCoursesModelToJson(
  TeacherCoursesModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'total_subscribers': instance.totalSubscribers,
  'monthly_stats': instance.monthlySubscribers,
};
