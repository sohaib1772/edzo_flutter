
import 'package:Edzo/models/user_model.dart';
import 'package:json_annotation/json_annotation.dart';
part 'login_model.g.dart';
@JsonSerializable()
class LoginModel {
  String? email;
  
  String? emailVerifiedAt;
  String? password;
  String? uid;

  LoginModel({this.email, this.password, this.uid, this.emailVerifiedAt});

  factory LoginModel.fromJson(Map<String, dynamic> json) =>
      _$LoginModelFromJson(json);

  Map<String, dynamic> toJson() => _$LoginModelToJson(this);
}

@JsonSerializable()
class LoginResponseModel {
  String? token;
  UserModel? data;
  LoginResponseModel({this.token, this.data});
  factory LoginResponseModel.fromJson(Map<String, dynamic> json) =>
      _$LoginResponseModelFromJson(json);
  Map<String, dynamic> toJson() => _$LoginResponseModelToJson(this);
}