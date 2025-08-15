
import 'package:json_annotation/json_annotation.dart';
part 'register_model.g.dart';
@JsonSerializable()
class RegisterModel {
  final String? email;
  final String? password;
  @JsonKey(name: "password_confirmation")
  final String? passwordConfirmation;
  final String? name;
final String? uid;
  RegisterModel({this.email, this.password, this.name, this.passwordConfirmation, this.uid});
  factory RegisterModel.fromJson(Map<String, dynamic> json) => _$RegisterModelFromJson(json);
  Map<String, dynamic> toJson() => _$RegisterModelToJson(this);
}

