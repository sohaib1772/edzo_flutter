
import 'package:json_annotation/json_annotation.dart';
part 'teacher_info_model.g.dart';
@JsonSerializable()
class TeacherInfoModel {
  String? bio;
  String? image;
  TeacherInfoModel({this.bio, this.image});
  factory TeacherInfoModel.fromJson(Map<String, dynamic> json) => _$TeacherInfoModelFromJson(json);
}