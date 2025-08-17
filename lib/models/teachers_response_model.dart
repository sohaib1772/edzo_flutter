
import 'package:Edzo/models/monthly_subscribers_model.dart';
import 'package:Edzo/models/user_model.dart';
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
  UserModel? user;

  

  TeachersInfoModel({
     this.user,
  });

  factory TeachersInfoModel.fromJson(Map<String, dynamic> json) =>
      _$TeachersInfoModelFromJson(json);

}

@JsonSerializable()
class TeacherCoursesModel{
  int? id;
  String? title;
  @JsonKey(name:"monthly_subscribers")
  List<MonthlySubscribersModel>? monthlySubscribers;

  TeacherCoursesModel(
    {
     this.id,
     this.title,
     this.monthlySubscribers,
  });
  

  factory TeacherCoursesModel.fromJson(Map<String, dynamic> json) =>
      _$TeacherCoursesModelFromJson(json);
}