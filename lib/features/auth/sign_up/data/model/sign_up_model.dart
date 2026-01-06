import 'dart:convert';

class SignUpModel {
  bool? success;
  int? status;
  String? message;
  Data? data;

  SignUpModel({this.success, this.status, this.message, this.data});

  factory SignUpModel.fromRawJson(String str) =>
      SignUpModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory SignUpModel.fromJson(Map<String, dynamic> json) => SignUpModel(
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
  String? role;

  Data({this.token, this.role});

  factory Data.fromRawJson(String str) => Data.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Data.fromJson(Map<String, dynamic> json) =>
      Data(token: json["token"], role: json["role"]);

  Map<String, dynamic> toJson() => {"token": token, "role": role};
}
