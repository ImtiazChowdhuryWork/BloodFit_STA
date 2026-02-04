import 'dart:convert';

class PreviouslySelectedMealsModel {
  bool? success;
  int? status;
  String? message;
  Data? data;

  PreviouslySelectedMealsModel({
    this.success,
    this.status,
    this.message,
    this.data,
  });

  factory PreviouslySelectedMealsModel.fromRawJson(String str) =>
      PreviouslySelectedMealsModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PreviouslySelectedMealsModel.fromJson(Map<String, dynamic> json) =>
      PreviouslySelectedMealsModel(
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
  Breakfast? breakfast;
  Breakfast? lunch;
  Breakfast? dinner;

  Data({this.breakfast, this.lunch, this.dinner});

  factory Data.fromRawJson(String str) => Data.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    breakfast: json["breakfast"] == null
        ? null
        : Breakfast.fromJson(json["breakfast"]),
    lunch: json["lunch"] == null ? null : Breakfast.fromJson(json["lunch"]),
    dinner: json["dinner"] == null ? null : Breakfast.fromJson(json["dinner"]),
  );

  Map<String, dynamic> toJson() => {
    "breakfast": breakfast?.toJson(),
    "lunch": lunch?.toJson(),
    "dinner": dinner?.toJson(),
  };
}

class Breakfast {
  String? id;
  String? userId;
  String? mealType;
  int? kcal;
  String? description;
  List<CaloryCount>? caloryCount;
  List<String>? ingredients;
  String? mealGroupId;
  String? image;
  DateTime? date;
  String? status;
  int? v;

  Breakfast({
    this.id,
    this.userId,
    this.mealType,
    this.kcal,
    this.description,
    this.caloryCount,
    this.ingredients,
    this.mealGroupId,
    this.image,
    this.date,
    this.status,
    this.v,
  });

  factory Breakfast.fromRawJson(String str) =>
      Breakfast.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Breakfast.fromJson(Map<String, dynamic> json) => Breakfast(
    id: json["_id"],
    userId: json["userId"],
    mealType: json["mealType"],
    kcal: json["kcal"],
    description: json["description"],
    caloryCount: json["caloryCount"] == null
        ? []
        : List<CaloryCount>.from(
            json["caloryCount"]!.map((x) => CaloryCount.fromJson(x)),
          ),
    ingredients: json["ingredients"] == null
        ? []
        : List<String>.from(json["ingredients"]!.map((x) => x)),
    mealGroupId: json["mealGroupId"],
    image: json["image"],
    date: json["date"] == null ? null : DateTime.parse(json["date"]),
    status: json["status"],
    v: json["__v"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "userId": userId,
    "mealType": mealType,
    "kcal": kcal,
    "description": description,
    "caloryCount": caloryCount == null
        ? []
        : List<dynamic>.from(caloryCount!.map((x) => x.toJson())),
    "ingredients": ingredients == null
        ? []
        : List<dynamic>.from(ingredients!.map((x) => x)),
    "mealGroupId": mealGroupId,
    "image": image,
    "date": date?.toIso8601String(),
    "status": status,
    "__v": v,
  };
}

class CaloryCount {
  String? label;
  int? kcal;
  String? id;

  CaloryCount({this.label, this.kcal, this.id});

  factory CaloryCount.fromRawJson(String str) =>
      CaloryCount.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CaloryCount.fromJson(Map<String, dynamic> json) =>
      CaloryCount(label: json["label"], kcal: json["kcal"], id: json["_id"]);

  Map<String, dynamic> toJson() => {"label": label, "kcal": kcal, "_id": id};
}
