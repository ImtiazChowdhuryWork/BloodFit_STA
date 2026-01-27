import 'dart:convert';

class YourDailyCaloriesIntakeModel {
  bool? success;
  int? status;
  String? message;
  Data? data;

  YourDailyCaloriesIntakeModel({
    this.success,
    this.status,
    this.message,
    this.data,
  });

  factory YourDailyCaloriesIntakeModel.fromRawJson(String str) =>
      YourDailyCaloriesIntakeModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory YourDailyCaloriesIntakeModel.fromJson(Map<String, dynamic> json) =>
      YourDailyCaloriesIntakeModel(
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
  int? totalDailyCalories;
  TotalDailyMacronutrients? totalDailyMacronutrients;
  String? userId;
  String? bloodType;
  String? dietType;
  DateTime? calculationTimestamp;

  Data({
    this.totalDailyCalories,
    this.totalDailyMacronutrients,
    this.userId,
    this.bloodType,
    this.dietType,
    this.calculationTimestamp,
  });

  factory Data.fromRawJson(String str) => Data.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    totalDailyCalories: json["total_daily_calories"],
    totalDailyMacronutrients: json["total_daily_macronutrients"] == null
        ? null
        : TotalDailyMacronutrients.fromJson(json["total_daily_macronutrients"]),
    userId: json["user_id"],
    bloodType: json["blood_type"],
    dietType: json["diet_type"],
    calculationTimestamp: json["calculation_timestamp"] == null
        ? null
        : DateTime.parse(json["calculation_timestamp"]),
  );

  Map<String, dynamic> toJson() => {
    "total_daily_calories": totalDailyCalories,
    "total_daily_macronutrients": totalDailyMacronutrients?.toJson(),
    "user_id": userId,
    "blood_type": bloodType,
    "diet_type": dietType,
    "calculation_timestamp": calculationTimestamp?.toIso8601String(),
  };
}

class TotalDailyMacronutrients {
  int? carbohydrates;
  int? protein;
  int? fat;

  TotalDailyMacronutrients({this.carbohydrates, this.protein, this.fat});

  factory TotalDailyMacronutrients.fromRawJson(String str) =>
      TotalDailyMacronutrients.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory TotalDailyMacronutrients.fromJson(Map<String, dynamic> json) =>
      TotalDailyMacronutrients(
        carbohydrates: json["carbohydrates"],
        protein: json["protein"],
        fat: json["fat"],
      );

  Map<String, dynamic> toJson() => {
    "carbohydrates": carbohydrates,
    "protein": protein,
    "fat": fat,
  };
}
