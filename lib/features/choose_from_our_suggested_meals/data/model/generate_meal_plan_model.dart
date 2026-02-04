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
  List<Option>? breakfastOptions;
  List<Option>? lunchOptions;
  List<Option>? dinnerOptions;
  String? userId;
  String? bloodType;
  String? dietType;
  int? totalDailyCalories;
  Macronutrients? totalDailyMacronutrients;
  String? breakfastImage;
  String? lunchImage;
  String? dinnerImage;

  Data({
    this.breakfastOptions,
    this.lunchOptions,
    this.dinnerOptions,
    this.userId,
    this.bloodType,
    this.dietType,
    this.totalDailyCalories,
    this.totalDailyMacronutrients,
    this.breakfastImage,
    this.lunchImage,
    this.dinnerImage,
  });

  factory Data.fromRawJson(String str) => Data.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    breakfastOptions: json["breakfast_options"] == null
        ? []
        : List<Option>.from(
            json["breakfast_options"]!.map((x) => Option.fromJson(x)),
          ),
    lunchOptions: json["lunch_options"] == null
        ? []
        : List<Option>.from(
            json["lunch_options"]!.map((x) => Option.fromJson(x)),
          ),
    dinnerOptions: json["dinner_options"] == null
        ? []
        : List<Option>.from(
            json["dinner_options"]!.map((x) => Option.fromJson(x)),
          ),
    userId: json["user_id"],
    bloodType: json["blood_type"],
    dietType: json["diet_type"],
    totalDailyCalories: json["total_daily_calories"],
    totalDailyMacronutrients: json["total_daily_macronutrients"] == null
        ? null
        : Macronutrients.fromJson(json["total_daily_macronutrients"]),
    breakfastImage: json["breakfast_image"],
    lunchImage: json["lunch_image"],
    dinnerImage: json["dinner_image"],
  );

  Map<String, dynamic> toJson() => {
    "breakfast_options": breakfastOptions == null
        ? []
        : List<dynamic>.from(breakfastOptions!.map((x) => x.toJson())),
    "lunch_options": lunchOptions == null
        ? []
        : List<dynamic>.from(lunchOptions!.map((x) => x.toJson())),
    "dinner_options": dinnerOptions == null
        ? []
        : List<dynamic>.from(dinnerOptions!.map((x) => x.toJson())),
    "user_id": userId,
    "blood_type": bloodType,
    "diet_type": dietType,
    "total_daily_calories": totalDailyCalories,
    "total_daily_macronutrients": totalDailyMacronutrients?.toJson(),
    "breakfast_image": breakfastImage,
    "lunch_image": lunchImage,
    "dinner_image": dinnerImage,
  };
}

class Option {
  String? mealName;
  String? category;
  int? totalCalories;
  Macronutrients? macronutrients;
  String? description;
  List<Ingredient>? ingredients;
  int? numberOfServings;

  Option({
    this.mealName,
    this.category,
    this.totalCalories,
    this.macronutrients,
    this.description,
    this.ingredients,
    this.numberOfServings,
  });

  factory Option.fromRawJson(String str) => Option.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Option.fromJson(Map<String, dynamic> json) => Option(
    mealName: json["meal_name"],
    category: json["category"],
    totalCalories: json["total_calories"],
    macronutrients: json["macronutrients"] == null
        ? null
        : Macronutrients.fromJson(json["macronutrients"]),
    description: json["description"],
    ingredients: json["ingredients"] == null
        ? []
        : List<Ingredient>.from(
            json["ingredients"]!.map((x) => Ingredient.fromJson(x)),
          ),
    numberOfServings: json["number_of_servings"],
  );

  Map<String, dynamic> toJson() => {
    "meal_name": mealName,
    "category": category,
    "total_calories": totalCalories,
    "macronutrients": macronutrients?.toJson(),
    "description": description,
    "ingredients": ingredients == null
        ? []
        : List<dynamic>.from(ingredients!.map((x) => x.toJson())),
    "number_of_servings": numberOfServings,
  };
}

class Ingredient {
  String? name;
  String? quantity;
  String? icon;

  Ingredient({this.name, this.quantity, this.icon});

  factory Ingredient.fromRawJson(String str) =>
      Ingredient.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Ingredient.fromJson(Map<String, dynamic> json) => Ingredient(
    name: json["name"],
    quantity: json["quantity"],
    icon: json["icon"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "quantity": quantity,
    "icon": icon,
  };
}

class Macronutrients {
  int? carbohydrates;
  int? protein;
  int? fat;

  Macronutrients({this.carbohydrates, this.protein, this.fat});

  factory Macronutrients.fromRawJson(String str) =>
      Macronutrients.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Macronutrients.fromJson(Map<String, dynamic> json) => Macronutrients(
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
