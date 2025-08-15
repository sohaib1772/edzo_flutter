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
      user: json['user'] == null
          ? null
          : UserModel.fromJson(json['user'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$TeachersInfoModelToJson(TeachersInfoModel instance) =>
    <String, dynamic>{'user': instance.user};

TeacherCoursesModel _$TeacherCoursesModelFromJson(Map<String, dynamic> json) =>
    TeacherCoursesModel(
      id: (json['id'] as num?)?.toInt(),
      title: json['title'] as String?,
      monthlySubscribers: (json['monthly_subscribers'] as List<dynamic>?)
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
  'monthly_subscribers': instance.monthlySubscribers,
};
