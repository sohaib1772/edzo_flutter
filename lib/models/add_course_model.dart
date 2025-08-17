
import 'package:dio/dio.dart';
import 'package:Edzo/models/course_model.dart';
import 'package:json_annotation/json_annotation.dart';
part 'add_course_model.g.dart';



@JsonSerializable()
class AddCourseResponseModel{
  String? message;
  CourseModel? data;
  AddCourseResponseModel(this.message, this.data);
  factory AddCourseResponseModel.fromJson(Map<String, dynamic> json) => _$AddCourseResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$AddCourseResponseModelToJson(this);

}

class AddCourseModel {
  String title;
  String description ;
  int price;
  MultipartFile image;

  AddCourseModel({
    required this.title,
    required this.description,
    required this.price,
    required this.image
  }); 

}
class EditCourseModel {
  int id;
  String title;
  String description ;
  int price;
  MultipartFile image;

  EditCourseModel(
    {
      required this.id,
      required this.title,
      required this.description,
      required this.price,
      required this.image
    }
  ); 

}