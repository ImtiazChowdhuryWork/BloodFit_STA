import 'dart:convert';

class SignInModel {
  bool? success;
  int? status;
  String? message;
  Data? data;

  SignInModel({this.success, this.status, this.message, this.data});

  factory SignInModel.fromRawJson(String str) =>
      SignInModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory SignInModel.fromJson(Map<String, dynamic> json) => SignInModel(
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
  User? user;
  String? token;

  Data({this.user, this.token});

  factory Data.fromRawJson(String str) => Data.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    user: json["user"] == null ? null : User.fromJson(json["user"]),
    token: json["token"],
  );

  Map<String, dynamic> toJson() => {"user": user?.toJson(), "token": token};
}

class User {
  String? id;
  String? name;
  String? email;
  String? role;

  User({this.id, this.name, this.email, this.role});

  factory User.fromRawJson(String str) => User.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["_id"],
    name: json["name"],
    email: json["email"],
    role: json["role"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "name": name,
    "email": email,
    "role": role,
  };
}
