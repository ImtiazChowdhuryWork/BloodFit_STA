import 'dart:convert';
import 'ai_suggested_meals_model.dart';

class AiSuggestedMealsModel {
  bool? success;
  int? status;
  String? message;
  Data? data;

  AiSuggestedMealsModel({
    this.success,
    this.status,
    this.message,
    this.data,
  });

  factory AiSuggestedMealsModel.fromJson(Map<String, dynamic> json) =>
      AiSuggestedMealsModel(
        success: json["success"],
        status: json["status"],
        message: json["message"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );
}

class Data {
  Options? breakfastOptions;
  Options? lunchOptions;
  Options? dinnerOptions;

  Data({
    this.breakfastOptions,
    this.lunchOptions,
    this.dinnerOptions,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        breakfastOptions: json["breakfast_options"] == null
            ? null
            : Options.fromJson(json["breakfast_options"]),
        lunchOptions: json["lunch_options"] == null
            ? null
            : Options.fromJson(json["lunch_options"]),
        dinnerOptions: json["dinner_options"] == null
            ? null
            : Options.fromJson(json["dinner_options"]),
      );
}

class Options {
  List<HealthyComforting>? proteinPacked;
  List<HealthyComforting>? lightFresh;
  List<HealthyComforting>? healthyComforting;

  Options({
    this.proteinPacked,
    this.lightFresh,
    this.healthyComforting,
  });

  factory Options.fromJson(Map<String, dynamic> json) => Options(
        proteinPacked: json["protein_packed"] == null
            ? []
            : List<HealthyComforting>.from(
                json["protein_packed"].map(
                  (x) => HealthyComforting.fromJson(x),
                ),
              ),
        lightFresh: json["light_fresh"] == null
            ? []
            : List<HealthyComforting>.from(
                json["light_fresh"].map(
                  (x) => HealthyComforting.fromJson(x),
                ),
              ),
        healthyComforting: json["healthy_comforting"] == null
            ? []
            : List<HealthyComforting>.from(
                json["healthy_comforting"].map(
                  (x) => HealthyComforting.fromJson(x),
                ),
              ),
      );
}

class HealthyComforting {
  String? mealName;
  int? totalCalories;
  Macronutrients? macronutrients;
  String? description;
  List<Ingredient>? ingredients;

  HealthyComforting({
    this.mealName,
    this.totalCalories,
    this.macronutrients,
    this.description,
    this.ingredients,
  });

  factory HealthyComforting.fromJson(Map<String, dynamic> json) =>
      HealthyComforting(
        mealName: json["meal_name"],
        totalCalories: json["total_calories"],
        macronutrients: json["macronutrients"] == null
            ? null
            : Macronutrients.fromJson(json["macronutrients"]),
        description: json["description"],
        ingredients: json["ingredients"] == null
            ? []
            : List<Ingredient>.from(
                json["ingredients"].map(
                  (x) => Ingredient.fromJson(x),
                ),
              ),
      );
}

class Ingredient {
  String? name;

  Ingredient({this.name});

  factory Ingredient.fromJson(Map<String, dynamic> json) =>
      Ingredient(name: json["name"]);
}

class Macronutrients {
  int? carbohydrates;
  int? protein;
  int? fat;

  Macronutrients({
    this.carbohydrates,
    this.protein,
    this.fat,
  });

  factory Macronutrients.fromJson(Map<String, dynamic> json) =>
      Macronutrients(
        carbohydrates: json["carbohydrates"],
        protein: json["protein"],
        fat: json["fat"],
      );
}




class RecentChosenMealsModel {
  bool? success;
  int? status;
  String? message;
  List<Datum>? data;

  RecentChosenMealsModel({
    this.success,
    this.status,
    this.message,
    this.data,
  });

  factory RecentChosenMealsModel.fromJson(Map<String, dynamic> json) =>
      RecentChosenMealsModel(
        success: json["success"],
        status: json["status"],
        message: json["message"],
        data: json["data"] == null
            ? []
            : List<Datum>.from(
                json["data"].map((x) => Datum.fromJson(x))),
      );
}

class Datum {
  String? mealName;
  String? mealType;
  int? kcal;
  String? description;
  List<String>? ingredients;
  String? status;

  Datum({
    this.mealName,
    this.mealType,
    this.kcal,
    this.description,
    this.ingredients,
    this.status,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        mealName: json["mealName"],
        mealType: json["mealType"],
        kcal: json["kcal"],
        description: json["description"],
        ingredients: json["ingredients"] == null
            ? []
            : List<String>.from(json["ingredients"]),
        status: json["status"],
      );

  /// 🔥 AI → Recent Meal adapter (THE MISSING PIECE)
  factory Datum.fromHealthyComforting(
    HealthyComforting meal, {
    required String mealType,
  }) {
    return Datum(
      mealName: meal.mealName,
      mealType: mealType,
      kcal: meal.totalCalories,
      description: meal.description,
      ingredients:
          meal.ingredients?.map((e) => e.name ?? '').toList(),
      status: "ai_suggested",
    );
  }
}

