
import 'package:json_annotation/json_annotation.dart';
part 'teacher_info_model.g.dart';
@JsonSerializable()
class TeacherInfoModel {
  String? bio;
  String? image;
  @JsonKey(name: "telegram_url")
  String? telegramUrl;
  TeacherInfoModel({this.bio, this.image, this.telegramUrl});
  factory TeacherInfoModel.fromJson(Map<String, dynamic> json) => _$TeacherInfoModelFromJson(json);
}