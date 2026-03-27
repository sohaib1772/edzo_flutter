import 'package:edzo/models/user_model.dart';
import 'package:json_annotation/json_annotation.dart';
part 'code_model.g.dart';

@JsonSerializable()
class CodesResponseModel {
  List<CodeModel>? data;
  CodesResponseModel(this.data);
  factory CodesResponseModel.fromJson(Map<String, dynamic> json) =>
      _$CodesResponseModelFromJson(json);
}

@JsonSerializable()
class SingleCodesResponseModel {
  CodeModel? data;
  SingleCodesResponseModel(this.data);
  factory SingleCodesResponseModel.fromJson(Map<String, dynamic> json) =>
      _$SingleCodesResponseModelFromJson(json);
}

@JsonSerializable()
class CodeModel {
  int? id;
  String? code;
  @JsonKey(name: "course_id")
  int? courseId;
  int? status;
  @JsonKey(name: "user_id")
  int? userId;
  UserModel? user;
  @JsonKey(name: "created_at")
  String? createdAt;
  @JsonKey(name: "updated_at")
  String? updatedAt;

  CodeModel({
    this.id,
    this.code,
    this.courseId,
    this.status,
    this.userId,
    this.user,
    this.createdAt,
    this.updatedAt,
  });

  factory CodeModel.fromJson(Map<String, dynamic> json) =>
      _$CodeModelFromJson(json);

  Map<String, dynamic> toJson() => _$CodeModelToJson(this);
}
