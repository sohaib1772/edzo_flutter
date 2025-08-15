

import 'package:json_annotation/json_annotation.dart';

part 'email_verification_model.g.dart';
@JsonSerializable()
class EmailVerificationModel {

  @JsonKey(name: 'email')
  String? email;
  @JsonKey(name: 'code')
  String? code;

  EmailVerificationModel({this.email, this.code});
  factory EmailVerificationModel.fromJson(Map<String, dynamic> json) => _$EmailVerificationModelFromJson(json);
  Map<String, dynamic> toJson() => _$EmailVerificationModelToJson(this);

}