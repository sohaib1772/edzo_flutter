

import 'package:Edzo/models/teacher_info_model.dart';
import 'package:Edzo/models/teachers_response_model.dart';
import 'package:json_annotation/json_annotation.dart';
part 'user_model.g.dart';

@JsonSerializable()
class UsersResponseModel {
  List<UserModel>? data;
  UsersResponseModel({this.data});
  factory UsersResponseModel.fromJson(Map<String, dynamic> json) =>
      _$UsersResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$UsersResponseModelToJson(this);
}
@JsonSerializable()
class UserResponseModel {
  UserModel? data;
  UserResponseModel({this.data});
  factory UserResponseModel.fromJson(Map<String, dynamic> json) =>
      _$UserResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserResponseModelToJson(this);
}
@JsonSerializable()
class UserModel {
  int? id;
  String? name;
  String? email;
  @JsonKey(name: "email_verified_at")
  String? emailVerifiedAt;

  String? password;
  @JsonKey(name: "password_confirmation")
  String? passwordConfirmation;
  String? token;
  String? role;
  String? uid;

  //for teahcers
  @JsonKey(name: "teacher_info")
  TeacherInfoModel ? teacherInfo;
  @JsonKey(name: "teacher_courses_count")
  int? totalCoursesCount;
  @JsonKey(name: "total_subscribers_count")
  int? totalSubscriptionsCount;
  @JsonKey(name: "teacher_courses")
  List<TeacherCoursesModel>? teacherCoursesModel;

  UserModel({
    this.name,
    this.email,
    this.password,
    this.passwordConfirmation,
    this.token,
    this.role,
    this.uid,
    this.emailVerifiedAt,
    this.teacherInfo,
    this.totalCoursesCount,
    this.totalSubscriptionsCount,
    this.teacherCoursesModel,
    this.id,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);

}