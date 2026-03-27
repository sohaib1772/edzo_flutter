
import 'package:edzo/models/monthly_subscribers_model.dart';
import 'package:edzo/models/user_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'teachers_response_model.g.dart';

@JsonSerializable()
class TeachersResponseModel {
  List<TeachersInfoModel>? data;
  TeachersResponseModel({
     this.data,
  });

  factory TeachersResponseModel.fromJson(Map<String, dynamic> json) =>
      _$TeachersResponseModelFromJson(json);
      
}

@JsonSerializable()
class TeachersInfoModel {
  int? id;
  String? name;
  String? bio;
  String? image;
  @JsonKey(name: "courses_count")
  int? coursesCount;
  @JsonKey(name: "total_students_count")
  int? totalStudentsCount;
  // Backward compatibility
  UserModel? user;
  @JsonKey(name: "courses")
  List<TeacherCoursesModel>? courses;
  @JsonKey(name: "is_pin")
  bool? isPin;

  TeachersInfoModel({
    this.id,
    this.name,
    this.bio,
    this.image,
    this.coursesCount,
    this.totalStudentsCount,
    this.user,
    this.courses,
    this.isPin,
  });

  factory TeachersInfoModel.fromJson(Map<String, dynamic> json) =>
      _$TeachersInfoModelFromJson(json);

  Map<String, dynamic> toJson() => _$TeachersInfoModelToJson(this);
}

@JsonSerializable()
class TeacherCoursesModel{
  int? id;
  String? title;
  @JsonKey(name: "total_subscribers")
  int? totalSubscribers;
  @JsonKey(name: "monthly_stats")
  List<MonthlySubscribersModel>? monthlySubscribers;

  TeacherCoursesModel({
    this.id,
    this.title,
    this.totalSubscribers,
    this.monthlySubscribers,
  });
  

  factory TeacherCoursesModel.fromJson(Map<String, dynamic> json) =>
      _$TeacherCoursesModelFromJson(json);
}