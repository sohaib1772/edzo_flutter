// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'monthly_subscribers_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MonthlySubscribersModel _$MonthlySubscribersModelFromJson(
  Map<String, dynamic> json,
) => MonthlySubscribersModel(
  date: json['month'] as String?,
  count: (json['total_subscribers'] as num?)?.toInt(),
);

Map<String, dynamic> _$MonthlySubscribersModelToJson(
  MonthlySubscribersModel instance,
) => <String, dynamic>{
  'month': instance.date,
  'total_subscribers': instance.count,
};
