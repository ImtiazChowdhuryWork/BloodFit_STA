import 'dart:convert';

class GenerateMealPlanModel {
  bool? success;
  int? status;
  String? message;
  Data? data;

  GenerateMealPlanModel({this.success, this.status, this.message, this.data});

  factory GenerateMealPlanModel.fromRawJson(String str) =>
      GenerateMealPlanModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GenerateMealPlanModel.fromJson(Map<String, dynamic> json) =>
      GenerateMealPlanModel(
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
  String? userId;
  String? bloodGroup;
  String? gender;
  int? age;
  String? country;
  int? weight;
  double? height;
  String? goal;
  int? desiredWeight;
  String? diet;
  List<String>? foodAllergies;
  List<String>? foodDislikes;
  int? v;
  bool? healthDetails;

  Data({
    this.id,
    this.userId,
    this.bloodGroup,
    this.gender,
    this.age,
    this.country,
    this.weight,
    this.height,
    this.goal,
    this.desiredWeight,
    this.diet,
    this.foodAllergies,
    this.foodDislikes,
    this.v,
    this.healthDetails,
  });

  factory Data.fromRawJson(String str) => Data.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    id: json["_id"],
    userId: json["userId"],
    bloodGroup: json["bloodGroup"],
    gender: json["gender"],
    age: json["age"],
    country: json["country"],
    weight: json["weight"],
    height: json["height"]?.toDouble(),
    goal: json["goal"],
    desiredWeight: json["desiredWeight"],
    diet: json["diet"],
    foodAllergies: json["foodAllergies"] == null
        ? []
        : List<String>.from(json["foodAllergies"]!.map((x) => x)),
    foodDislikes: json["foodDislikes"] == null
        ? []
        : List<String>.from(json["foodDislikes"]!.map((x) => x)),
    v: json["__v"],
    healthDetails: json["healthDetails"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "userId": userId,
    "bloodGroup": bloodGroup,
    "gender": gender,
    "age": age,
    "country": country,
    "weight": weight,
    "height": height,
    "goal": goal,
    "desiredWeight": desiredWeight,
    "diet": diet,
    "foodAllergies": foodAllergies == null
        ? []
        : List<dynamic>.from(foodAllergies!.map((x) => x)),
    "foodDislikes": foodDislikes == null
        ? []
        : List<dynamic>.from(foodDislikes!.map((x) => x)),
    "__v": v,
    "healthDetails": healthDetails,
  };
}
