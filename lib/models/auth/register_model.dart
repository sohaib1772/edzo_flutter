import 'package:json_annotation/json_annotation.dart';
part 'register_model.g.dart';

@JsonSerializable()
class RegisterModel {
  @JsonKey(includeIfNull: false)
  final String? email;

  @JsonKey(includeIfNull: false)
  final String? phone;

  final String? password;
  @JsonKey(name: "password_confirmation")
  final String? passwordConfirmation;
  final String? name;
  final String? uid;
  RegisterModel({
    this.email,
    this.phone,
    this.password,
    this.name,
    this.passwordConfirmation,
    this.uid,
  });
  factory RegisterModel.fromJson(Map<String, dynamic> json) =>
      _$RegisterModelFromJson(json);
  Map<String, dynamic> toJson() => _$RegisterModelToJson(this);
}
