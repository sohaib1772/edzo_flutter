import 'package:edzo/models/code_model.dart';
import 'package:edzo/models/teacher_info_model.dart';
import 'package:json_annotation/json_annotation.dart';
part 'course_model.g.dart';

@JsonSerializable()
class CoursesResponseModel{
  List<CourseModel>? data;
  CoursesResponseModel({this.data});
  factory CoursesResponseModel.fromJson(Map<String, dynamic> json) =>
      _$CoursesResponseModelFromJson(json);
}
@JsonSerializable()
class CourseModel {
  int? id;
  String? title;
  String? description;
  String? image;
  int? price;
  String? createdAt;
  @JsonKey(name: "user_id")
  int? teacherId;
  @JsonKey(name: "is_subscribe")
  bool isSubscribed;
  @JsonKey(name: "teacher_name")
  String? teacherName;
  @JsonKey(name: "teacher_image")
  String? teacherImage;
  @JsonKey(name: "subscribers_count")
  int? subscribersCount;

  List<CodeModel>? codes;

  @JsonKey(name: "teacher_info")
  TeacherInfoModel? teacherInfo;


  CourseModel(
      {this.id,
      this.title,
      this.description,
      this.image,
      this.price,
      this.createdAt,
      this.teacherId,
      required  this.isSubscribed
      ,this.teacherName,
      this.teacherImage,
      this.subscribersCount,
      this.codes
      
      });

      

  factory CourseModel.fromJson(Map<String, dynamic> json) =>
      _$CourseModelFromJson(json);

  Map<String, dynamic> toJson() => _$CourseModelToJson(this);

}