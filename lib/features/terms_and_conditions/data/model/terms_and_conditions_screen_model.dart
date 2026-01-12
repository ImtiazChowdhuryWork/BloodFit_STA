import 'dart:convert';

class TermsAndConditionsScreenModel {
  bool? success;
  int? status;
  String? message;
  Data? data;

  TermsAndConditionsScreenModel({
    this.success,
    this.status,
    this.message,
    this.data,
  });

  factory TermsAndConditionsScreenModel.fromRawJson(String str) =>
      TermsAndConditionsScreenModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory TermsAndConditionsScreenModel.fromJson(Map<String, dynamic> json) =>
      TermsAndConditionsScreenModel(
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
  String? description;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;

  Data({this.id, this.description, this.createdAt, this.updatedAt, this.v});

  factory Data.fromRawJson(String str) => Data.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    id: json["_id"],
    description: json["description"],
    createdAt: json["createdAt"] == null
        ? null
        : DateTime.parse(json["createdAt"]),
    updatedAt: json["updatedAt"] == null
        ? null
        : DateTime.parse(json["updatedAt"]),
    v: json["__v"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "description": description,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "__v": v,
  };
}
