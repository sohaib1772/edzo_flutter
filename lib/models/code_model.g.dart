// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'code_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CodesResponseModel _$CodesResponseModelFromJson(Map<String, dynamic> json) =>
    CodesResponseModel(
      (json['data'] as List<dynamic>?)
          ?.map((e) => CodeModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$CodesResponseModelToJson(CodesResponseModel instance) =>
    <String, dynamic>{'data': instance.data};

CodeModel _$CodeModelFromJson(Map<String, dynamic> json) =>
    CodeModel(json['code'] as String?);

Map<String, dynamic> _$CodeModelToJson(CodeModel instance) => <String, dynamic>{
  'code': instance.code,
};
