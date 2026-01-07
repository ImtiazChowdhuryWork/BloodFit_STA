import 'dart:convert';

class VerifyOtpModel {
  bool? success;
  int? status;
  String? message;
  Data? data;

  VerifyOtpModel({this.success, this.status, this.message, this.data});

  factory VerifyOtpModel.fromRawJson(String str) =>
      VerifyOtpModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory VerifyOtpModel.fromJson(Map<String, dynamic> json) => VerifyOtpModel(
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
  String? name;
  String? token;
  String? role;

  Data({this.name, this.token, this.role});

  factory Data.fromRawJson(String str) => Data.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Data.fromJson(Map<String, dynamic> json) =>
      Data(name: json["name"], token: json["token"], role: json["role"]);

  Map<String, dynamic> toJson() => {"name": name, "token": token, "role": role};
}
