import 'package:json_annotation/json_annotation.dart';
part 'reset_password_model.g.dart';

@JsonSerializable()
class ResetPasswordModel {
  @JsonKey(includeIfNull: false)
  String? email;
  @JsonKey(includeIfNull: false)
  String? phone;
  String? password;
  @JsonKey(name: "password_confirmation")
  String? passwordConfirmation;
  String? code;

  ResetPasswordModel({
    this.email,
    this.phone,
    this.password,
    this.passwordConfirmation,
    this.code,
  });

  factory ResetPasswordModel.fromJson(Map<String, dynamic> json) =>
      _$ResetPasswordModelFromJson(json);

  Map<String, dynamic> toJson() => _$ResetPasswordModelToJson(this);
}
