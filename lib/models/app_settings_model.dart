
import 'package:json_annotation/json_annotation.dart';

part 'app_settings_model.g.dart';

@JsonSerializable()
class AppSettingsModel {
  String ? version;

  AppSettingsModel({this.version});

  factory AppSettingsModel.fromJson(Map<String, dynamic> json) => _$AppSettingsModelFromJson(json);
}