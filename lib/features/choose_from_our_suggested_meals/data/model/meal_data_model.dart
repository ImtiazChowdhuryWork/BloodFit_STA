import 'dart:convert';

/// Model class for passing meal data from AI suggested meals to details screen
/// This avoids the need for API calls when viewing meal details
class MealDataModel {
  final String mealName;
  final String mealType;
  final int totalCalories;
  final String description;
  final List<MealIngredientData> ingredients;
  final MealMacronutrientsData macronutrients;
  final int numberOfServings;
  final String image;
  final String? category;
  final String? subCategory;
  final String? mealId; // Added for meal selection tracking

  MealDataModel({
    required this.mealName,
    required this.mealType,
    required this.totalCalories,
    this.description = '',
    this.ingredients = const [],
    required this.macronutrients,
    this.numberOfServings = 1,
    this.image = '',
    this.category,
    this.subCategory,
    this.mealId,
  });

  factory MealDataModel.fromRawJson(String str) =>
      MealDataModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory MealDataModel.fromJson(Map<String, dynamic> json) => MealDataModel(
        mealName: json["mealName"] ?? '',
        mealType: json["mealType"] ?? '',
        totalCalories: json["totalCalories"] ?? 0,
        description: json["description"] ?? '',
        ingredients: json["ingredients"] == null
            ? []
            : List<MealIngredientData>.from(
                json["ingredients"]!.map((x) => MealIngredientData.fromJson(x))),
        macronutrients: json["macronutrients"] == null
            ? MealMacronutrientsData()
            : MealMacronutrientsData.fromJson(json["macronutrients"]),
        numberOfServings: json["numberOfServings"] ?? 1,
        image: json["image"] ?? '',
        category: json["category"],
        subCategory: json["subCategory"],
        mealId: json["mealId"],
      );

  Map<String, dynamic> toJson() => {
        "mealName": mealName,
        "mealType": mealType,
        "totalCalories": totalCalories,
        "description": description,
        "ingredients":
            ingredients.map((x) => x.toJson()).toList(),
        "macronutrients": macronutrients.toJson(),
        "numberOfServings": numberOfServings,
        "image": image,
        "category": category,
        "subCategory": subCategory,
        "mealId": mealId,
      };
}

class MealIngredientData {
  final String name;
  final String quantity;
  final String icon;

  MealIngredientData({
    required this.name,
    required this.quantity,
    required this.icon,
  });

  factory MealIngredientData.fromRawJson(String str) =>
      MealIngredientData.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory MealIngredientData.fromJson(Map<String, dynamic> json) =>
      MealIngredientData(
        name: json["name"] ?? '',
        quantity: json["quantity"] ?? '',
        icon: json["icon"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "quantity": quantity,
        "icon": icon,
      };
}

class MealMacronutrientsData {
  final int carbohydrates;
  final int protein;
  final int fat;

  MealMacronutrientsData({
    this.carbohydrates = 0,
    this.protein = 0,
    this.fat = 0,
  });

  factory MealMacronutrientsData.fromRawJson(String str) =>
      MealMacronutrientsData.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory MealMacronutrientsData.fromJson(Map<String, dynamic> json) =>
      MealMacronutrientsData(
        carbohydrates: json["carbohydrates"] ?? 0,
        protein: json["protein"] ?? 0,
        fat: json["fat"] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        "carbohydrates": carbohydrates,
        "protein": protein,
        "fat": fat,
      };
}
