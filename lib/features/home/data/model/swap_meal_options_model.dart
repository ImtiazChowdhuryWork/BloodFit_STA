import 'dart:convert';

class SwapMealOptionsModel {
    bool? success;
    int? status;
    String? message;
    Data? data;

    SwapMealOptionsModel({
        this.success,
        this.status,
        this.message,
        this.data,
    });

    factory SwapMealOptionsModel.fromRawJson(String str) => SwapMealOptionsModel.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory SwapMealOptionsModel.fromJson(Map<String, dynamic> json) => SwapMealOptionsModel(
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
    List<Alternative>? alternatives;
    String? originalCategory;
    String? originalSubCategory;
    int? targetCalories;

    Data({
        this.alternatives,
        this.originalCategory,
        this.originalSubCategory,
        this.targetCalories,
    });

    factory Data.fromRawJson(String str) => Data.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        alternatives: json["alternatives"] == null ? [] : List<Alternative>.from(json["alternatives"]!.map((x) => Alternative.fromJson(x))),
        originalCategory: json["original_category"],
        originalSubCategory: json["original_sub_category"],
        targetCalories: json["target_calories"],
    );

    Map<String, dynamic> toJson() => {
        "alternatives": alternatives == null ? [] : List<dynamic>.from(alternatives!.map((x) => x.toJson())),
        "original_category": originalCategory,
        "original_sub_category": originalSubCategory,
        "target_calories": targetCalories,
    };
}

class Alternative {
    String? mealName;
    String? category;
    String? subCategory;
    int? totalCalories;
    Macronutrients? macronutrients;
    String? description;
    List<Ingredient>? ingredients;
    int? numberOfServings;
    String? image;

    Alternative({
        this.mealName,
        this.category,
        this.subCategory,
        this.totalCalories,
        this.macronutrients,
        this.description,
        this.ingredients,
        this.numberOfServings,
        this.image,
    });

    factory Alternative.fromRawJson(String str) => Alternative.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Alternative.fromJson(Map<String, dynamic> json) => Alternative(
        mealName: json["meal_name"],
        category: json["category"],
        subCategory: json["sub_category"],
        totalCalories: json["total_calories"],
        macronutrients: json["macronutrients"] == null ? null : Macronutrients.fromJson(json["macronutrients"]),
        description: json["description"],
        ingredients: json["ingredients"] == null ? [] : List<Ingredient>.from(json["ingredients"]!.map((x) => Ingredient.fromJson(x))),
        numberOfServings: json["number_of_servings"],
        image: json["image"],
    );

    Map<String, dynamic> toJson() => {
        "meal_name": mealName,
        "category": category,
        "sub_category": subCategory,
        "total_calories": totalCalories,
        "macronutrients": macronutrients?.toJson(),
        "description": description,
        "ingredients": ingredients == null ? [] : List<dynamic>.from(ingredients!.map((x) => x.toJson())),
        "number_of_servings": numberOfServings,
        "image": image,
    };
}

class Ingredient {
    String? name;
    String? quantity;
    String? icon;

    Ingredient({
        this.name,
        this.quantity,
        this.icon,
    });

    factory Ingredient.fromRawJson(String str) => Ingredient.fromJson(json.decode(str));

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

    Macronutrients({
        this.carbohydrates,
        this.protein,
        this.fat,
    });

    factory Macronutrients.fromRawJson(String str) => Macronutrients.fromJson(json.decode(str));

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
