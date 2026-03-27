
import 'package:json_annotation/json_annotation.dart';
part 'monthly_subscribers_model.g.dart';
@JsonSerializable()
class MonthlySubscribersModel {
  @JsonKey(name: "month")
  String? date;
  @JsonKey(name: "count")
  int? count;

  MonthlySubscribersModel({this.date, this.count});

  factory MonthlySubscribersModel.fromJson(Map<String, dynamic> json) =>
      _$MonthlySubscribersModelFromJson(json);

  Map<String, dynamic> toJson() => _$MonthlySubscribersModelToJson(this);
  
}