import 'dart:convert';

class ForgotPasswordModel {
  bool? success;
  int? status;
  String? message;
  Data? data;

  ForgotPasswordModel({this.success, this.status, this.message, this.data});

  factory ForgotPasswordModel.fromRawJson(String str) =>
      ForgotPasswordModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ForgotPasswordModel.fromJson(Map<String, dynamic> json) =>
      ForgotPasswordModel(
        success: json["success"],
        status: json["status"],
        message: json["message"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
    "success": success,
    "status": status,
    "message": message,
    "data": data?.toJson(),
  };
}

class Data {
  String? token;

  Data({this.token});

  factory Data.fromRawJson(String str) => Data.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Data.fromJson(Map<String, dynamic> json) =>
      Data(token: json["token"]);

  Map<String, dynamic> toJson() => {"token": token};
}
