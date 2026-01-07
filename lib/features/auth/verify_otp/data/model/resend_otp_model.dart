import 'dart:convert';

class ResendOtpModel {
  bool? success;
  int? status;
  String? message;
  String? data;

  ResendOtpModel({this.success, this.status, this.message, this.data});

  factory ResendOtpModel.fromRawJson(String str) =>
      ResendOtpModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ResendOtpModel.fromJson(Map<String, dynamic> json) => ResendOtpModel(
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
