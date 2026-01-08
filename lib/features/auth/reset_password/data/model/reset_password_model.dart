import 'dart:convert';

class ResetPasswordModel {
  bool? success;
  int? status;
  String? message;
  dynamic data;

  ResetPasswordModel({this.success, this.status, this.message, this.data});

  factory ResetPasswordModel.fromRawJson(String str) =>
      ResetPasswordModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ResetPasswordModel.fromJson(Map<String, dynamic> json) =>
      ResetPasswordModel(
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
