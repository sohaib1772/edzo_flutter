import 'package:json_annotation/json_annotation.dart';

part 'error_handler.g.dart';

@JsonSerializable()
class ErrorHandler {
  String? message;
  Map<String, List<String>>? errors;
  List<String>? errorsList;
  ErrorHandler({this.message, this.errors});

  factory ErrorHandler.fromJson(Map<String, dynamic>? json) =>
      _$ErrorHandlerFromJson(json ?? {});

  Map<String, dynamic> toJson() => _$ErrorHandlerToJson(this);

  String getErrorsList() {
   List<String> errorsList = [];
    errors?.forEach((key, value) {
      errorsList.addAll(value);
    });
    String? _message = errorsList.join("\n");

    return errorsList.isEmpty ? message ?? "" : _message;
  }

}