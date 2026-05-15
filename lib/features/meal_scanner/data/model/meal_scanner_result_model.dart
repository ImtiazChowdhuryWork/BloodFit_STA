import 'dart:convert';

class MealScannerResultModel {
    bool? success;
    int? status;
    String? message;
    Data? data;

    MealScannerResultModel({
        this.success,
        this.status,
        this.message,
        this.data,
    });

    factory MealScannerResultModel.fromRawJson(String str) => MealScannerResultModel.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory MealScannerResultModel.fromJson(Map<String, dynamic> json) => MealScannerResultModel(
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
    List<String>? identifiedIngredients;
    List<HarmfulIngredient>? harmfulIngredients;
    List<Ingredient>? neutralIngredients;
    List<Ingredient>? safeIngredients;
    String? warningMessage;
    String? neutralMessage;
    String? safeMessage;

    Data({
        this.identifiedIngredients,
        this.harmfulIngredients,
        this.neutralIngredients,
        this.safeIngredients,
        this.warningMessage,
        this.neutralMessage,
        this.safeMessage,
    });

    factory Data.fromRawJson(String str) => Data.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        identifiedIngredients: json["identified_ingredients"] == null ? [] : List<String>.from(json["identified_ingredients"]!.map((x) => x)),
        harmfulIngredients: json["harmful_ingredients"] == null ? [] : List<HarmfulIngredient>.from(json["harmful_ingredients"]!.map((x) => HarmfulIngredient.fromJson(x))),
        neutralIngredients: json["neutral_ingredients"] == null ? [] : List<Ingredient>.from(json["neutral_ingredients"]!.map((x) => Ingredient.fromJson(x))),
        safeIngredients: json["safe_ingredients"] == null ? [] : List<Ingredient>.from(json["safe_ingredients"]!.map((x) => Ingredient.fromJson(x))),
        warningMessage: json["warning_message"],
        neutralMessage: json["neutral_message"],
        safeMessage: json["safe_message"],
    );

    Map<String, dynamic> toJson() => {
        "identified_ingredients": identifiedIngredients == null ? [] : List<dynamic>.from(identifiedIngredients!.map((x) => x)),
        "harmful_ingredients": harmfulIngredients == null ? [] : List<dynamic>.from(harmfulIngredients!.map((x) => x.toJson())),
        "neutral_ingredients": neutralIngredients == null ? [] : List<dynamic>.from(neutralIngredients!.map((x) => x.toJson())),
        "safe_ingredients": safeIngredients == null ? [] : List<dynamic>.from(safeIngredients!.map((x) => x.toJson())),
        "warning_message": warningMessage,
        "neutral_message": neutralMessage,
        "safe_message": safeMessage,
    };
}

class HarmfulIngredient {
    String? name;
    String? reason;
    String? category;

    HarmfulIngredient({
        this.name,
        this.reason,
        this.category,
    });

    factory HarmfulIngredient.fromRawJson(String str) => HarmfulIngredient.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory HarmfulIngredient.fromJson(Map<String, dynamic> json) => HarmfulIngredient(
        name: json["name"],
        reason: json["reason"],
        category: json["category"],
    );

    Map<String, dynamic> toJson() => {
        "name": name,
        "reason": reason,
        "category": category,
    };
}

class Ingredient {
    String? name;

    Ingredient({
        this.name,
    });

    factory Ingredient.fromRawJson(String str) => Ingredient.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Ingredient.fromJson(Map<String, dynamic> json) => Ingredient(
        name: json["name"],
    );

    Map<String, dynamic> toJson() => {
        "name": name,
    };
}
