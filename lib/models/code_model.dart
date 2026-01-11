import 'package:json_annotation/json_annotation.dart';
part 'code_model.g.dart';

@JsonSerializable()
class CodesResponseModel {
  List<CodeModel>? data;
  CodesResponseModel(this.data);
  factory CodesResponseModel.fromJson(Map<String, dynamic> json) => _$CodesResponseModelFromJson(json);
}
@JsonSerializable()
class SingleCodesResponseModel {
  CodeModel? data;
  SingleCodesResponseModel(this.data);
  factory SingleCodesResponseModel.fromJson(Map<String, dynamic> json) => _$SingleCodesResponseModelFromJson(json);
}
@JsonSerializable() 
class CodeModel {
  String? code;
  CodeModel(this.code);
  factory CodeModel.fromJson(Map<String, dynamic> json) => _$CodeModelFromJson(json);

  Map<String, dynamic> toJson() => _$CodeModelToJson(this);

}