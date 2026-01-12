import 'dart:convert';

class ReportAProblemModel {
  bool? success;
  int? status;
  String? message;
  dynamic data;

  ReportAProblemModel({this.success, this.status, this.message, this.data});

  factory ReportAProblemModel.fromRawJson(String str) =>
      ReportAProblemModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ReportAProblemModel.fromJson(Map<String, dynamic> json) =>
      ReportAProblemModel(
        success: json["success"],
        status: json["status"],
        message: json["message"],
        data: json["data"],
      );

  Map<String, dynamic> toJson() => {
    "success": success,
    "status": status,
    "message": message,
    "data": data,
  };
}
