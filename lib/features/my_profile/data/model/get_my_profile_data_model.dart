import 'dart:convert';

class GetMyProfileDataModel {
  bool? success;
  int? status;
  String? message;
  Data? data;

  GetMyProfileDataModel({this.success, this.status, this.message, this.data});

  factory GetMyProfileDataModel.fromRawJson(String str) =>
      GetMyProfileDataModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GetMyProfileDataModel.fromJson(Map<String, dynamic> json) =>
      GetMyProfileDataModel(
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
  String? id;
  String? firstName;
  String? lastName;
  String? email;
  String? contactNumber;
  String? image;
  String? role;

  Data({
    this.id,
    this.firstName,
    this.lastName,
    this.email,
    this.contactNumber,
    this.image,
    this.role,
  });

  factory Data.fromRawJson(String str) => Data.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    id: json["_id"],
    firstName: json["firstName"],
    lastName: json["lastName"],
    email: json["email"],
    contactNumber: json["contactNumber"],
    image: json["image"],
    role: json["role"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "firstName": firstName,
    "lastName": lastName,
    "email": email,
    "contactNumber": contactNumber,
    "image": image,
    "role": role,
  };
}
