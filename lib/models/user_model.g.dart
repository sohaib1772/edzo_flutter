// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UsersResponseModel _$UsersResponseModelFromJson(Map<String, dynamic> json) =>
    UsersResponseModel(
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => UserModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$UsersResponseModelToJson(UsersResponseModel instance) =>
    <String, dynamic>{'data': instance.data};

UserResponseModel _$UserResponseModelFromJson(Map<String, dynamic> json) =>
    UserResponseModel(
      data: json['data'] == null
          ? null
          : UserModel.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$UserResponseModelToJson(UserResponseModel instance) =>
    <String, dynamic>{'data': instance.data};

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
  name: json['name'] as String?,
  email: json['email'] as String?,
  password: json['password'] as String?,
  passwordConfirmation: json['password_confirmation'] as String?,
  token: json['token'] as String?,
  role: json['role'] as String?,
  uid: json['uid'] as String?,
  emailVerifiedAt: json['email_verified_at'] as String?,
  teacherInfo: json['teacher_info'] == null
      ? null
      : TeacherInfoModel.fromJson(json['teacher_info'] as Map<String, dynamic>),
  totalCoursesCount: (json['teacher_courses_count'] as num?)?.toInt(),
  totalSubscriptionsCount: (json['total_subscribers_count'] as num?)?.toInt(),
  teacherCoursesModel: (json['teacher_courses'] as List<dynamic>?)
      ?.map((e) => TeacherCoursesModel.fromJson(e as Map<String, dynamic>))
      .toList(),
  id: (json['id'] as num?)?.toInt(),
);

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'email': instance.email,
  'email_verified_at': instance.emailVerifiedAt,
  'password': instance.password,
  'password_confirmation': instance.passwordConfirmation,
  'token': instance.token,
  'role': instance.role,
  'uid': instance.uid,
  'teacher_info': instance.teacherInfo,
  'teacher_courses_count': instance.totalCoursesCount,
  'total_subscribers_count': instance.totalSubscriptionsCount,
  'teacher_courses': instance.teacherCoursesModel,
};
