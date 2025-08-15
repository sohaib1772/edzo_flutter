// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'error_handler.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ErrorHandler _$ErrorHandlerFromJson(Map<String, dynamic> json) =>
    ErrorHandler(
        message: json['message'] as String?,
        errors: (json['errors'] as Map<String, dynamic>?)?.map(
          (k, e) => MapEntry(
            k,
            (e as List<dynamic>).map((e) => e as String).toList(),
          ),
        ),
      )
      ..errorsList = (json['errorsList'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList();

Map<String, dynamic> _$ErrorHandlerToJson(ErrorHandler instance) =>
    <String, dynamic>{
      'message': instance.message,
      'errors': instance.errors,
      'errorsList': instance.errorsList,
    };
