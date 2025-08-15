// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'email_verification_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EmailVerificationModel _$EmailVerificationModelFromJson(
  Map<String, dynamic> json,
) => EmailVerificationModel(
  email: json['email'] as String?,
  code: json['code'] as String?,
);

Map<String, dynamic> _$EmailVerificationModelToJson(
  EmailVerificationModel instance,
) => <String, dynamic>{'email': instance.email, 'code': instance.code};
