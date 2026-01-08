import 'dart:convert';

class ChangePasswordModel {
  bool? success;
  int? status;
  String? message;
  dynamic data;

  ChangePasswordModel({this.success, this.status, this.message, this.data});

  factory ChangePasswordModel.fromRawJson(String str) =>
      ChangePasswordModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ChangePasswordModel.fromJson(Map<String, dynamic> json) =>
      ChangePasswordModel(
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
